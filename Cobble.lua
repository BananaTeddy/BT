local args = {...}

local btCoreLoaded = require('BT_API')

if BT_API.GetVersion() < 6  then
	print('BananaTeddy API is outdated.');
	print('Please update from https://raw.githubusercontent.com/BananaTeddy/BT_API/main/Install.lua');
end

if #args > 0 then
	if term.isColor() then
		term.setTextColor(colors.red);
	end
	print("Usage: cobble");
	term.setTextColor(colors.white);
	error();
end

local direction
local mined = 0

if FindEnderChest() == 'back' then
    direction = 0
else
    direction = 1
end

BT_API.LoadTurtleAPI()

while true do
    if BT_API.Turtle.GetCapacity() > 0 then
        Mine()
        mined = mined + 1
    else
        -- inventory is full
        DepositInventory()
    end

    WriteInfo(mined)
end

function FindEnderChest()
    if peripheral.isPresent('back') then
        if peripheral.hasType('enderstorage:ender_chest') then
            return 'back'
        end
    end

    return 'right'
end

function Mine()
    turtle.dig()

    if direction == 0 then
        turtle.turnRight()
    else
        turtle.turnLeft()
    end
    direction = (direction + 1) % 2
    sleep(0.5)
end

function DepositInventory()
    if direction == 0 then
        turtle.turnRight()
        turtle.turnRight()
    else
        turtle.turnRight()
    end

    for slot = 1, 16 do
        turtle.select(slot)
        turtle.drop()
    end
    turtle.select(1)
    turtle.turnRight()
    turtle.turnRight()
    direction = 0
end

function WriteInfo(minedBlocks)
    term.clear()
    term.setCursorPos(1, 1)
    term.write('Mined ' .. minedBlocks .. ' blocks so far.')

end