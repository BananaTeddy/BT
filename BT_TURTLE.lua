-- [BT_TURTLE]

BT_TURTLE = {}

function BT_TURTLE.Initialize()
    BT_TURTLE.version = 1
end

function BT_TURTLE.GetVersion()
    return BT_TURTLE.version
end

function BT_TURTLE.Refuel(limit)
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

function BT_TURTLE.RefuelMax(limit)
    BT_TURTLE.Refuel(turtle.getFuelLimit())
end

function BT_TURTLE.UpdateFuelList(item)
    local previousSlot = turtle.getSelectedSlot()

    for slot = 1, 16 do
        turtle.select(slot)
        local isFuel = turtle.refuel(0)
        if isFuel then
            local item = turtle.getItemDetail()
            for _, v in pairs(BT_TURTLE.fuelItems) do
                if v == item.name then
                    return
                end
            end
            -- fuel item was not found in list
            BT_TURTLE.fuelItems[#BT_TURTLE.fuelItems+1] = item.name
        end
    end
    BT_TURTLE.WriteTableIntoFile('FUEL_ITEMS', BT_TURTLE.fuelItems)
end


function BT_TURTLE.HasInventoryFreeSlot()

    local slotsOccupied = 0

    for slot = 1, 16 do
        if turtle.getItemCount(slot) > 0 then
            slotsOccupied = slotsOccupied + 1
        end
    end

    return slotsOccupied < 16

end

function BT_TURTLE.GetPartiallyStackedItems()
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

BT_TURTLE.Initialize()