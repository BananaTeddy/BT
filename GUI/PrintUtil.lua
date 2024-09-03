BananaCore.GUI = BananaCore.GUI or {}

--- @class PrintUtil
BananaCore.GUI.PrintUtil = {}

colorStore = {
    fg = colors.white,
    bg = colors.black
}

--- stores current colors from current terminal
local function _storeColors()
    local term = term.current()
    local fgColor = term.getTextColor()
    local bgColor = term.getBackgroundColor()
    
    colorStore.fg = fgColor
    colorStore.bg = bgColor
end

--- restores stored colors to current terminal
local function _restoreColors()
    local term = term.current()
    
    term.setTextColor(colorStore.fg)
    term.setBackgroundColor(colorStore.bg)
end

--- @return PrintUtil
function BananaCore.GUI.PrintUtil:new(o)
    o = o or BananaCore.GUI.PrintUtil
    setmetatable(o, self)
    self.__index = self
    return o
end


--- prints message with error style
function BananaCore.GUI.PrintUtil:Error(message)
    local length = string.len(message)
    local bgColor = ""
    local fgColor = ""

    for i = 1, length, 1 do
        bgColor = bgColor .. colors.toBlit(colors.red)
        fgColor = fgColor .. colors.toBlit(colors.white)
    end
    term.blit(message, fgColor, bgColor)
end

--- prints message with success style
function BananaCore.GUI.PrintUtil:Success(message)
    local length = string.len(message)
    local bgColor = ""
    local fgColor = ""

    for i = 1, length, 1 do
        bgColor = bgColor .. colors.toBlit(colors.green)
        fgColor = fgColor .. colors.toBlit(colors.white)
    end
    term.blit(message, fgColor, bgColor)
end

