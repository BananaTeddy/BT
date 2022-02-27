-- program to show Refined Storage capacity
-- needs 3x1 Monitor blocks

local btCoreLoaded = require('BT_API')

if BT_API.GetVersion() < 6  then
	print('BananaTeddy API is outdated.');
	print('Please update from https://raw.githubusercontent.com/BananaTeddy/BT_API/main/Install.lua');
end

local bridge = peripheral.find('rsBridge')
local monitor = peripheral.find('monitor')

local itemCount
local maxItemCount
local fluidCount
local maxFluidCount

monitor.setTextColor(colors.green)

while true do
    itemCount = 0
    maxItemCount = bridge.getMaxItemDiskStorage()

    for _, v in pairs(bridge.listItems()) do
        itemCount = itemCount + v.amount
    end

    fluidCount = 0
    maxFluidCount = bridge.getMaxFluidDiskStorage()

    for _, v in pairs(bridge.listFluids()) do
        fluidCount = fluidCount + v.amount
    end


    monitor.clear()

    monitor.setCursorPos(1, 1)
    monitor.write('Items:')
    monitor.setCursorPos(1, 2)
    monitor.write(
        string.format(
            '%s/%s (%.2f%%)',
            BT_API.ShortNumberString(itemCount),
            BT_API.ShortNumberString(maxItemCount),
            (itemCount / maxItemCount) * 100
        )
    )

    monitor.setCursorPos(1, 3)
    monitor.write('Fluids:')
    monitor.setCursorPos(1, 4)
    monitor.write(
        string.format(
            '%i/%i (%.2f%%)',
            BT_API.ShortNumberString(fluidCount),
            BT_API.ShortNumberString(maxFluidCount),
            (fluidCount / maxFluidCount) * 100
        )
    )

    sleep(30)
end
