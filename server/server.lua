local VORPcore = exports.vorp_core:GetCore()
local T = Translation.Langs[Config.Lang]

local function registerStorage(bankName, bankId, invspace)
    local isRegistered = exports.vorp_inventory:isCustomInventoryRegistered(bankId)
    if not isRegistered then
        local data = {
            id = bankId,
            name = bankName,
            limit = invspace,
            acceptWeapons = Config.banks[bankName].canStoreWeapons,
            shared = true,
            ignoreItemStackLimit = true,
            webhook = "", -- add here your webhook url for discord logging
        }
        exports.vorp_inventory:registerInventory(data)
        Wait(200)
    end
end

local function IsNearBank(source, bankName)
    local playerPed = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(playerPed)
    local bankLocation = Config.banks[bankName].BankLocation
    local distance = #(playerCoords - vector3(bankLocation.x, bankLocation.y, bankLocation.z))

    if distance <= Config.banks[bankName].distOpen + 10.0 then -- Adjusted Distance check to make sure it's within range (if any bank is facing issue then you can increase this value)
        return true
    else
        return false
    end
end

VORPcore.Callback.Register('vorp_bank:getinfo', function(source, cb, bankName)
    local _source = source
    local Character = VORPcore.getUser(_source).getUsedCharacter
    local charidentifier = Character.charIdentifier
    local identifier = Character.identifier
    local allBanks = {}

    MySQL.query("SELECT * FROM bank_users WHERE charidentifier = @charidentifier AND name = @bankName",
        { charidentifier = charidentifier, bankName = bankName }, function(result)
            if result[1] then
                local money = result[1].money
                local gold = result[1].gold
                local invspace = result[1].invspace
                local bankinfo = { money = money, gold = gold, invspace = invspace, name = bankName }

                local allBanksResult = MySQL.query.await("SELECT * FROM bank_users WHERE charidentifier = @charidentifier", { charidentifier = charidentifier })
                if allBanksResult[1] then
                    allBanks = allBanksResult
                end

                return cb({ bankinfo, allBanks })
            else
                local defaultMoney = 0
                local defaultGold = 0
                local defaultInvspace = 10
                local parameters = {
                    name = bankName,
                    identifier = identifier,
                    charidentifier = charidentifier,
                    money = defaultMoney,
                    gold = defaultGold,
                    invspace = defaultInvspace
                }

                MySQL.insert.await("INSERT INTO bank_users ( `name`,`identifier`,`charidentifier`,`money`,`gold`,`invspace`) VALUES ( @name, @identifier, @charidentifier, @money, @gold, @invspace)", parameters)
                MySQL.query("SELECT * FROM bank_users WHERE charidentifier = @charidentifier AND name = @bankName", { charidentifier = charidentifier, bankName = bankName }, function(result1)
                    if result1[1] then
                        local money = defaultMoney
                        local gold = defaultGold
                        local invspace = defaultInvspace
                        local bankinfo = { money = money, gold = gold, invspace = invspace, name = bankName }

                        local allBanksResult = MySQL.query.await("SELECT * FROM bank_users WHERE charidentifier = @charidentifier", { charidentifier = charidentifier })
                        if allBanksResult[1] then
                            allBanks = allBanksResult
                        end
                        return cb({ bankinfo, allBanks })
                    end
                end)
            end
        end)
end)

RegisterServerEvent('vorp_bank:UpgradeSafeBox', function(slotsToBuy, currentspace, bankName)
    local _source        = source
    local Character      = VORPcore.getUser(_source).getUsedCharacter
    local charidentifier = Character.charIdentifier
    local money          = Character.money

    local maxslots       = Config.banks[bankName].maxslots
    local costslot       = Config.banks[bankName].costslot
    local name           = Config.banks[bankName].city

    local amountToPay    = costslot * slotsToBuy
    local FinalSlots     = currentspace + slotsToBuy

    if not IsNearBank(_source, bankName) then
        return VORPcore.NotifyRightTip(_source, T.notnear, 4000)
    end

    if money < amountToPay then
        return VORPcore.NotifyRightTip(_source, T.nomoney, 4000)
    end

    if FinalSlots > maxslots then
        return VORPcore.NotifyRightTip(_source, T.maxslots .. " | " .. slotsToBuy .. " / " .. maxslots, 4000)
    end

    Character.removeCurrency(0, amountToPay)
    local Parameters = { ['charidentifier'] = charidentifier, ['invspace'] = FinalSlots, ['name'] = name }
    MySQL.update("UPDATE bank_users SET invspace=@invspace WHERE charidentifier=@charidentifier AND name = @name", Parameters)
    local bankId = "vorp_banking_" .. bankName .. "_" .. charidentifier
    registerStorage(bankName, bankId, currentspace)
    exports.vorp_inventory:updateCustomInventorySlots(bankId, FinalSlots)
    VORPcore.NotifyRightTip(_source, T.success .. (costslot * slotsToBuy) .. " | " .. FinalSlots .. " / " .. maxslots, 4000)
end)

DiscordLogs = function(transactionAmount, bankName, playerName, transactionType, targetBankName, currencyType, itemName)
    local logTitle = T.Webhooks.LogTitle
    local webhookURL, logMessage = "", ""
    local currencySymbol = currencyType == "gold" and "G" or "$"

    if transactionType == "withdraw" then
        webhookURL = Config.WithdrawLogWebhook
        logMessage = string.format(T.Webhooks.WithdrawLogDescription, playerName, transactionAmount .. currencySymbol,
            bankName)
    elseif transactionType == "deposit" then
        webhookURL = Config.DepositLogWebhook
        logMessage = string.format(T.Webhooks.DepositLogDescription, playerName, transactionAmount .. currencySymbol,
            bankName)
    elseif transactionType == "transfer" then
        webhookURL = Config.TransferLogWebhook
        logMessage = string.format(T.Webhooks.TransferLogDescription, playerName, transactionAmount .. currencySymbol,
            bankName, targetBankName)
    elseif transactionType == "take" then
        webhookURL = Config.TakeLogWebhook
        logMessage = string.format(T.Webhooks.TakeLogDescription, playerName, transactionAmount, itemName, bankName)
    elseif transactionType == "move" then
        webhookURL = Config.MoveLogWebhook
        logMessage = string.format(T.Webhooks.MoveLogDescription, playerName, transactionAmount, itemName, bankName)
    end

    VORPcore.AddWebhook(logTitle, webhookURL, logMessage)
end

RegisterServerEvent('vorp_bank:transfer', function(amount, fromBank, toBank)
    local _source = source
    local Character = VORPcore.getUser(_source).getUsedCharacter
    local playerFullName = Character.firstname .. ' ' .. Character.lastname
    local characterId = Character.charIdentifier

    if not IsNearBank(_source, toBank) then
        return VORPcore.NotifyRightTip(_source, T.notnear, 4000)
    end

    local queryResult = MySQL.query.await("SELECT * FROM bank_users WHERE charidentifier = @characterId;", { characterId = characterId })
    local bankAccounts = {}
    if queryResult then
        for _, bank in pairs(queryResult) do
            bankAccounts[bank.name] = bank
        end

        if bankAccounts[fromBank].money > amount then
            local newBalanceFrom = bankAccounts[fromBank].money - amount
            local newBalanceTo = bankAccounts[toBank].money + (amount * 0.9)

            local updateFromResult = MySQL.query.await("UPDATE bank_users SET money = @newBalance WHERE charidentifier = @characterId AND name = @fromBank;", { newBalance = newBalanceFrom, characterId = characterId, fromBank = fromBank })

            if updateFromResult then
                local updateToResult = MySQL.query.await("UPDATE bank_users SET money = @newBalance WHERE charidentifier = @characterId AND name = @toBank;", { newBalance = newBalanceTo, characterId = characterId, toBank = toBank })

                if updateToResult then
                    local transferredAmount = amount * Config.feeamount
                    transferredAmount = string.format("%.2f", transferredAmount)
                    bankAccounts[toBank].money = string.format("%.2f", newBalanceTo)
                    bankAccounts[fromBank].money = string.format("%.2f", newBalanceFrom)
                    DiscordLogs(transferredAmount, fromBank, playerFullName, "transfer", toBank, "cash")
                    local msg = string.format(T.transfer .. "%s $" .. T.to .. "%s" .. T.transferred, transferredAmount, toBank)
                    VORPcore.NotifyRightTip(_source, msg, 4000)
                else
                    print("Second update failed.")
                end
            else
                print("First update failed.")
            end
        else
            VORPcore.NotifyRightTip(_source, T.noaccmoney, 4000)
        end
    end
end)

RegisterServerEvent('vorp_bank:depositcash', function(amount, bankName)
    local _source = source
    local playerCharacter = VORPcore.getUser(_source).getUsedCharacter
    local characterId = playerCharacter.charIdentifier
    local playerCash = playerCharacter.money

    if not IsNearBank(_source, bankName) then
        return VORPcore.NotifyRightTip(_source, T.notnear, 4000)
    end

    if playerCash >= amount then
        MySQL.query("SELECT money FROM bank_users WHERE charidentifier = @characterId AND name = @bankName", { characterId = characterId, bankName = bankName }, function(result)
            if result[1] then
                playerCharacter.removeCurrency(0, amount)
                DiscordLogs(amount, bankName, playerCharacter.firstname .. ' ' .. playerCharacter.lastname, "deposit", "cash")
                local newBalance = result[1].money + amount
                MySQL.update("UPDATE bank_users SET money=@newBalance WHERE charidentifier=@characterId AND name = @bankName", { characterId = characterId, newBalance = newBalance, bankName = bankName })
                VORPcore.NotifyRightTip(_source, T.youdepo .. amount, 4000)
            end
        end)
    else
        VORPcore.NotifyRightTip(_source, T.invalid, 4000)
    end
end)

RegisterServerEvent('vorp_bank:depositgold', function(amount, bankName)
    local _source = source
    local playerCharacter = VORPcore.getUser(_source).getUsedCharacter
    local characterId = playerCharacter.charIdentifier
    local playerGold = playerCharacter.gold

    if not IsNearBank(_source, bankName) then
        return VORPcore.NotifyRightTip(_source, T.notnear, 4000)
    end

    if playerGold >= amount then
        playerCharacter.removeCurrency(1, amount)
        MySQL.update("UPDATE bank_users SET gold = gold + @amount WHERE charidentifier = @characterId AND name = @bankName", { characterId = characterId, amount = amount, bankName = bankName })
        VORPcore.NotifyRightTip(_source, T.youdepog .. amount, 4000)
    else
        VORPcore.NotifyRightTip(_source, T.invalid, 4000)
    end
end)


local lastMoney = {}

RegisterServerEvent('vorp_bank:withcash', function(amount, bankName)
    local _source = source
    local Character = VORPcore.getUser(_source).getUsedCharacter
    local playerFullName = Character.firstname .. ' ' .. Character.lastname
    local characterId = Character.charIdentifier

    if not IsNearBank(_source, bankName) then
        return VORPcore.NotifyRightTip(_source, T.notnear, 4000)
    end

    MySQL.query("SELECT money FROM bank_users WHERE charidentifier = @characterId AND name = @bankName", { characterId = characterId, bankName = bankName }, function(result)
        if result[1] then
            local bankBalance = result[1].money
            if bankBalance >= amount then
                if not lastMoney[_source] or lastMoney[_source] ~= bankBalance then
                    local newBalance = bankBalance - amount
                    MySQL.update("UPDATE bank_users SET money=@newBalance WHERE charidentifier=@characterId AND name = @bankName", { characterId = characterId, newBalance = newBalance, bankName = bankName })
                    lastMoney[_source] = bankBalance
                    Character.addCurrency(0, amount)
                    DiscordLogs(amount, bankName, playerFullName, "withdraw", "cash")
                    VORPcore.NotifyRightTip(_source, T.withdrew .. amount, 4000)
                end
            else
                VORPcore.NotifyRightTip(_source, T.invalid .. amount, 4000)
            end
        end
    end)
end)

RegisterServerEvent('vorp_bank:withgold', function(amount, bankName)
    local _source = source
    local playerCharacter = VORPcore.getUser(_source).getUsedCharacter
    local playerFullName = playerCharacter.firstname .. ' ' .. playerCharacter.lastname
    local characterId = playerCharacter.charIdentifier

    if not IsNearBank(_source, bankName) then
        return VORPcore.NotifyRightTip(_source, T.notnear, 4000)
    end

    MySQL.query("SELECT gold FROM bank_users WHERE charidentifier = @characterId AND name = @bankName", { characterId = characterId, bankName = bankName }, function(result)
        if result[1] then
            local bankGold = result[1].gold
            if bankGold >= amount then
                local newGoldBalance = bankGold - amount
                MySQL.update("UPDATE bank_users SET gold = @newGoldBalance WHERE charidentifier = @characterId AND name = @bankName", { characterId = characterId, newGoldBalance = newGoldBalance, bankName = bankName })
                playerCharacter.addCurrency(1, amount)
                DiscordLogs(amount, bankName, playerFullName, "withdraw", "gold")
                VORPcore.NotifyRightTip(_source, T.withdrewg .. amount, 4000)
            else
                VORPcore.NotifyRightTip(_source, T.invalid, 4000)
            end
        end
    end)
end)


RegisterServerEvent("vorp_banking:server:OpenBankInventory", function(bankName)
    local _source = source
    local user = VORPcore.getUser(_source)
    if not user then return end

    local Character = user.getUsedCharacter
    local characterId = Character.charIdentifier
    local bankId = "vorp_banking_" .. bankName .. "_" .. characterId

    if not IsNearBank(_source, bankName) then
        return VORPcore.NotifyRightTip(_source, T.notnear, 4000)
    end

    -- Check database for invSpace server side.
    MySQL.scalar('SELECT `invspace` FROM `bank_users` WHERE `charidentifier` = @characterId AND `name` = @bankName LIMIT 1', {
        characterId = characterId, bankName = bankName
    }, function(invSpace)
        if invSpace then
            registerStorage(bankName, bankId, invSpace)
            exports.vorp_inventory:openInventory(_source, bankId)
        else
            VORPcore.NotifyRightTip(_source, T.invOpenFail, 4000)
        end
    end)
end)

AddEventHandler("playerDropped", function()
    local _source = source
    for key, _ in pairs(lastMoney) do
        if key == _source then
            lastMoney[key] = nil
            break
        end
    end
end)
