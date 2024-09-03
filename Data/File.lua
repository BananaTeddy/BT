BananaCore.Data = BananaCore.Data or {}
BananaCore.Data.File = {}

function BananaCore.Data.File.ReadLinesFromFile(fileName)
    local lines = {}

    if fs.exists(fileName) then
        local file = fs.open(fileName)

        while true do
            local line = file.readLine()

            if not line then
                break
            end

            lines[#lines+1] = line
        end

        file.close()
    end

    return lines
end

--- Takes each element of a table and writes it to a file. Does not support nested tables
function BananaCore.Data.File.WriteLinesToFile(fileName, data)
    local file = fs.open(fileName, 'w')

    for _, v in pairs(data) do
        file.write(v .. "\n")
    end
    file.close()
end


function BananaCore.Data.File.WriteToFile(fileName, data)
    local file = fs.open(fileName, 'w')

    file.write( textutils.serialize(data) )
    file.close()
end

function BananaCore.Data.File.ReadFromFile(fileName)
    local file = fs.open(fileName, 'r')
    local contents = file.readAll()
    file.close()

    return textutils.unserialize(contents)
end