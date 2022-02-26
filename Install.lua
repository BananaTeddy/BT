-- [ Install BT_API]

local baseUrl = 'https://raw.githubusercontent.com/'
local gitHubUser = 'BananaTeddy'
local project = 'BT_API'
local branch = 'main'
local files = {
    BT_API = 'BT_API.lua',
    Turtle = 'Turtle.lua',
    branches = 'Branches.lua',
    whitelist = 'whitelist.txt',
    blacklist = 'blacklist.txt',
    fluids = 'fluids.txt',
    fuels = 'fuels.txt',
    cobble = 'Cobble.lua'
}

for alias, file in pairs(files) do
    local url = baseUrl .. gitHubUser .. '/' .. project .. '/' .. branch .. '/' .. file
    shell.run('wget ' .. url .. ' ' .. alias)
end