-- [BT_API]

BT_CORE = {}

function BT_CORE.Initialize()
    BT_CORE.version = 6
    BT_CORE.fuelItems = BT_CORE.ReadLinesIntoTable_Test('FUEL_ITEMS')
end

function BT_CORE.GetVersion()
    return BT_CORE.version
end

function BT_CORE.Refuel(limit)
    if limit == nil then
        print("Fuel threshold cannot be nil")
        return
    end

    local previousSlot = turtle.getSelectedSlot()

    for slot = 1, 16 do
        turtle.select(slot)
        local item = turtle.getItemDetail()
        UpdateFuelList(item)
        if item then
            for _, v in pairs(fuelItems) do
                if v == item.name then
                    while turtle.getFuelLevel() < limit do
                        if turtle.refuel(1) then
                            item.count = item.count - 1
                            if item.count == 0 then
                                break
                            end
                        end
                    end
                end
            end
        end
    end
    
    turtle.select(previousSlot)
end

function BT_CORE.RefuelMax(limit)
    BT_CORE.Refuel(turtle.getFuelLimit())
end

function BT_CORE.UpdateFuelList(item)
    local previousSlot = turtle.getSelectedSlot()

    for slot = 1, 16 do
        turtle.select(slot)
        local isFuel = turtle.refuel(0)
        if isFuel then
            local item = turtle.getItemDetail()
            for _, v in pairs(BT_CORE.fuelItems) do
                if v == item.name then
                    return
                end
            end
            -- fuel item was not found in list
            BT_CORE.fuelItems[#BT_CORE.fuelItems+1] = item.name
        end
    end
    BT_CORE.WriteTableIntoFile('FUEL_ITEMS', BT_CORE.fuelItems)
end


function BT_CORE.HasInventoryFreeSlot()

    local slotsOccupied = 0

    for slot = 1, 16 do
        if turtle.getItemCount(slot) > 0 then
            slotsOccupied = slotsOccupied + 1
        end
    end

    return slotsOccupied < 16

end

function BT_CORE.GetPartiallyStackedItems()
    local items = {}

    for slot = 1, 16 do
        if (turtle.getItemSpace(slot) > 0) then
            local item = turtle.getItemDetail(slot)
            items[#items+1] = {
                name = item.name,
                count = item.count,
                slot = slot
            }
        end
    end
end


function BT_CORE.ReadLinesIntoTable(filepath)
    local lines = {}

    if fs.exists(filepath) then
        local file = fs.open(filepath, 'r')

        while true do
            local line = file.readLine()

            if not line then break end

            lines[#lines+1] = line
        end

        file.close()
    end

    return lines
end

function BT_CORE.WriteTableIntoFile(filepath, data)
    local file = fs.open(filepath, 'w')

    for _, v in pairs(data) do
        file.write(v)
    end
    file.close()
end

BT_CORE.Initialize()