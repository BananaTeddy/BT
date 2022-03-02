btCoreLoaded = require('BT_API')
if BT_API == nil then
    error('Could not load BT_API')
end

local reactor
local temperature

function main()
    Log('App Started')
    Log('Trying to connecto to reactor')
    repeat
        reactor = peripheral.find('fissionReactorLogicAdapter')
        sleep(1)
    until reactor ~= nil
    Log('Connected to reactor')
    
    while true do

        if (reactor.getStatus() == false and reactor.getTemperature() < 370) then
            SlowStartReactor()
        end
        WatchTemperature()

        sleep(0.5)
    end
end

function ConnectToReactor()

end

function SlowStartReactor()
    Log('Slow starting reactor')
    local burnrate = 0

    reactor.setBurnRate(0)
    reactor.activate()
    while reactor.getBurnRate() < 20 do
        WatchTemperature()
        burnrate = burnrate + 1
        reactor.setBurnRate(burnrate)
        Log('Reactor burn rate reached ' .. burnrate .. ' mB/t')
        sleep(2)
    end
    Log('Slow starting reactor finished')
end

function WatchTemperature()
    temperature = reactor.getTemperature()
    if temperature > 600 then
        Log('Temperature too high: ' .. temperature)
        if reactor.getStatus() then
            Log('Shutdown reactor')
            reactor.scram()
        end
    end
end

function Log(message)
    print('[FRW] ' .. os.date() .. ' ' .. message)
end

main()