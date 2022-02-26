-- [BT_API]

BT_API = {}

function BT_API.Initialize()
    BT_API.version = 6
end

function BT_API.GetVersion()
    return BT_API.version
end


function BT_API.ReadLinesIntoTable(filepath)
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

function BT_API.WriteTableIntoFile(filepath, data)
    local file = fs.open(filepath, 'w')

    for _, v in pairs(data) do
        file.write(v)
    end
    file.close()
end

function BT_API.LoadTurtleAPI()
    local turtleAPI = require('BT_TURTLE')
    BT_API.Turtle = Turtle
    BT_API.Turtle.FuelItems = BT_API.ReadLinesIntoTable('FUEL_ITEMS')
end

BT_API.Initialize()