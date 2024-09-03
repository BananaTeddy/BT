BananaCore.GUI = BananaCore.GUI or {}

--- @class ProgressBar
BananaCore.GUI.ProgressBar = {
    id = nil,
    GUI_TYPE = "ProgressBar",
    current = 0,
    maximum = 100,
    color = colors.white
}

--- @return ProgressBar
function BananaCore.GUI.ProgressBar:new(o)
    o = o or BananaCore.GUI.ProgressBar
    setmetatable(o, self)
    self.__index = self
    
    self.id = math.random(1e16)

    table.insert(BananaCore.GUI.StoredElements, self)
    return o
end

--- @return ProgressBar
function BananaCore.GUI.ProgressBar:SetColor(color)
    self.color = color

    return self
end

--- @return ProgressBar
function BananaCore.GUI.ProgressBar:SetCurrent(current)
    self.current = current
    
    return self
end

--- @return ProgressBar
function BananaCore.GUI.ProgressBar:SetMaximum(maximum)
    self.maximum = maximum

    return self
end

--- @param yStart number the y coordinate where the bar should start
---@param barHeight number the height of the bar
function BananaCore.GUI.ProgressBar:Draw(yStart, barHeight)
    local term = term.current()

    local currentBg = term.getBackgroundColor()

    if (term.isColor() ~= true) then
        color = colors.white
    end

    local w, h = term.getSize()
    
    paintutils.drawBox(2, yStart, w - 4, yStart + barHeight, colors.white)

    local percent = self.current / self.maximum
    local barWidth = w - 6
    local length = math.floor(percent * barWidth)

    paintutils.drawFilledBox(
        3,
        yStart + 1,
        1 + length,
        yStart + barHeight - 1,
        self.color
    )

    term.setBackgroundColor(currentBg)
end