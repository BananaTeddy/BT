-- [BT_API]

BT_CORE = {}

function BT_CORE.Initialize()
    BT_CORE.version = 6
end

function BT_CORE.GetVersion()
    return BT_CORE.version
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

function BT_CORE.LoadTurtleAPI()
    local turtleAPI = require('BT_TURTLE')
    BT_CORE.Turtle = BT_TURTLE
    BT_CORE.Turtle.FuelItems = BT_CORE.ReadLinesIntoTable('FUEL_ITEMS')
end

BT_CORE.Initialize()