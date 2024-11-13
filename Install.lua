-- [ Install BananaCore]

local baseUrl = "https://raw.githubusercontent.com/"
local gitHubUser = "BananaTeddy"
local project = "BananaCore"
local branch = "main"
local files = {
    ["BananaCore"] = "BananaCore.lua",

    ["Data/Data"] = "Data/Data.lua",
    ["Data/File"] = "Data/File.lua",

    ["Number/Number"] = "Number/Number.lua",

    ["Network/Network"] = "Network/Network.lua",
    ["Network/Packet"] = "Network/Packet.lua",
    ["Network/Server"] = "Network/Server.lua",
    ["Network/Client"] = "Network/Client.lua",

    ["Logger/Logger"] = "Logger/Logger.lua",

    ["GUI/GUI"] = "GUI/GUI.lua",
    ["GUI/PrintUtil"] = "GUI/PrintUtil.lua",
    ["GUI/ProgressBar"] = "GUI/ProgressBar.lua",

    ["branches"] = "Programs/Branches.lua"
}

for alias, file in pairs(files) do
    local url = baseUrl .. gitHubUser .. '/' .. project .. '/' .. branch .. '/' .. file
    if fs.exists(alias) then
        shell.run('rm ' .. alias)
    end
    shell.run('wget ' .. url .. ' ' .. alias)
end