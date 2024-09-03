BananaCore.Network = BananaCore.Network or {}

--- @class NetworkClient
BananaCore.Network.Client = {
    modem = nil,
    targetChannel = nil
}

--- @return NetworkClient
function BananaCore.Network.Client:new(o)
    o = o or BananaCore.Network.Client
    setmetatable(o, self)
    self.__index = self
    return o
end

--- @return NetworkClient
function BananaCore.Network.Client:SetModem(modem)
    self.modem = modem
    return self
end

--- @return NetworkClient
function BananaCore.Network.Client:SetTargetChannel(channelId)
    self.targetChannel = channelId
    return self
end

--- @param data { event: string, eventData: table }
--- @return nil
function BananaCore.Network.Client:Send(data)
    local packet = BananaCore.Network.Packet:new({
        machineId = os.getComputerID(),
        payload = data
    })

    if not packet:Check() then
        error('Packet is not valid', 1)
    end

    self.modem.transmit(
        self.targetChannel,
        packet.machineId,
        packet
    )
end


--- Sends a request and waits for a response that can be processed
---@param data table the data to be send
---@param responseHandler function the function to be executed when a response arrives
---@param waitTime? number the number of seconds to wait for a response. defaults to 3
---@param timeOutHandler? function the function to be executed when the respond timeouts
function BananaCore.Network.Client:SendAwaitResponse(data, responseHandler, waitTime, timeOutHandler)
    local machineId = os.getComputerID()
    local packet = BananaCore.Network.Packet:new({
        machineId = machineId,
        payload = data
    })

    if not packet:Check() then
        error('Packet is not valid', 1)
    end

    self.modem.open(machineId)

    self.modem.transmit(
        self.targetChannel,
        machineId,
        packet
    )

    -- print(("waiting for reply on channel %i"):format(machineId))

    local responseMessage = {}
    local timeOutTimer = os.startTimer(waitTime or 3)
    local timeOut = false

    repeat
        local eventData = { os.pullEvent() }
        local eventType = eventData[1]
        local breaker = false

        if (eventType == "modem_message") then
            local _, _, channel, _, message, dist = table.unpack(eventData)
            if (channel == machineId) then
                responseMessage = message
                breaker = true
            end
        end

        if (eventType == "timer") then
            local _, id = table.unpack(eventData)
            if (id == timeOutTimer) then
                timeOut = true
                breaker = true
            end
        end

    until breaker == true
    
    self.modem.close(machineId)

    if (timeOut == true) then
        local printUtil = BananaCore.GUI.PrintUtil:new()
        printUtil:Error("Response took too long.")

        if (timeOutHandler) then
            timeOutHandler()
        end

        return
    end
    
    local replyPacket = BananaCore.Network.Packet:new(responseMessage)
    
    if not replyPacket:Check() then
        error("response packet incorrect")
    end
    
    local _, _, payload = replyPacket:Unpack()
    responseHandler(payload)
end