local VORPcore = exports.vorp_core:GetCore()
local prompts = GetRandomIntInRange(0, 0xffffff)
local PromptGroup2 = GetRandomIntInRange(0, 0xffffff)
local openmenu
local CloseBanks
local inmenu = false
local T = Translation.Langs[Config.Lang]

TriggerEvent("menuapi:getData", function(call)
    MenuData = call
end)

AddEventHandler("onResourceStop", function(resourceName)
    if resourceName == GetCurrentResourceName() then
        for i, v in pairs(Config.banks) do
            if v.BlipHandle then
                RemoveBlip(v.BlipHandle)
            end
            if v.NPC then
                DeleteEntity(v.NPC)
                DeletePed(v.NPC)
                SetEntityAsNoLongerNeeded(v.NPC)
            end
        end
        DisplayRadar(true)
        MenuData.CloseAll()
        inmenu = false
        ClearPedTasks(PlayerPedId())
    end
end)

---------------- BLIPS ---------------------
local function AddBlip(index)
    if Config.banks[index].blipAllowed then
        local blip = N_0x554d9d53f696d002(1664425300, Config.banks[index].x, Config.banks[index].y, Config.banks[index].z)
        SetBlipSprite(blip, Config.banks[index].blipsprite, true)
        SetBlipScale(blip, 0.2)
        Citizen.InvokeNative(0x9CB1A1623062F402, blip, Config.banks[index].name)
        Config.banks[index].BlipHandle = blip
    end
end

---------------- NPC ---------------------
local function LoadModel(model)
    if not HasModelLoaded(model) then
        RequestModel(model, false)
        repeat Wait(0) until HasModelLoaded(model)
    end
end

local function SpawnNPC(index)
    local v = Config.banks[index]
    LoadModel(v.NpcModel)
    local npc = CreatePed(joaat(v.NpcModel), v.Nx, v.Ny, v.Nz, v.Nh, false, false, false, false)
    repeat Wait(0) until DoesEntityExist(npc)
    PlaceEntityOnGroundProperly(npc, true)
    Citizen.InvokeNative(0x283978A15512B2FE, npc, true)
    SetEntityCanBeDamaged(npc, false)
    SetEntityInvincible(npc, true)
    Wait(1000)
    TaskStandStill(npc, -1)
    SetBlockingOfNonTemporaryEvents(npc, true)
    SetModelAsNoLongerNeeded(v.NpcModel)
    Config.banks[index].NPC = npc
end

local function PromptSetUp()
    local str = T.openmenu
    openmenu = PromptRegisterBegin()
    PromptSetControlAction(openmenu, Config.Key)
    str = CreateVarString(10, 'LITERAL_STRING', str)
    PromptSetText(openmenu, str)
    PromptSetEnabled(openmenu, 1)
    PromptSetVisible(openmenu, 1)
    PromptSetStandardMode(openmenu, 1)
    PromptSetGroup(openmenu, prompts)
    Citizen.InvokeNative(0xC5F428EE08FA7F2C, openmenu, true)
    PromptRegisterEnd(openmenu)
end

local function PromptSetUp2()
    local str = T.closemenu
    CloseBanks = PromptRegisterBegin()
    PromptSetControlAction(CloseBanks, Config.Key)
    str = CreateVarString(10, 'LITERAL_STRING', str)
    PromptSetText(CloseBanks, str)
    PromptSetEnabled(CloseBanks, 1)
    PromptSetVisible(CloseBanks, 1)
    PromptSetStandardMode(CloseBanks, 1)
    PromptSetGroup(CloseBanks, PromptGroup2)
    Citizen.InvokeNative(0xC5F428EE08FA7F2C, CloseBanks, true)
    PromptRegisterEnd(CloseBanks)
end

local function getDistance(config)
    local coords = GetEntityCoords(PlayerPedId())
    local coords2 = vector3(config.x, config.y, config.z)
    return #(coords - coords2)
end

local function CreateNpcByDistance(distance, index)
    if distance <= 40 then
        if not Config.banks[index].NPC then
            SpawnNPC(index)
        end
    else
        if Config.banks[index].NPC then
            DeleteEntity(Config.banks[index].NPC)
            DeletePed(Config.banks[index].NPC)
            SetEntityAsNoLongerNeeded(Config.banks[index].NPC)
            Config.banks[index].NPC = nil
        end
    end
end

local function GetBankInfo(bankConfig)
    local result = VORPcore.Callback.TriggerAwait("vorp_bank:getinfo", bankConfig.city)
    Openbank(bankConfig.city, result[1], result[2])
    TaskStandStill(PlayerPedId(), -1)
    DisplayRadar(false)
end

CreateThread(function()
    repeat Wait(0) until LocalPlayer.state.IsInSession
    PromptSetUp()
    PromptSetUp2()
    while true do
        local sleep = 1000
        local player = PlayerPedId()
        local hour = GetClockHours()
        local dead = IsEntityDead(player)

        if not inmenu and not dead then
            for index, bankConfig in pairs(Config.banks) do
                if bankConfig.StoreHoursAllowed then
                    if hour >= bankConfig.StoreClose or hour < bankConfig.StoreOpen then
                        if not Config.banks[index].BlipHandle and bankConfig.blipAllowed then
                            AddBlip(index)
                        end

                        if Config.banks[index].BlipHandle then
                            Citizen.InvokeNative(0x662D364ABF16DE2F, Config.banks[index].BlipHandle,
                                joaat('BLIP_MODIFIER_MP_COLOR_10'))
                        end

                        if Config.banks[index].NPC then
                            DeleteEntity(Config.banks[index].NPC)
                            DeletePed(Config.banks[index].NPC)
                            SetEntityAsNoLongerNeeded(Config.banks[index].NPC)
                            Config.banks[index].NPC = nil
                        end

                        local distance = getDistance(bankConfig)

                        if distance <= bankConfig.distOpen then
                            sleep = 0
                            local label2 = CreateVarString(10, 'LITERAL_STRING', T.openHours .. " " ..
                                bankConfig.StoreOpen .. T.amTimeZone .. " - " .. bankConfig.StoreClose .. T.pmTimeZone)

                            PromptSetActiveGroupThisFrame(PromptGroup2, label2)

                            if Citizen.InvokeNative(0xC92AC953F0A982AE, CloseBanks) then
                                Wait(1000)
                                VORPcore.NotifyRightTip(T.closed, 4000)
                            end
                        end
                    elseif hour >= bankConfig.StoreOpen then
                        if not Config.banks[index].BlipHandle and bankConfig.blipAllowed then
                            AddBlip(index)
                        end

                        if Config.banks[index].BlipHandle then
                            Citizen.InvokeNative(0x662D364ABF16DE2F, Config.banks[index].BlipHandle,
                                joaat('BLIP_MODIFIER_MP_COLOR_32'))
                        end

                        local distance = getDistance(bankConfig)
                        CreateNpcByDistance(distance, index)
                        if distance <= bankConfig.distOpen then
                            sleep = 0

                            local label = CreateVarString(10, 'LITERAL_STRING', T.bank .. " " .. bankConfig.name)
                            PromptSetActiveGroupThisFrame(prompts, label)

                            if Citizen.InvokeNative(0xC92AC953F0A982AE, openmenu) then
                                inmenu = true
                                GetBankInfo(bankConfig)
                            end
                        end
                    end
                else
                    local distance = getDistance(bankConfig)
                    if not Config.banks[index].BlipHandle and bankConfig.blipAllowed then
                        AddBlip(index)
                    end

                    CreateNpcByDistance(distance, index)

                    if distance <= bankConfig.distOpen then
                        sleep = 0
                        local label = CreateVarString(10, 'LITERAL_STRING', T.bank .. " " .. bankConfig.name)
                        PromptSetActiveGroupThisFrame(prompts, label)

                        if Citizen.InvokeNative(0xC92AC953F0A982AE, openmenu) then
                            inmenu = true
                            GetBankInfo(bankConfig)
                        end
                    end
                end
            end
        end
        Wait(sleep)
    end
end)

local function CloseMenu()
    MenuData.CloseAll()
    inmenu = false
    ClearPedTasks(PlayerPedId())
    DisplayRadar(true)
end

function Openbank(bankName, bankinfo, allbanks)
    MenuData.CloseAll()
    if not bankinfo.money then
        CloseMenu()
        return
    end

    local elements = {
        { label = T.cashbalance .. bankinfo.money, value = 'nothing', desc = T.cashbalance2 },
        { label = T.depocash,                      value = 'dcash',   desc = T.depocash2 },
        { label = T.takecash,                      value = 'wcash',   desc = T.takecash2 }
    }

    if Config.banktransfer and #allbanks > 1 then
        elements[#elements + 1] = {
            label = T.bankacc,
            value = 'others',
            desc = T.bankaccinfo
        }
    end

    if Config.banks[bankName].items then
        elements[#elements + 1] = {
            label = T.depoitem,
            value = 'bitem',
            desc = T.depoitem2 .. bankinfo.invspace
        }
    end

    if Config.banks[bankName].upgrade then
        elements[#elements + 1] = {
            label = T.upgradeitem,
            value = 'upitem',
            desc = T.upgradeitem2 .. Config.banks[bankName].costslot
        }
    end

    if Config.banks[bankName].gold then
        elements[#elements + 1] = {
            label = T.goldbalance .. bankinfo.gold,
            value = 'nothing',
            desc = T.cashbalance2
        }
        elements[#elements + 1] = {
            label = T.depogold,
            value = 'dgold',
            desc = T.depogold2
        }
        elements[#elements + 1] = {
            label = T.takegold,
            value = 'wgold',
            desc = T.takegold2
        }
    end


    MenuData.Open('default', GetCurrentResourceName(), 'Openbank' .. bankName,
        {
            title    = bankName,
            subtext  = T.welcome,
            align    = 'top-left',
            elements = elements,
        },
        function(data, menu)
            if (data.current.value == 'dcash') then
                local myInput = {
                    type = "enableinput",                                               -- don't touch
                    inputType = "input",                                                -- input type
                    button = T.inputsLang.confirmCash,                                  -- button name
                    placeholder = T.inputsLang.insertAmountCash,                        -- placeholder name
                    style = "block",                                                    -- don't touch
                    attributes = {
                        inputHeader = T.inputsLang.depositCash,                         -- header
                        type = "text",                                                  -- inputype text, number,date,textarea
                        pattern = "[0-9.]{1,10}",                                       -- only numbers "[0-9]" | for letters only "[A-Za-z]+"
                        title = T.inputsLang.numOnlyCash,                               -- if input doesnt match show this message
                        style = "border-radius: 10px; background-color: ; border:none;" -- style
                    }
                }

                TriggerEvent("vorpinputs:advancedInput", json.encode(myInput), function(cb)
                    local result = tonumber(cb)
                    if result ~= nil and result > 0 then
                        TriggerServerEvent("vorp_bank:depositcash", result, Config.banks[bankName].city, bankinfo)
                        CloseMenu()
                    else
                        VORPcore.NotifyRightTip(T.invalid, 4000)
                    end
                end)
            end
            if (data.current.value == 'dgold') then
                local myInput = {
                    type = "enableinput",                                               -- don't touch
                    inputType = "input",                                                -- input type
                    button = T.inputsLang.confirmGold,                                  -- button name
                    placeholder = T.inputsLang.insertAmountGold,                        -- placeholder name
                    style = "block",                                                    -- don't touch
                    attributes = {
                        inputHeader = T.inputsLang.depositGold,                         -- header
                        type = "text",                                                  -- inputype text, number,date,textarea
                        pattern = "[0-9.]{1,10}",                                       -- only numbers "[0-9]" | for letters only "[A-Za-z]+"
                        title = T.inputsLang.numOnlyGold,                               -- if input doesnt match show this message
                        style = "border-radius: 10px; background-color: ; border:none;" -- style
                    }
                }

                TriggerEvent("vorpinputs:advancedInput", json.encode(myInput), function(cb)
                    local result = tonumber(cb)
                    if result ~= nil and result > 0 then
                        TriggerServerEvent("vorp_bank:depositgold", result, Config.banks[bankName].city, bankinfo)
                        CloseMenu()
                    else
                        VORPcore.NotifyRightTip(T.invalid, 4000)
                    end
                end)
            end
            if (data.current.value == 'wcash') then
                local myInput = {
                    type = "enableinput",                                               -- don't touch
                    inputType = "input",                                                -- input type
                    button = T.inputsLang.confirmCashW,                                 -- button name
                    placeholder = T.inputsLang.insertAmountCashW,                       -- placeholder name
                    style = "block",                                                    -- don't touch
                    attributes = {
                        inputHeader = T.inputsLang.withdrawCash,                        -- header
                        type = "text",                                                  -- inputype text, number,date,textarea
                        pattern = "[0-9.]{1,10}",                                       -- only numbers "[0-9]" | for letters only "[A-Za-z]+"
                        title = T.inputsLang.numOnlyCashW,                              -- if input doesnt match show this message
                        style = "border-radius: 10px; background-color: ; border:none;" -- style
                    }
                }

                TriggerEvent("vorpinputs:advancedInput", json.encode(myInput), function(cb)
                    local result = tonumber(cb)
                    if result ~= nil and result > 0 then
                        TriggerServerEvent("vorp_bank:withcash", result, Config.banks[bankName].city, bankinfo)
                        CloseMenu()
                    else
                        VORPcore.NotifyRightTip(T.invalid, 4000)
                    end
                end)
            end
            if (data.current.value == 'wgold') then
                local myInput = {
                    type = "enableinput",                                               -- don't touch
                    inputType = "input",                                                -- input type
                    button = T.inputsLang.confirmGoldW,                                 -- button name
                    placeholder = T.inputsLang.insertAmountGoldW,                       -- placeholder name
                    style = "block",                                                    -- don't touch
                    attributes = {
                        inputHeader = T.inputsLang.withdrawGold,                        -- header
                        type = "text",                                                  -- inputype text, number,date,textarea
                        pattern = "[0-9.]{1,10}",                                       -- only numbers "[0-9]" | for letters only "[A-Za-z]+"
                        title = T.inputsLang.numOnlyGoldW,                              -- if input doesnt match show this message
                        style = "border-radius: 10px; background-color: ; border:none;" -- style
                    }
                }

                TriggerEvent("vorpinputs:advancedInput", json.encode(myInput), function(cb)
                    local result = tonumber(cb)
                    if result ~= nil and result > 0 then
                        TriggerServerEvent("vorp_bank:withgold", result, Config.banks[bankName].city, bankinfo)
                        CloseMenu()
                    else
                        VORPcore.NotifyRightTip(T.invalid, 4000)
                    end
                end)
            end
            if (data.current.value == 'bitem') then
                TriggerServerEvent("vorp_bank:ReloadBankInventory", Config.banks[bankName].city)
                Wait(300)
                TriggerEvent("vorp_inventory:OpenBankInventory", T.namebank, Config.banks[bankName].city, bankinfo.invspace)
                CloseMenu()
            end

            if (data.current.value == 'upitem') then
                local invspace = bankinfo.invspace
                local maxslots = Config.banks[bankName].maxslots
                local costslot = Config.banks[bankName].costslot
                local myInput = {
                    type = "enableinput",                                               -- don't touch
                    inputType = "input",                                                -- input type
                    button = T.inputsLang.confirmUp,                                    -- button name
                    placeholder = T.inputsLang.insertAmountUp,                          -- placeholder name
                    style = "block",                                                    -- don't touch
                    attributes = {
                        inputHeader = T.inputsLang.upgradeSlots,                        -- header
                        type = "text",                                                  -- inputype text, number,date,textarea
                        pattern = "[0-9]{1,10}",                                        --  only numbers "[0-9]" | for letters only "[A-Za-z]+"
                        title = T.inputsLang.numOnlyUp,                                 -- if input doesnt match show this message
                        style = "border-radius: 10px; background-color: ; border:none;" -- style
                    }
                }

                TriggerEvent("vorpinputs:advancedInput", json.encode(myInput), function(cb)
                    local result = tonumber(cb)
                    if result ~= nil and result > 0 then
                        TriggerServerEvent("vorp_bank:UpgradeSafeBox", costslot, maxslots, math.floor(result), Config.banks[bankName].city, invspace)
                        CloseMenu()
                    else
                        VORPcore.NotifyRightTip(T.invalid, 4000)
                    end
                end)
            end
            if (data.current.value == 'others') then
                Openallbanks(bankName, allbanks)
            end
        end,
        function(data, menu)
            CloseMenu()
        end)
end

function Openallbanks(bankName, allbanks)
    MenuData.CloseAll()
    local elements = {}

    for _, bank in pairs(allbanks) do
        if bankName ~= bank.name then
            table.insert(elements,
                {
                    label = bank.name .. " : " .. bank.money .. "$",
                    value = 'transfer',
                    desc = T.transferinfo,
                    info = bank.name
                })
        end
    end

    MenuData.Open('default', GetCurrentResourceName(), 'Openallbanks' .. bankName,
        {
            title    = bankName,
            subtext  = T.welcome,
            align    = 'top-left',
            elements = elements,
        },
        function(data, menu)
            if (data.current.value == 'transfer') then
                local myInput = {
                    type = "enableinput",                                               -- don't touch
                    inputType = "input",                                                -- input type
                    button = T.inputsLang.Transfer,                                     -- button name
                    placeholder = T.inputsLang.insertAmountCash,                        -- placeholder name
                    style = "block",                                                    -- don't touch
                    attributes = {
                        inputHeader = T.inputsLang.depositTransfer,                     -- header
                        type = "text",                                                  -- inputype text, number,date,textarea
                        pattern = "[0-9.]{1,10}",                                       -- only numbers "[0-9]" | for letters only "[A-Za-z]+"
                        title = T.inputsLang.numOnlyCash,                               -- if input doesnt match show this message
                        style = "border-radius: 10px; background-color: ; border:none;" -- style
                    }
                }
                TriggerEvent("vorpinputs:advancedInput", json.encode(myInput), function(cb)
                    local result = tonumber(cb)
                    if result ~= nil and result > 0 then
                        TriggerServerEvent("vorp_bank:transfer", result, data.current.info, bankName)
                    else
                        VORPcore.NotifyRightTip(T.invalid, 4000)
                    end
                end)
            end
        end,
        function(data, menu)
            Openbank(bankName, allbanks)
        end)
end

-- open doors
CreateThread(function()
    if not Config.UseDoorSystem then
        return
    end
    repeat Wait(0) until LocalPlayer.state.IsInSession

    for door, state in pairs(Config.Doors) do
        if not IsDoorRegisteredWithSystem(door) then
            Citizen.InvokeNative(0xD99229FE93B46286, door, 1, 1, 0, 0, 0, 0)
        end
        DoorSystemSetDoorState(door, state)
    end
end)
