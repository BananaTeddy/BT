local bridge = peripherals.find('rsBridge')
local monitor = peripherals.find('monitor')
local itemCount
local maxCount

while true do
    itemCount = 0
    maxCount = bridge.getMaxItemDiskStorage()

    for _, v in pairs(bridge.listItems()) do
        itemCount = itemCount + v.amount
    end

    monitor.clear()
    monitor.setCursorPos(0, 0)
    monitor.write(itemCount .. '/' .. maxCount)
    monitor.write(string.format('%i/%i (%.2f%%)', itemCount, maxCount, (itemCount / maxCount) * 100))
    sleep(30)    
end
