BananaCore.Network = BananaCore.Network or {}

--- @class NetworkServer
--- @field eventHandlers function[] handler functions for events
--- @field openPorts number[] list of open ports
--- @field modem table computercraft modem
--- @field logger Logger
BananaCore.Network.Server = {
    eventHandlers = {},
    openPorts = {},
    modem = nil,
    logger = nil
}


--- @return NetworkServer
function BananaCore.Network.Server:new(o)
    o = o or BananaCore.Network.Server
    setmetatable(o, self)
    self.__index = self
    self.logger = BananaCore.Logger:new()

    local modems = { peripheral.find("modem") }
    local modemCandidate = nil

    -- prefer wireless modem if available
    if #modems > 1 then
        for _, modem in pairs(modems) do
            if modem.isWireless() then
                modemCandidate = modem
            end
        end
    end

    if modemCandidate == nil then
        modemCandidate = modems[1]
    end

    self.modem = modemCandidate
    self.logger:Info("Connected modem %s", modemCandidate)

    return o
end

--- @return NetworkServer
function BananaCore.Network.Server:OpenPort(port)
    if #self.openPorts < 128 then
        self.openPorts[#self.openPorts+1] = port
        self.logger:Info("Added port %i to list of ports.", port)
    else
        self.logger:Warning("Adding port %i failed. Cannot add more than 128 ports", port)
    end
    
    return self
end

function BananaCore.Network.Server:Reply(channel, data)
    local machineId = os.getComputerID()
    local packet = BananaCore.Network.Packet:new({
        machineId = machineId,
        payload = data
    })

    if not packet:Check() then
        --- we only print as we dont want to shut down the server
        self.logger:Info("Cannot reply. Packet is not valid. Packet: %s", packet)
    end

    self.logger:Info("Sending reply to %i: %s", machineId, packet)

    self.modem.transmit(
        channel,
        machineId,
        packet
    )
end


--- @param event string
--- @param func function
--- @return NetworkServer
function BananaCore.Network.Server:AddEventHandler(event, func)
    self.eventHandlers[event] = func
    return self
end

--- starts the server and begins to listen to opened channels
function BananaCore.Network.Server:Start()
    if self.modem == nil then
        self.logger:Error("No modem found. Server cannot be started.")
        return
    end
    for _, port in pairs(self.openPorts) do
        self.modem.open(port)
        self.logger:Info("Opened port %i", port)
    end

    while true do
        local _, _, freq, replyFreq, message = os.pullEvent("modem_message")
        local packet = BananaCore.Network.Packet:new(message)

        if packet:Check() then
           local machineId, datetime, payload = packet:Unpack()
           local event = payload["event"]
           local eventData = payload["data"]

           self.logger:Info("Request received from computer %i. %s", machineId, payload)

            local handle = self.eventHandlers[event]
            if (handle) then
                local reply = handle(eventData)
                if (reply) then
                    self:Reply(replyFreq, reply)
                end
            else
                self.logger:Warning("No Event Handler is set for %s", event)
            end
        else
            self.logger:Info("Received incorrect packet data: %s", packet)
        end
    end
end