BananaCore.Network = BananaCore.Network or {}

--- Contains metadata and payload
--- @class NetworkPacket
BananaCore.Network.Packet = {
    machineId = nil,
    datetime = {},
    payload = {}
}

---Creates a new instance of Packet
---@return NetworkPacket
function BananaCore.Network.Packet:new(o)
    o = o or BananaCore.Network.Packet
    o.datetime = os.date('*t')
    setmetatable(o, self)
    self.__index = self

    return o
end

function BananaCore.Network.Packet:Check()
    local next = next
    --check machineId
    if self.machineId == nil then
        print('machineId is not set')
        return false
    end

    if type(self.machineId) ~= 'number' then
        print('machineId is type ' .. type(self.machineId) .. ' and not "number"')
        return false
    end

    -- check datetime
    if self.datetime == nil then
        print('datetime is not set')
        return false
    end
    if next(self.datetime) == nil then
        print('datetime is not set')
        return false
    end
    if type(self.datetime) ~= 'table' then
        print('datetime is type ' .. type(self.datetime) .. ' and not "table"')
        return false
    end

    -- check payload
    if self.payload == nil then
        print('payload is not set')
        return false
    end
    if type(self.payload) ~= 'table' then
        print('payload is type ' .. type(self.payload) .. ' and not "table"')
        return false
    end

    -- everything passed
    return true
end

---Unpacks the Packet
---@return number machineID
---@return table datetime
---@return table payload
function BananaCore.Network.Packet:Unpack()
    return self.machineId, self.datetime, self.payload
end