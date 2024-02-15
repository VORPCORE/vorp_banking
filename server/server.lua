local VORPcore = exports.vorp_core:GetCore()
local lastMoney = {}
local T = Translation.Langs[Config.Lang]

RegisterServerEvent('vorp_bank:getinfo')
AddEventHandler('vorp_bank:getinfo', function(name)
    local _source = source
    local Character = VORPcore.getUser(_source).getUsedCharacter
    local charidentifier = Character.charIdentifier
    local identifier = Character.identifier
    local allBanks = {}

    MySQL.query("SELECT * FROM bank_users WHERE charidentifier = @charidentifier AND name = @name", { ["@charidentifier"] = charidentifier, ["@name"] = name }, function(result)
            if result[1] then
                local money = result[1].money
                local gold = result[1].gold
                local invspace = result[1].invspace
                local bankinfo = { money = money, gold = gold, invspace = invspace, name = name }

                local allBanksResult = MySQL.query.await("SELECT * FROM bank_users WHERE charidentifier = @charidentifier", { ["@charidentifier"] = charidentifier })
                if allBanksResult[1] then
                    allBanks = allBanksResult
                end

                TriggerClientEvent("vorp_bank:recinfo", _source, bankinfo, name, allBanks)
            else
                local defaultMoney = 0
                local defaultGold = 0
                local defaultInvspace = 10
                local parameters = {
                    ['name'] = name,
                    ['identifier'] = identifier,
                    ['charidentifier'] = charidentifier,
                    ['money'] = defaultMoney,
                    ['gold'] = defaultGold,
                    ['invspace'] = defaultInvspace
                }

                MySQL.insert("INSERT INTO bank_users ( `name`,`identifier`,`charidentifier`,`money`,`gold`,`invspace`) VALUES ( @name, @identifier, @charidentifier, @money, @gold, @invspace)", parameters)

                Wait(200)

                MySQL.query("SELECT * FROM bank_users WHERE charidentifier = @charidentifier AND name = @name", { ["@charidentifier"] = charidentifier, ["@name"] = name }, function(result1)
                    if result1[1] then
                        local money = defaultMoney
                        local gold = defaultGold
                        local invspace = defaultInvspace
                        local bankinfo = { money = money, gold = gold, invspace = invspace, name = name }

                        local allBanksResult = MySQL.query.await("SELECT * FROM bank_users WHERE charidentifier = @charidentifier", { ["@charidentifier"] = charidentifier })
                        if allBanksResult[1] then
                            allBanks = allBanksResult
                        end

                        TriggerClientEvent("vorp_bank:recinfo", _source, bankinfo, name, allBanks)
                    end
                end)
            end
        end)
end)

RegisterServerEvent('vorp_bank:UpgradeSafeBox')
AddEventHandler('vorp_bank:UpgradeSafeBox', function(costlot, maxslots, slotsBought, name, currentspace)
    local _source = source
    local Character = VORPcore.getUser(_source).getUsedCharacter
    local charidentifier = Character.charIdentifier
    local money = Character.money

    local amountToPay = costlot * slotsBought
    local FinalSlots = currentspace + slotsBought

    if money < amountToPay then
        return VORPcore.NotifyRightTip(_source, T.nomoney, 4000)
    end

    if FinalSlots > maxslots then
        return VORPcore.NotifyRightTip(_source, T.maxslots .. " | " .. slotsBought .. " / " .. maxslots, 4000)
    end

    Character.removeCurrency(0, amountToPay)
    local Parameters = { ['charidentifier'] = charidentifier, ['invspace'] = FinalSlots, ['name'] = name }
    MySQL.update("UPDATE bank_users SET invspace=@invspace WHERE charidentifier=@charidentifier AND name = @name", Parameters)

    VORPcore.NotifyRightTip(_source, T.success .. (costlot * slotsBought) .. " | " .. FinalSlots .. " / " .. maxslots, 4000)
end)

DiscordLogs = function(transactionAmount, bankName, playerName, transactionType, targetBankName)
    local logTitle = T.Webhooks.LogTitle
    local webhookURL, logMessage = "", ""

    if transactionType == "withdraw" then
        webhookURL = Config.WithdrawLogWebhook
        logMessage = string.format(T.Webhooks.WithdrawLogDescription, playerName, transactionAmount, bankName)
    elseif transactionType == "deposit" then
        webhookURL = Config.DepositLogWebhook
        logMessage = string.format(T.Webhooks.DepositLogDescription, playerName, transactionAmount, bankName)
    elseif transactionType == "transfer" then
        webhookURL = Config.TransferLogWebhook
        logMessage = string.format(T.Webhooks.TransferLogDescription, playerName, transactionAmount, bankName, targetBankName)
    end

    VORPcore.AddWebhook(logTitle, webhookURL, logMessage)
end

RegisterServerEvent('vorp_bank:transfer')
AddEventHandler('vorp_bank:transfer', function(amount, fromBank, toBank)
    local _source = source
    local Character = VORPcore.getUser(_source).getUsedCharacter
    local playerFullName = Character.firstname .. ' ' .. Character.lastname
    local characterId = Character.charIdentifier

    local queryResult = MySQL.query.await("SELECT * FROM bank_users WHERE charidentifier = @charidentifier;", { ["@charidentifier"] = characterId })

    local bankAccounts = {}
    local allBankAccounts = {}

    if queryResult then
        allBankAccounts = queryResult
        for _, bank in pairs(queryResult) do
            bankAccounts[bank.name] = bank
        end

        if bankAccounts[fromBank].money > amount then
            local newBalanceFrom = bankAccounts[fromBank].money - amount
            local newBalanceTo = bankAccounts[toBank].money + (amount * 0.9)

            local updateFromResult = MySQL.query.await("UPDATE bank_users SET money = @newBalance WHERE charidentifier = @charidentifier AND name = @fromBank;", { ["@newBalance"] = newBalanceFrom, ["@charidentifier"] = characterId, ["@fromBank"] = fromBank })

            if updateFromResult then
                local updateToResult = MySQL.query.await("UPDATE bank_users SET money = @newBalance WHERE charidentifier = @charidentifier AND name = @toBank;", { ["@newBalance"] = newBalanceTo, ["@charidentifier"] = characterId, ["@toBank"] = toBank })

                if updateToResult then
                    local transferredAmount = amount * Config.feeamount
                    transferredAmount = string.format("%.2f", transferredAmount)
                    bankAccounts[toBank].money = string.format("%.2f", newBalanceTo)
                    bankAccounts[fromBank].money = string.format("%.2f", newBalanceFrom)
                    DiscordLogs(transferredAmount, fromBank, playerFullName, "transfer", toBank)
                    local msg = string.format(T.transfer .. "%s $" .. T.to .. "%s" .. T.transferred, transferredAmount, toBank)
                    VORPcore.NotifyRightTip(_source, msg, 4000)
                    TriggerClientEvent("vorp_bank:recinfo", _source, bankAccounts[toBank], toBank, allBankAccounts)
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
    TriggerClientEvent("vorp_bank:ready", _source)
end)

RegisterServerEvent('vorp_bank:depositcash')
AddEventHandler('vorp_bank:depositcash', function(amount, bankName, bankInfo)
    local _source = source
    local Character = VORPcore.getUser(_source).getUsedCharacter
    local playerFullName = Character.firstname .. ' ' .. Character.lastname
    local characterId = Character.charIdentifier
    local playerCash = Character.money

    if playerCash >= amount then
        MySQL.query("SELECT * FROM bank_users WHERE charidentifier = @characterId AND name = @bankName", { ["@characterId"] = characterId, ["@bankName"] = bankName }, function(result)
            if result[1] then
                Character.removeCurrency(0, amount)
                DiscordLogs(amount, bankName, playerFullName, "deposit")
                local currentBalance = result[1].money
                local newBalance = currentBalance + amount
                Wait(100)
                local updateParams = { ['charidentifier'] = characterId, ['money'] = newBalance, ['name'] = bankName }
                MySQL.update("UPDATE bank_users SET money=@money WHERE charidentifier=@characterId AND name = @name", updateParams)
                VORPcore.NotifyRightTip(_source, T.youdepo .. amount, 4000)
            end
        end)
    else
        VORPcore.NotifyRightTip(_source, T.invalid, 4000)
    end
    TriggerClientEvent("vorp_bank:ready", _source)
end)

RegisterServerEvent('vorp_bank:depositgold')
AddEventHandler('vorp_bank:depositgold', function(amount, bankName, bankinfo)
    local _source = source
    local Character = VORPcore.getUser(_source).getUsedCharacter
    local characterId = Character.charIdentifier
    local playerGold = Character.gold

    if playerGold >= amount then
        Character.removeCurrency(1, amount)
        local updateParams = { ['charidentifier'] = characterId, ['gold'] = amount, ['name'] = bankName }
        MySQL.update("UPDATE bank_users SET gold = gold + @gold WHERE charidentifier = @charidentifier AND name = @name", updateParams)
        VORPcore.NotifyRightTip(_source, T.youdepog .. amount, 4000)
    else
        VORPcore.NotifyRightTip(_source, T.invalid, 4000)
    end
    TriggerClientEvent("vorp_bank:ready", _source)
end)

RegisterServerEvent('vorp_bank:withcash')
AddEventHandler('vorp_bank:withcash', function(amount, bankName, bankinfo)
    local _source = source
    local Character = VORPcore.getUser(_source).getUsedCharacter
    local playerFullName = Character.firstname .. ' ' .. Character.lastname
    local characterId = Character.charIdentifier

    MySQL.query("SELECT * FROM bank_users WHERE charidentifier = @characterId AND name = @bankName", { ["@characterId"] = characterId, ["@bankName"] = bankName }, function(result)
        if result[1] then
            local bankBalance = result[1].money
            if bankBalance >= amount then
                if not lastMoney[_source] or lastMoney[_source] ~= bankBalance then
                    local newBalance = bankBalance - amount
                    MySQL.update("UPDATE bank_users SET money=@newBalance WHERE charidentifier=@characterId AND name = @bankName", { ['charidentifier'] = characterId, ['money'] = newBalance, ['name'] = bankName })
                    lastMoney[_source] = bankBalance
                    Character.addCurrency(0, amount)
                    DiscordLogs(amount, bankName, playerFullName, "withdraw")
                    VORPcore.NotifyRightTip(_source, T.withdrew .. amount, 4000)
                else
                    print("^1Potential cheating detected: player " .. playerFullName .. " attempted repeated transactions with unchanged balance.^7")
                end
            else
                VORPcore.NotifyRightTip(_source, T.invalid .. amount, 4000)
            end
        end
    end)
    TriggerClientEvent("vorp_bank:ready", _source)
end)

RegisterServerEvent('vorp_bank:withgold')
AddEventHandler('vorp_bank:withgold', function(amount, bankName, bankinfo)
    local _source = source
    local Character = VORPcore.getUser(_source).getUsedCharacter
    local characterId = Character.charIdentifier

    MySQL.query("SELECT gold FROM bank_users WHERE charidentifier = @characterId AND name = @bankName", { ["@characterId"] = characterId, ["@bankName"] = bankName }, function(result)
        if result[1] then
            local bankGold = result[1].gold
            if bankGold >= amount then
                MySQL.update("UPDATE bank_users SET gold = gold - @amount WHERE charidentifier = @characterId AND name = @bankName", { ['charidentifier'] = characterId, ['gold'] = amount, ['name'] = bankName })
                Character.addCurrency(1, amount)
                VORPcore.NotifyRightTip(_source, T.withdrewg .. amount, 4000)
            else
                VORPcore.NotifyRightTip(_source, T.invalid .. amount, 4000)
            end
        end
    end)
    TriggerClientEvent("vorp_bank:ready", _source)
end)

RegisterServerEvent("vorp_bank:find")
AddEventHandler("vorp_bank:find", function(name)
    local _source = source
    MySQL.query('SELECT * FROM bank_users', {}, function(result)
        local banklocations = {}
        if result[1] then
            for i = 1, #result, 1 do
                banklocations[#banklocations + 1] = {
                    id             = result[i].id,
                    name           = result[i].name,
                    identifier     = result[i].identifier,
                    charidentifier = result[i].charidentifier,
                    money          = result[i].money,
                    gold           = result[i].gold,
                    invspace       = result[i].invspace,
                }
            end
            TriggerClientEvent("vorp_bank:findbank", _source, banklocations)
        end
    end)
end)

local processinguser = {}

function inprocessing(id)
    for k, v in pairs(processinguser) do
        if v == id then
            return true
        end
    end
    return false
end

function trem(id)
    for k, v in pairs(processinguser) do
        if v == id then
            table.remove(processinguser, k)
        end
    end
end

function AnIndexOf(t, val)
    for k, v in ipairs(t) do
        if v == val then return k end
    end
end

function ToInteger(number)
    _source = source
    number = tonumber(number)
    if number then
        if 0 > number then
            number = number * -1
        elseif number == 0 then
            return nil
        end
        return math.floor(number or error("Could not cast '" .. tostring(number) .. "' to number.'"))
    else
        return nil
    end
end

function pairsByKeys(t, f) -- non toccare
    local a = {}
    for n in pairs(t) do table.insert(a, n) end
    table.sort(a, f)
    local i = 0             -- iterator variable
    local iter = function() -- iterator function
        i = i + 1
        if a[i] == nil then
            return nil
        else
            return a[i], t[a[i]]
        end
    end
    return iter
end

RegisterNetEvent("vorp_bank:ReloadBankInventory") -- inventory system
AddEventHandler("vorp_bank:ReloadBankInventory", function(bankid)
    local _source = source
    local name = bankid
    local Character = VORPcore.getUser(_source).getUsedCharacter
    local charidentifier = Character.charIdentifier

    MySQL.query("SELECT * FROM bank_users WHERE charidentifier = @charidentifier AND name = @name ", { ["@charidentifier"] = charidentifier, ["@name"] = name }, function(result)
            if result[1].items then
                local items = {}
                local inv = json.decode(result[1].items)
                if not inv then
                    items.itemList = {}
                    items.action = "setSecondInventoryItems"
                    TriggerClientEvent("vorp_inventory:ReloadBankInventory", _source, json.encode(items))
                else
                    items.itemList = inv
                    items.action = "setSecondInventoryItems"
                    TriggerClientEvent("vorp_inventory:ReloadBankInventory", _source, json.encode(items))
                end
            end
        end)
end)

RegisterServerEvent("vorp_bank:TakeFromBank") -- inventory system
AddEventHandler("vorp_bank:TakeFromBank", function(jsonData)
    local _source = source
    if not inprocessing(_source) then
        processinguser[#processinguser + 1] = _source
        local notpass = false
        local User = VORPcore.getUser(_source)
        local Character = User.getUsedCharacter
        local charidentifier = Character.charIdentifier
        local data = json.decode(jsonData)
        local name = data["bank"]
        local item = data.item
        local itemCount = ToInteger(data["number"])
        local itemType = data.type

        local itemMeta = data.item.metadata
        local dataMeta = true
        if itemMeta == nil then
            itemMeta = {}
        end

        if itemCount and itemCount ~= 0 then
            if item.count < itemCount then
                TriggerClientEvent("vorp:TipRight", _source, T.invalid, 5000)
                return trem(_source)
            end
        else
            TriggerClientEvent("vorp:TipRight", _source, T.invalid, 5000)
            return trem(_source)
        end
        if itemType == "item_weapon" then
            TriggerEvent("vorpCore:canCarryWeapons", tonumber(_source), itemCount, function(canCarry)
                if canCarry then
                    MySQL.query("SELECT * FROM bank_users WHERE charidentifier = @charidentifier AND name = @name", { ["@charidentifier"] = charidentifier, ["@name"] = name }, function(result)
                            notpass = true
                            if result[1].items then
                                local items = {}
                                local inv = json.decode(result[1].items)
                                local foundItem = nil
                                for k, v in pairs(inv) do
                                    if v.name == item.name then
                                        foundItem = v
                                        if #foundItem > 1 then
                                            if k == 1 then
                                                foundItem = v
                                            end
                                        end
                                    end
                                end
                                if foundItem then
                                    local foundIndex2 = AnIndexOf(inv, foundItem)
                                    foundItem.count = foundItem.count - itemCount
                                    if 0 >= foundItem.count then
                                        table.remove(inv, foundIndex2)
                                    end
                                    items.itemList = inv
                                    items.action = "setSecondInventoryItems"
                                    local weapId = foundItem.id
                                    exports.vorp_inventory:giveWeapon(_source, weapId)
                                    Wait(200)
                                    TriggerClientEvent("vorp_inventory:ReloadBankInventory", _source, json.encode(items))
                                    MySQL.update("UPDATE bank_users SET items = @inv WHERE charidentifier = @charidentifier AND name = @name", { ["@inv"] = json.encode(inv), ["@charidentifier"] = charidentifier, ["@name"] = name })
                                end
                            end
                            notpass = false
                        end)
                    while notpass do
                        Wait(500)
                    end
                else
                    TriggerClientEvent("vorp:TipRight", _source, T.limit, 5000)
                end
            end, item.name)
        else
            if itemCount and itemCount ~= 0 then
                if item.count < itemCount then
                    TriggerClientEvent("vorp:TipRight", _source, T.invalid, 5000)
                    return trem(_source)
                end
            else
                TriggerClientEvent("vorp:TipRight", _source, T.invalid, 5000)
                return trem(_source)
            end
            local count = exports.vorp_inventory:getItemCount(_source, item.name)

            if (count + itemCount) > item.limit then
                TriggerClientEvent("vorp:TipRight", _source, T.maxlimit, 5000)
                return trem(_source)
            end
            TriggerEvent("vorpCore:canCarryItems", tonumber(_source), itemCount, function(canCarry)
                TriggerEvent("vorpCore:canCarryItem", tonumber(_source), item.name, itemCount, function(canCarry2)
                    if canCarry and canCarry2 then
                        MySQL.query(
                            "SELECT * FROM bank_users WHERE charidentifier = @charidentifier AND name = @name",
                            { ["@charidentifier"] = charidentifier, ["@name"] = name }, function(result)
                                notpass = true
                                if result[1].items then
                                    local items = {}
                                    local inv = json.decode(result[1].items)
                                    local foundItem, foundIndex = nil, nil

                                    if next(itemMeta) ~= nil then
                                        for k, v in pairs(inv) do
                                            if v.name == item.name then -- se hanno stesso nome
                                                for x, y in pairsByKeys(v.metadata) do
                                                    for w, z in pairsByKeys(itemMeta) do
                                                        if x == w and y == z then
                                                            foundItem = v
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    else
                                        for k, v in pairs(inv) do
                                            if v.name == item.name then
                                                if v.metadata == nil or next(v.metadata) == nil then
                                                    foundItem = v
                                                end
                                            end
                                        end
                                    end

                                    if foundItem then
                                        local foundIndex2 = AnIndexOf(inv, foundItem)
                                        foundItem.count = foundItem.count - itemCount
                                        if 0 >= foundItem.count then
                                            table.remove(inv, foundIndex2)
                                        end

                                        items.itemList = inv
                                        items.action = "setSecondInventoryItems"

                                        if dataMeta then
                                            exports.vorp_inventory:addItem(_source, item.name, itemCount, itemMeta)
                                        else
                                            exports.vorp_inventory:addItem(_source, item.name, itemCount)
                                        end

                                        TriggerClientEvent("vorp_inventory:ReloadBankInventory", _source, json.encode(items))
                                        MySQL.update("UPDATE bank_users SET items = @inv WHERE charidentifier = @charidentifier AND name = @name", { ["@inv"] = json.encode(inv), ["@charidentifier"] = charidentifier, ["@name"] = name })
                                    end
                                end
                                notpass = false
                            end)
                        while notpass do
                            Wait(500)
                        end
                    else
                        TriggerClientEvent("vorp:TipRight", _source, T.limit, 5000)
                    end
                end)
            end)
        end
        trem(_source)
    end
end)

function checkLimit(limit, name)
    for k, v in pairs(limit) do
        if k == name then
            return true
        end
    end
end

function checkCount(countinv, countdb, limit, nameitem)
    for k, v in pairs(limit) do
        if k == nameitem then
            if countinv > v or countdb > v then
                return true
            end
        end
    end
end

function checkLimite(limit, nameitem)
    for index, countConfig in pairs(limit) do
        if index == nameitem then
            return countConfig
        end
    end
end

function checkDB(inv, itemName, itemType)
    for k, v in pairs(inv) do
        if v.name == itemName then
            if itemType == "item_standard" then
                return v.count -- da quanti item c erano prima del deposito
            else
                for index, data in pairs(inv) do
                    if v.name == itemName and itemType == "item_weapon" then
                        count = count + 1
                        return count
                    end
                end
            end
        end
    end
end

RegisterServerEvent("vorp_bank:MoveToBank") -- inventory system
AddEventHandler("vorp_bank:MoveToBank", function(jsonData)
    local _source = source
    if not inprocessing(_source) then
        processinguser[#processinguser + 1] = _source
        local notpass = false
        local User = VORPcore.getUser(_source)
        local Character = User.getUsedCharacter
        local charidentifier = Character.charIdentifier
        local data = json.decode(jsonData)
        local bankName = data["bank"]
        local item = data.item
        local itemCount = ToInteger(data["number"])
        local itemType = data["type"]
        local itemDBCount = 1
        local itemMeta = data.item.metadata
        local dataMeta = true
        if itemMeta == nil then
            itemMeta = {}
        end

        for index, bankConfig in pairs(Config.banks) do
            if bankConfig.city == bankName then
                local existItem = checkLimit(bankConfig.itemlist, item.name)
                if (existItem and bankConfig.useitemlimit) or (existItem and bankConfig.usespecificitem) then
                    MySQL.query("SELECT * FROM bank_users WHERE charidentifier = @charidentifier AND name = @name", { ["@charidentifier"] = charidentifier, ["@name"] = bankName }, function(result)
                            if result[1].items ~= "[]" then
                                local inv = json.decode(result[1].items)
                                for k, v in pairs(inv) do
                                    if v.name == item.name then
                                        if itemType == "item_standard" then
                                            itemDBCount = v.count + itemCount
                                        elseif itemType == "item_weapon" then
                                            itemDBCount = itemDBCount + itemCount
                                        end
                                    end
                                end
                            else
                                itemDBCount = itemCount
                            end
                            local checkCount = checkCount(itemCount, itemDBCount, bankConfig.itemlist, item.name)
                            if checkCount then
                                local limite = checkLimite(bankConfig.itemlist, item.name)
                                TriggerClientEvent("vorp:TipRight", _source, T.maxitems .. limite, 5000)
                                return trem(_source)
                            else
                                if itemType ~= "item_weapon" then
                                    local countin = exports.vorp_inventory:getItemCount(_source, item.name)
                                    if itemCount > countin then
                                        TriggerClientEvent("vorp:TipRight", _source, T.limit, 5000)
                                        return trem(_source)
                                    end
                                end
                                if itemType == "item_weapon" then
                                    itemCount = 1
                                    item.count = 1
                                end
                                if itemCount and itemCount ~= 0 then
                                    if item.count < itemCount then
                                        TriggerClientEvent("vorp:TipRight", _source, T.invalid, 5000)
                                        return trem(_source)
                                    end
                                else
                                    TriggerClientEvent("vorp:TipRight", _source, T.invalid, 5000)
                                    return trem(_source)
                                end
                                MySQL.query("SELECT * FROM bank_users WHERE charidentifier = @charidentifier AND name = @name", { ["@charidentifier"] = charidentifier, ["@name"] = bankName }, function(result)
                                        notpass = true

                                        if result[1].items then
                                            local space = result[1].invspace
                                            local items = {}
                                            local countDB = 0
                                            local inv = json.decode(result[1].items)
                                            local foundItem = nil

                                            if next(itemMeta) ~= nil then
                                                for k, v in pairs(inv) do
                                                    if v.name == item.name then
                                                        for x, y in pairsByKeys(v.metadata) do
                                                            for w, z in pairsByKeys(itemMeta) do
                                                                if x == w and y == z then
                                                                    if itemType == "item_standard" then
                                                                        foundItem = v
                                                                    end
                                                                end
                                                            end
                                                        end
                                                    end
                                                end
                                            else
                                                for k, v in pairs(inv) do
                                                    if v.name == item.name then
                                                        if v.metadata == nil or next(v.metadata) == nil then
                                                            if itemType == "item_standard" then
                                                                foundItem = v
                                                            end
                                                        end
                                                    end
                                                end
                                            end

                                            for _, k in pairs(inv) do
                                                countDB = countDB + k.count
                                            end
                                            countDB = countDB + itemCount
                                            if countDB > space then
                                                TriggerClientEvent("vorp:TipRight", _source, T.limit, 5000)
                                            else
                                                if foundItem then
                                                    foundItem.count = foundItem.count + itemCount
                                                else
                                                    if itemType == "item_standard" then
                                                        if next(itemMeta) == nil then
                                                            foundItem = {
                                                                name = item.name,
                                                                count = itemCount,
                                                                label = item.label,
                                                                type = item.type,
                                                                limit = item.limit,
                                                                metadata = {}
                                                            }
                                                            inv[#inv + 1] = foundItem
                                                        else
                                                            foundItem = {
                                                                name = item.name,
                                                                count = itemCount,
                                                                label = item.label,
                                                                type = item.type,
                                                                limit = item.limit,
                                                                id = item.id,
                                                                metadata = itemMeta
                                                            }
                                                            inv[#inv + 1] = foundItem
                                                        end
                                                    else
                                                        foundItem = {
                                                            name = item.name,
                                                            count = itemCount,
                                                            label = item.label,
                                                            type = item.type,
                                                            limit = item.limit,
                                                            id = item.id,
                                                            serial_number = item.serial_number,
                                                            custom_desc = item.custom_desc,
                                                            custom_label = item.custom_label
                                                        }
                                                        table.insert(inv, foundItem)
                                                    end
                                                end
                                                items.itemList = inv
                                                items.action = "setSecondInventoryItems"
                                                if itemType == "item_standard" then
                                                    if dataMeta then
                                                        exports.vorp_inventory:subItem(_source, item.name, itemCount, itemMeta)
                                                        TriggerClientEvent("vorp:TipRight", _source, T.depoitem3 .. itemCount .. T.of .. item.label, 5000)
                                                    else
                                                        exports.vorp_inventory:subItem(_source, item.name, itemCount)
                                                        TriggerClientEvent("vorp:TipRight", _source, T.depoitem3 .. itemCount .. T.of .. item.label, 5000)
                                                    end
                                                end
                                                if itemType == "item_weapon" then
                                                    local weapId = item.id
                                                    exports.vorp_inventory:subWeapon(_source, weapId)
                                                    TriggerClientEvent("vorp:TipRight", _source, T.depoitem3 .. item.label, 5000)
                                                end
                                                TriggerClientEvent("vorp_inventory:ReloadBankInventory", _source, json.encode(items))
                                                MySQL.update("UPDATE bank_users SET items = @inv WHERE charidentifier = @charidentifier AND name = @name", { ["@inv"] = json.encode(inv), ["@charidentifier"] = charidentifier, ["@name"] = bankName })
                                            end
                                        end
                                        notpass = false
                                    end)
                                while notpass do
                                    Wait(500)
                                end
                                trem(_source)
                            end
                        end)
                elseif (bankConfig.useitemlimit and not bankConfig.usespecificitem) or (not bankConfig.useitemlimit and not bankConfig.usespecificitem) then
                    if itemType ~= "item_weapon" then
                        local countin = exports.vorp_inventory:getItemCount(_source, item.name)
                        if itemCount > countin then
                            TriggerClientEvent("vorp:TipRight", _source, T.limit, 5000)
                            return trem(_source)
                        end
                    end

                    if itemType == "item_weapon" then
                        itemCount = 1
                        item.count = 1
                    end

                    if itemCount and itemCount ~= 0 then
                        if item.count < itemCount then
                            TriggerClientEvent("vorp:TipRight", _source, T.invalid, 5000)
                            return trem(_source)
                        end
                    else
                        TriggerClientEvent("vorp:TipRight", _source, T.invalid, 5000)
                        return trem(_source)
                    end

                    MySQL.query("SELECT * FROM bank_users WHERE charidentifier = @charidentifier AND name = @name", { ["@charidentifier"] = charidentifier, ["@name"] = bankName }, function(result)
                        notpass = true
                        if result[1].items then
                            local space = result[1].invspace
                            local items = {}
                            local countDB = 0
                            local inv = json.decode(result[1].items)
                            local foundItem = nil

                            if next(itemMeta) ~= nil then
                                for k, v in pairs(inv) do
                                    if v.name == item.name then
                                        for x, y in pairsByKeys(v.metadata) do
                                            for w, z in pairsByKeys(itemMeta) do
                                                if x == w and y == z then
                                                    if itemType == "item_standard" then
                                                        foundItem = v
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            else
                                for k, v in pairs(inv) do
                                    if v.name == item.name then
                                        if v.metadata == nil or next(v.metadata) == nil then
                                            if itemType == "item_standard" then
                                                foundItem = v
                                            end
                                        end
                                    end
                                end
                            end

                            for k, v in pairs(inv) do
                                countDB = countDB + v.count
                            end

                            countDB = countDB + itemCount
                            if countDB > space then
                                TriggerClientEvent("vorp:TipRight", _source, T.limit, 5000)
                            else
                                if foundItem then
                                    foundItem.count = foundItem.count + itemCount
                                else
                                    if itemType == "item_standard" then
                                        if next(itemMeta) == nil then
                                            foundItem = {
                                                name = item.name,
                                                count = itemCount,
                                                label = item.label,
                                                type = item.type,
                                                limit = item.limit,
                                                id = item.id,
                                                metadata = {}
                                            }
                                            inv[#inv + 1] = foundItem
                                        else
                                            foundItem = {
                                                name = item.name,
                                                count = itemCount,
                                                label = item.label,
                                                type = item.type,
                                                limit = item.limit,
                                                id = item.id,
                                                metadata = itemMeta
                                            }
                                            inv[#inv + 1] = foundItem
                                        end
                                    else
                                        foundItem = {
                                            name = item.name,
                                            count = itemCount,
                                            label = item.label,
                                            type = item.type,
                                            limit = item.limit,
                                            id = item.id,
                                            serial_number = item.serial_number,
                                            custom_desc = item.custom_desc,
                                            custom_label = item.custom_label
                                        }
                                        table.insert(inv, foundItem)
                                    end
                                end
                                items.itemList = inv
                                items.action = "setSecondInventoryItems"
                                if itemType == "item_standard" then
                                    if dataMeta then
                                        exports.vorp_inventory:subItem(_source, item.name, itemCount, itemMeta)
                                    else
                                        exports.vorp_inventory:subItem(_source, item.name, itemCount)
                                    end
                                    TriggerClientEvent("vorp:TipRight", _source, T.depoitem3 .. itemCount .. T.of .. item.label, 5000)
                                end
                                if itemType == "item_weapon" then
                                    local weapId = item.id
                                    exports.vorp_inventory:subWeapon(_source, weapId)
                                    TriggerClientEvent("vorp:TipRight", _source, T.depoitem3 .. item.label, 5000)
                                end
                                TriggerClientEvent("vorp_inventory:ReloadBankInventory", _source, json.encode(items))
                                MySQL.update("UPDATE bank_users SET items = @inv WHERE charidentifier = @charidentifier AND name = @name", { ["@inv"] = json.encode(inv), ["@charidentifier"] = charidentifier, ["@name"] = bankName })
                            end
                        end
                        notpass = false
                    end)
                    while notpass do
                        Wait(500)
                    end
                    trem(_source)
                else
                    TriggerClientEvent("vorp:TipRight", _source, T.cant, 5000)
                    trem(_source)
                end
            end
        end
    end
end)

AddEventHandler("onPlayerDropped", function()
    local _source = source
    for key, value in pairs(lastMoney) do
        if key == _source then
            lastMoney[key] = nil
            break
        end
    end
end)
