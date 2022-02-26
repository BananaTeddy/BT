-- [BT_API]

BTCore = {}

function BTCore.Initialize()
    BTCore.version = 6
end

function BTCore.GetVersion()
    return BTCore.version
end


function BTCore.ReadLinesIntoTable(filepath)
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

function BTCore.WriteTableIntoFile(filepath, data)
    local file = fs.open(filepath, 'w')

    for _, v in pairs(data) do
        file.write(v)
    end
    file.close()
end

function BTCore.LoadTurtleAPI()
    local turtleAPI = require('BT_TURTLE')
    BTCore.Turtle = BTTurtle
    BTCore.Turtle.FuelItems = BTCore.ReadLinesIntoTable('FUEL_ITEMS')
end

BTCore.Initialize()