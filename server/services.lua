processinguser = {}

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

function pairsByKeys(t, f)
  local a = {}
  for n in pairs(t) do table.insert(a, n) end
  table.sort(a, f)
  local i = 0
  local iter = function()
    i = i + 1
    if a[i] == nil then
      return nil
    else
      return a[i], t[a[i]]
    end
  end
  return iter
end

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
        return v.count
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
