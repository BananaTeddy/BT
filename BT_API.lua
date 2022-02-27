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

function BT_API.ShortNumberString(int)
    local counter = 0
    while int > 1000 do
        int = int / 1000
        counter = counter + 1
        print(counter)
    end

    local t = {
        [0] = '%i',
        [1] = '%.2fK',
        [2] = '%.2fM',
        [3] = '%.2fG'
    }

    return string.format(t[counter], int)
end

function BT_API.LoadTurtleAPI()
    local turtleAPI = require('Turtle')
    BT_API.Turtle = Turtle
    BT_API.Turtle.fuelItems = BT_API.ReadLinesIntoTable('fuels')
end

BT_API.Initialize()