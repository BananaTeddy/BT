require('BananaCore')

-- Client
local c = BananaCore.Network.Client:new()
c:SetModem(peripheral.find('modem')):SetTargetChannel(1):Send({
    StoredItems = 69,
    StorageCapacity = 100
})


-- Server
function main()
    local modem = peripheral.find('modem')
    modem.open(1) -- targetChannel

    while true do
        local _, _, freq, replyFreq, message, _ = os.pullEvent('modem_message')

        local packet = BananaCore.Network.Packet:new(message)

        if packet:Check() then
            local machineId, program, datetime, data = packet:Unpack()

            print(string.format(
                '[%02d.%02d.%i %02d:%02d:%02d] Data received from machine %i',
                datetime.day,
                datetime.month,
                datetime.year,
                datetime.hour,
                datetime.min,
                datetime.sec,
                machineId
            ))
            HandleMessage(machineId, program, data)
        else
            print('Received incorrect packet')
        end
    end
end

function HandleMessage(machineId, program, data)
    if (program == "FissionReactorWatch") then
        if (data.scram == true) then
            print("FRW: Reactor " .. data.reactorLabel .. " just scrammed!!!")
        end
    end
end

main()