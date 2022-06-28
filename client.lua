local prompts = GetRandomIntInRange(0, 0xffffff)
local openmenu
local inmenu = false
local bank
local bankinfo
local blips = {}

TriggerEvent("menuapi:getData", function(call)
    MenuData = call
end)

AddEventHandler('menuapi:closemenu', function()
    if inmenu then
        inmenu = false
        bankinfo = nil
        ClearPedTasks(PlayerPedId())
    end
end)

Citizen.CreateThread(function()
    Citizen.Wait(1000)
    for k, bankConfig in pairs(Config.banks) do
        local blip = N_0x554d9d53f696d002(1664425300, bankConfig.x, bankConfig.y, bankConfig.z)
        SetBlipSprite(blip, bankConfig.blipsprite, 1)
        SetBlipScale(blip, 1.5)
        Citizen.InvokeNative(0x9CB1A1623062F402, blip, bankConfig.name)
        blips[#blips + 1] = blip
    end
end)


AddEventHandler("onResourceStop", function(resourceName)
    if resourceName == GetCurrentResourceName() then
        for k, v in pairs(blips) do
            RemoveBlip(v)
        end
        MenuData.CloseAll()
        inmenu = false
        ClearPedTasks(PlayerPedId())
    end
end)


Citizen.CreateThread(function()
    Citizen.Wait(5000)
    local str = Config.language.openmenu
    openmenu = PromptRegisterBegin()
    PromptSetControlAction(openmenu, Config.keys["G"])
    str = CreateVarString(10, 'LITERAL_STRING', str)
    PromptSetText(openmenu, str)
    PromptSetEnabled(openmenu, 1)
    PromptSetVisible(openmenu, 1)
    PromptSetStandardMode(openmenu, 1)
    PromptSetGroup(openmenu, prompts)
    Citizen.InvokeNative(0xC5F428EE08FA7F2C, openmenu, true)
    PromptRegisterEnd(openmenu)
end)

RegisterNetEvent("vorp_bank:recinfo")
AddEventHandler("vorp_bank:recinfo", function(data)
    bankinfo = data
end)

RegisterNetEvent("vorp_bank:ready")
AddEventHandler("vorp_bank:ready", function()
    inmenu = false
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local sleep = true
        local coords = GetEntityCoords(PlayerPedId())
        if not inmenu then
            for index, bankConfig in pairs(Config.banks) do
                local coordsDist = vector3(coords.x, coords.y, coords.z)
                local coordsStore = vector3(bankConfig.x, bankConfig.y, bankConfig.z)
                local distance = #(coordsDist - coordsStore)

                if distance <= 1.5 then
                    sleep = false

                    local label = CreateVarString(10, 'LITERAL_STRING', Config.language.bank)
                    PromptSetActiveGroupThisFrame(prompts, label)

                    if Citizen.InvokeNative(0xC92AC953F0A982AE, openmenu) then
                        inmenu = true
                        bank = bankConfig.city
                        TriggerServerEvent("vorp_bank:getinfo", bank)
                        while bankinfo == nil do
                            Citizen.Wait(500)
                        end
                        TaskStandStill(PlayerPedId(), -1)
                        Openbank(bankConfig.name)
                    end
                end
            end
        end
        if sleep then
            Citizen.Wait(500)
        end
    end
end)

function Openbank(bankName)
    MenuData.CloseAll()

    local elements = {
        { label = Config.language.cashbalance .. bankinfo.money, value = 'nothing', desc = Config.language.cashbalance2 },
        { label = Config.language.depocash, value = 'dcash', desc = Config.language.depocash2 },
        { label = Config.language.takecash, value = 'wcash', desc = Config.language.takecash2 },
        { label = Config.language.depoitem, value = 'bitem', desc = Config.language.depoitem2 .. bankinfo.invspace },
        { label = Config.language.upgradeitem, value = 'upitem', desc = Config.language.upgradeitem2 }

    }
    if Config.gold then
        elements[#elements + 1] = { label = Config.language.goldbalance .. bankinfo.gold, value = 'nothing',
            desc = Config.language.cashbalance2 }
        elements[#elements + 1] = { label = Config.language.depogold, value = 'dgold', desc = Config.language.depogold2 }
        elements[#elements + 1] = { label = Config.language.takegold, value = 'wgold', desc = Config.language.takegold2 }
    end



    MenuData.Open('default', GetCurrentResourceName(), 'menuapi',
    {
        title    = bankName,
        subtext  = Config.language.welcome,
        align    = 'top-left',
        elements = elements,
    },
    function(data, menu)
        if (data.current.value == 'dcash') then
            TriggerEvent("vorpinputs:getInput", Config.language.confirm, Config.language.amount, function(cb)
                local amount = tonumber(cb)
                if amount and amount > 0 then
                    TriggerServerEvent("vorp_bank:depositcash", amount, bank)
                else
                    TriggerEvent("vorp:TipBottom", Config.language.invalid, 6000)
                    inmenu = false
                end
            end)
            MenuData.CloseAll()
            bankinfo = nil
            ClearPedTasks(PlayerPedId())
        end
        if (data.current.value == 'dgold') then
            TriggerEvent("vorpinputs:getInput", Config.language.confirm, Config.language.amount, function(cb)
                local amount = tonumber(cb)
                if amount and amount > 0 then
                    TriggerServerEvent("vorp_bank:depositgold", amount, bank)
                else
                    TriggerEvent("vorp:TipBottom", Config.language.invalid, 6000)
                    inmenu = false
                end
            end)
            MenuData.CloseAll()
            bankinfo = nil
            ClearPedTasks(PlayerPedId())
        end
        if (data.current.value == 'wcash') then
            TriggerEvent("vorpinputs:getInput", Config.language.confirm, Config.language.amount, function(cb)
                local amount = tonumber(cb)
                if amount and amount > 0 then
                    TriggerServerEvent("vorp_bank:withcash", amount, bank)
                else
                    TriggerEvent("vorp:TipBottom", Config.language.invalid, 6000)
                    inmenu = false
                end
            end)
            MenuData.CloseAll()
            bankinfo = nil
            ClearPedTasks(PlayerPedId())
        end
        if (data.current.value == 'wgold') then
            TriggerEvent("vorpinputs:getInput", Config.language.confirm, Config.language.amount, function(cb)
                local amount = tonumber(cb)
                if amount and amount > 0 then
                    TriggerServerEvent("vorp_bank:withgold", amount, bank)
                else
                    TriggerEvent("vorp:TipBottom", Config.language.invalid, 6000)
                    inmenu = false
                end
            end)
            MenuData.CloseAll()
            bankinfo = nil
            ClearPedTasks(PlayerPedId())
        end
        if (data.current.value == 'bitem') then
            TriggerServerEvent("vorp_bank:ReloadBankInventory", bank)
            TriggerEvent("vorp_inventory:OpenBankInventory", Config.language.namebank, bank, bankinfo.invspace)
            MenuData.CloseAll()
            bankinfo = nil
            ClearPedTasks(PlayerPedId())
            inmenu = false
        end
        if (data.current.value == 'upitem') then
            local invspace = bankinfo.invspace
            TriggerEvent("vorpinputs:getInput", Config.language.confirm, Config.language.amount, function(cb)
                local amount = tonumber(cb)
                if amount and amount > 0 then
                    TriggerServerEvent("vorp_bank:UpgradeSafeBox", amount, bank, invspace)
                else
                    TriggerEvent("vorp:TipBottom", Config.language.invalid, 6000)
                    inmenu = false
                end
            end)
            MenuData.CloseAll()
            bankinfo = nil
            ClearPedTasks(PlayerPedId())
            inmenu = false
        end
    end,
    function(data, menu)
        menu.close()
    end)
end
