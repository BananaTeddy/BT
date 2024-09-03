BananaCore = {
    Version = 1
}

require("Logger.Logger")
require("Data.File")
require("Number.Number")
require("GUI.GUI")
require("Network.Network")

function BananaCore.GetVersion()
    return BananaCore.Version
end

return BananaCore