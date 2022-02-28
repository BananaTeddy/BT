local reactor = peripheral.find('fissionReactorLogicAdapter')

local temp

function main()
    while true do

        if (reactor.getStatus() == false and reactor.getTemperature() < 350) then
            SlowStartReactor()
        end
        WatchTemperature()

        sleep(0.5)
    end
end

function SlowStartReactor()
    local burnrate = 0

    reactor.setBurnRate(0)
    reactor.activate()
    while reactor.getBurnRate() < 20 do
        WatchTemperature()
        burnrate = burnrate + 1
        reactor.setBurnRate(burnrate)
        sleep(2)
    end
end

function WatchTemperature()
    temp = reactor.getTemperature()
    if temp > 600 then
        if reactor.getStatus() then
            reactor.scram()
        end
    end
end

main()