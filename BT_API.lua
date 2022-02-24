-- [BT_API]



function GetVersion()
    return coreData.version
end

function Refuel(limit)
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

function RefuelMax(limit)
    Refuel(turtle.getFuelLimit())
end

function UpdateFuelList(item)
    -- TODO: write to file
end


function HasInventoryFreeSlot()

    local slotsOccupied = 0

    for slot = 1, 16 do
        if turtle.getItemCount(slot) > 0 then
            slotsOccupied = slotsOccupied + 1
        end
    end

    return slotsOccupied < 16

end

function GetPartiallyStackedItems()
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


function ReadLinesIntoTable(filepath)
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


local coreData = {
    version = 6,
    fuelItems = ReadLinesIntoTable('FUEL_ITEMS.lua')
}