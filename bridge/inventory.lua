Inventory = Inventory or {}
Inventory.Name = Inventory.Name or 'none'
Inventory.Ready = Inventory.Ready or false

local function resStarted(name)
    return GetResourceState(name) == 'started'
end

local function detectInventory()
    if resStarted('qb-inventory') then
        return 'qb-inventory'
    elseif resStarted('ox_inventory') then
        return 'ox_inventory'
    end
    return 'qb-inventory'
end

function Inventory.Init()
    Inventory.Name = detectInventory()
    Inventory.Ready = Inventory.Name ~= 'none'

    print(('[UiForge] inventory bridge set to %s'):format(Inventory.Name))
end

function Inventory.IsReady()
    return Inventory.Ready
end

function Inventory.GetName()
    return Inventory.Name
end

function Inventory.HasItem(src, item, amount)
    if not src or src <= 0 then
        return false
    end
    if type(item) ~= 'string' then
        return false
    end
    amount = math.floor(tonumber(amount) or 1)
    if amount < 1 then
        amount = 1
    end

    if Inventory.Name == 'ox_inventory' and resStarted('ox_inventory') then
        local count = exports.ox_inventory:Search(src, 'count', item)
        return (count or 0) >= amount
    end

    local Player = Bridge and Bridge.GetPlayer and Bridge.GetPlayer(src)
    if not Player or not Player.Functions or not Player.Functions.GetItemByName then
        return false
    end

    local itemData = Player.Functions.GetItemByName(item)
    if not itemData then
        return false
    end
    return (itemData.amount or 0) >= amount
end

function Inventory.CanCarry(src, item, amount, metadata)
    if not src or src <= 0 then
        return false
    end
    if type(item) ~= 'string' then
        return false
    end
    amount = math.floor(tonumber(amount) or 1)
    if amount < 1 then
        amount = 1
    end

    if Inventory.Name == 'ox_inventory' and resStarted('ox_inventory') then
        return exports.ox_inventory:CanCarryItem(src, item, amount, metadata)
    end

    local Player = Bridge and Bridge.GetPlayer and Bridge.GetPlayer(src)
    if Player and Player.Functions and Player.Functions.CanCarryItem then
        return Player.Functions.CanCarryItem(item, amount)
    end

    -- default true since qb dont got the export for it...
    return true
end

function Inventory.AddItem(src, item, amount, metadata, slot)
    if not src or src <= 0 then
        return false
    end
    if type(item) ~= 'string' then
        return false
    end
    amount = math.floor(tonumber(amount) or 1)
    if amount < 1 then
        return false
    end

    if Inventory.Name == 'ox_inventory' and resStarted('ox_inventory') then
        return exports.ox_inventory:AddItem(src, item, amount, metadata, slot)
    end

    local Player = Bridge and Bridge.GetPlayer and Bridge.GetPlayer(src)
    if not Player or not Player.Functions or not Player.Functions.AddItem then
        return false
    end

    return Player.Functions.AddItem(item, amount, slot, metadata)
end

function Inventory.RemoveItem(src, item, amount, slot)
    if not src or src <= 0 then
        return false
    end
    if type(item) ~= 'string' then
        return false
    end
    amount = math.floor(tonumber(amount) or 1)
    if amount < 1 then
        return false
    end

    if Inventory.Name == 'ox_inventory' and resStarted('ox_inventory') then
        return exports.ox_inventory:RemoveItem(src, item, amount, nil, slot)
    end

    local Player = Bridge and Bridge.GetPlayer and Bridge.GetPlayer(src)
    if not Player or not Player.Functions or not Player.Functions.RemoveItem then
        return false
    end

    return Player.Functions.RemoveItem(item, amount, slot)
end

-- TODO: add GetItem/SetMeta if needed later on

CreateThread(function()
    Inventory.Init()
end)
