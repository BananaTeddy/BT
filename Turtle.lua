-- [BT_TURTLE]

BTTurtle = {}

function BTTurtle.Initialize()
    BTTurtle.version = 1
end

function BTTurtle.GetVersion()
    return BTTurtle.version
end

function BTTurtle.Refuel(limit)
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

function BTTurtle.RefuelMax(limit)
    BTTurtle.Refuel(turtle.getFuelLimit())
end

function BTTurtle.UpdateFuelList(item)
    local previousSlot = turtle.getSelectedSlot()

    for slot = 1, 16 do
        turtle.select(slot)
        local isFuel = turtle.refuel(0)
        if isFuel then
            local item = turtle.getItemDetail()
            for _, v in pairs(BTTurtle.fuelItems) do
                if v == item.name then
                    return
                end
            end
            -- fuel item was not found in list
            BTTurtle.fuelItems[#BTTurtle.fuelItems+1] = item.name
        end
    end
    BTTurtle.WriteTableIntoFile('FUEL_ITEMS', BTTurtle.fuelItems)
end


function BTTurtle.HasInventoryFreeSlot()

    local slotsOccupied = 0

    for slot = 1, 16 do
        if turtle.getItemCount(slot) > 0 then
            slotsOccupied = slotsOccupied + 1
        end
    end

    return slotsOccupied < 16

end

function BTTurtle.GetPartiallyStackedItems()
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

BTTurtle.Initialize()