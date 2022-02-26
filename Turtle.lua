Turtle = {}

function Turtle.Initialize()
    Turtle.version = 1
    Turtle.fuelItems = {}
end

function Turtle.GetVersion()
    return Turtle.version
end

function Turtle.Refuel(limit)
    if limit == nil then
        print("Fuel threshold cannot be nil")
        return
    end

    local previousSlot = turtle.getSelectedSlot()

    for slot = 1, 16 do
        turtle.select(slot)
        local item = turtle.getItemDetail()
        Turtle.UpdateFuelList(item)
        if item then
            for _, v in pairs(Turtle.fuelItems) do
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

function Turtle.RefuelMax(limit)
    Turtle.Refuel(turtle.getFuelLimit())
end

function Turtle.UpdateFuelList(item)
    local isFuel = turtle.refuel(0)
    
    if isFuel then
        for _, v in pairs(Turtle.fuelItems) do
            if v == item.name then
                return
            end
        end

        Turtle.fuelItems[#Turtle.fuelItems+1] = item.name
    end

    BT_API.WriteTableIntoFile('fuels', Turtle.fuelItems)
end


function Turtle.HasInventoryFreeSlot()

    local slotsOccupied = 0

    for slot = 1, 16 do
        if turtle.getItemCount(slot) > 0 then
            slotsOccupied = slotsOccupied + 1
        end
    end

    return slotsOccupied < 16

end

function Turtle.GetCapacity()
    local capacity = 0
    
    for slot = 1, 16 do
        capacity = capacity + turtle.getItemSpace()
    end

    return capacity
end

function Turtle.GetPartiallyStackedItems()
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

Turtle.Initialize()