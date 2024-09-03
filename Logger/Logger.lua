--- @class Logger
--- @field logName string name of the log file
--- @field logHandle table the handle of the log
--- @field logLevel integer the log level
BananaCore.Logger = {
    logName = nil,
    logHandle = nil,
    logLevel = 1,
    doPrint = false
}

--- @return Logger
function BananaCore.Logger:new(o)
    o = o or BananaCore.Logger
    setmetatable(o, self)
    self.__index = self

    local now = os.date("*t")

    if not fs.exists("logs") then
        fs.makeDir("logs")
    end

    self.logName = ("logs/%s_%04d%02d%02d.log"):format(shell.getRunningProgram():gsub(".lua", ""), now.year, now.month, now.day)
    self.logHandle = fs.open(self.logName, "a")
    
    return o
end

local function logLevelToInt(level)
    local logLevels = {
        ["INFO"] = 0,
        ["WARN"] = 1,
        ["ERROR"] = 2
    }

    return logLevels[level]
end

function BananaCore.Logger:SetLogLevel(level)
    self.logLevel = logLevelToInt(level)
end

--- @param shouldPrint boolean whether the logger should print to the current terminal
function BananaCore.Logger:DoPrint(shouldPrint)
    self.doPrint = shouldPrint or true
end

local function dump(o)
    if type(o) == 'table' then
       local s = '{ '
       for k,v in pairs(o) do
          if type(k) ~= 'number' then k = '"'..k..'"' end
          s = s .. '['..k..'] = ' .. dump(v) .. ','
       end
       return s .. '} '
    else
       return tostring(o)
    end
 end



--- @param message string the mesage to log
--- @param level string the log level
function BananaCore.Logger:Log(level, message, ...)
    local args = { ... }
    local level = level or "INFO"

    if (logLevelToInt(level) < self.logLevel) then
        return
    end

    local now = os.date('*t')

    local datePart = ("%02d:%02d:%02d"):format(now.hour, now.min, now.sec)

    for k, v in pairs(args) do
        args[k] = dump(v)
    end

    local msg = (message):format(table.unpack(args)) or message

    local formatted = ("%s %s %s"):format(datePart, level, msg)

    self.logHandle.writeLine(formatted)
    self.logHandle.flush()

    if self.doPrint == true then
        print(formatted)
    end
end


--- logs a message with info level
--- @param message string the message to log
function BananaCore.Logger:Info(message, ...)
    local args = { ... }
    self:Log("INFO", message, table.unpack(args))
end

--- logs a message with warning level
--- @param message string the message to log
function BananaCore.Logger:Warning(message, ...)
    local args = { ... }
    self:Log("WARN", message, table.unpack(args))
end

--- logs a message with error level
--- @param message string the message to log
function BananaCore.Logger:Error(message, ...)
    local args = { ... }
    self:Log("ERROR", message, table.unpack(args))
end
