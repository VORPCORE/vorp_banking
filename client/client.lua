local VORPcore = exports.vorp_core:GetCore()
local prompts = GetRandomIntInRange(0, 0xffffff)
local PromptGroup2 = GetRandomIntInRange(0, 0xffffff)
local openmenu
local CloseBanks
local inmenu = false
local T = Translation.Langs[Config.Lang]
local MenuData = exports.vorp_menu:GetMenuData()

AddEventHandler("onResourceStop", function(resourceName)
    if resourceName == GetCurrentResourceName() then
        for _, v in pairs(Config.banks) do
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
        local blip = BlipAddForCoords(1664425300, Config.banks[index].BankLocation.x, Config.banks[index].BankLocation.y, Config.banks[index].BankLocation.z)
        SetBlipSprite(blip, Config.banks[index].blipsprite, true)
        SetBlipScale(blip, 0.2)
        SetBlipName(blip, Config.banks[index].name)
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
    local npc = CreatePed(joaat(v.NpcModel), v.NpcPosition.x, v.NpcPosition.y, v.NpcPosition.z, v.NpcPosition.h, false, false, false, false)
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
    openmenu = UiPromptRegisterBegin()
    UiPromptSetControlAction(openmenu, Config.Key)
    str = VarString(10, 'LITERAL_STRING', str)
    UiPromptSetText(openmenu, str)
    UiPromptSetEnabled(openmenu, true)
    UiPromptSetVisible(openmenu, true)
    UiPromptSetStandardMode(openmenu, true)
    UiPromptSetGroup(openmenu, prompts, 0)
    UiPromptRegisterEnd(openmenu)
end

local function PromptSetUp2()
    local str = T.closemenu
    CloseBanks = UiPromptRegisterBegin()
    UiPromptSetControlAction(CloseBanks, Config.Key)
    str = VarString(10, 'LITERAL_STRING', str)
    UiPromptSetText(CloseBanks, str)
    UiPromptSetEnabled(CloseBanks, true)
    UiPromptSetVisible(CloseBanks, true)
    UiPromptSetStandardMode(CloseBanks, true)
    UiPromptSetGroup(CloseBanks, PromptGroup2, 0)
    UiPromptRegisterEnd(CloseBanks)
end

local function getDistance(config)
    local coords = GetEntityCoords(PlayerPedId())
    local coords2 = vector3(config.x, config.y, config.z)
    return #(coords - coords2)
end

local function CreateNpcByDistance(distance, index)
    if Config.banks[index].NpcAllowed then
    if distance <= 40 then
        if not Config.banks[index].NPC then
            SpawnNPC(index)
        end
    else
        if Config.banks[index].NPC then
            SetEntityAsNoLongerNeeded(Config.banks[index].NPC)
            DeleteEntity(Config.banks[index].NPC)
            Config.banks[index].NPC = nil
        end
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
    repeat Wait(2000) until LocalPlayer.state.IsInSession
    PromptSetUp()
    PromptSetUp2()

    while true do
        local sleep = 1000
        local player = PlayerPedId()
        local dead = IsEntityDead(player)

        if not inmenu and not dead then
            for index, bankConfig in pairs(Config.banks) do
                if bankConfig.StoreHoursAllowed then
                    local hour = GetClockHours()
                    if hour >= bankConfig.StoreClose or hour < bankConfig.StoreOpen then
                        if not Config.banks[index].BlipHandle and bankConfig.blipAllowed then
                            AddBlip(index)
                        end

                        if Config.banks[index].BlipHandle then
                            BlipAddModifier(Config.banks[index].BlipHandle, joaat('BLIP_MODIFIER_MP_COLOR_10'))
                        end

                        if Config.banks[index].NPC then
                            DeleteEntity(Config.banks[index].NPC)
                            DeletePed(Config.banks[index].NPC)
                            SetEntityAsNoLongerNeeded(Config.banks[index].NPC)
                            Config.banks[index].NPC = nil
                        end

                        local distance = getDistance(bankConfig.BankLocation)

                        if distance <= bankConfig.distOpen then
                            sleep = 0
                            local label2 = VarString(10, 'LITERAL_STRING', T.openHours .. " " .. bankConfig.StoreOpen .. T.amTimeZone .. " - " .. bankConfig.StoreClose .. T.pmTimeZone)
                            UiPromptSetActiveGroupThisFrame(PromptGroup2, label2, 0, 0, 0, 0)

                            if UiPromptHasStandardModeCompleted(CloseBanks, 0) then
                                Wait(1000)
                                VORPcore.NotifyRightTip(T.closed, 4000)
                            end
                        end
                    elseif hour >= bankConfig.StoreOpen then
                        if not Config.banks[index].BlipHandle and bankConfig.blipAllowed then
                            AddBlip(index)
                        end

                        if Config.banks[index].BlipHandle then
                            BlipAddModifier(Config.banks[index].BlipHandle, joaat('BLIP_MODIFIER_MP_COLOR_32'))
                        end

                        local distance = getDistance(bankConfig.BankLocation)
                        CreateNpcByDistance(distance, index)
                        if distance <= bankConfig.distOpen then
                            sleep = 0

                            local label = VarString(10, 'LITERAL_STRING', T.bank .. " " .. bankConfig.name)
                            UiPromptSetActiveGroupThisFrame(prompts, label, 0, 0, 0, 0)

                            if UiPromptHasStandardModeCompleted(openmenu, 0) then
                                inmenu = true
                                GetBankInfo(bankConfig)
                            end
                        end
                    end
                else
                    local distance = getDistance(bankConfig.BankLocation)
                    if not Config.banks[index].BlipHandle and bankConfig.blipAllowed then
                        AddBlip(index)
                    end

                    CreateNpcByDistance(distance, index)

                    if distance <= bankConfig.distOpen then
                        sleep = 0
                        local label = VarString(10, 'LITERAL_STRING', T.bank .. " " .. bankConfig.name)
                        UiPromptSetActiveGroupThisFrame(prompts, label, 0, 0, 0, 0)

                        if UiPromptHasStandardModeCompleted(openmenu, 0) then
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
        function(data, _)
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
                if bankinfo.invspace > 0 then
                    TriggerServerEvent("vorp_banking:server:OpenBankInventory", bankName)
                    CloseMenu()
                else
                    VORPcore.NotifyRightTip(" you need to buy slots first", 4000)
                end
            end

            if (data.current.value == 'upitem') then
                local invspace = bankinfo.invspace
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
                        TriggerServerEvent("vorp_bank:UpgradeSafeBox", math.floor(result), invspace, bankName)
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
        function()
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
        function(data, _)
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
        function()
            Openbank(bankName, allbanks)
        end)
end
