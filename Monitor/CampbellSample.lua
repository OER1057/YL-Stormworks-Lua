-- Author: OER1057
-- GitHub: https://github.com/OER1057
-- Workshop: https://steamcommunity.com/profiles/76561199119398472/myworkshopfiles/?appid=573090
--
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey

--[====[ EDITABLE SIMULATOR CONFIG - *automatically removed from the F7 build output ]====]
---@section __LB_SIMULATOR_ONLY__
do
    ---@type Simulator -- Set properties and screen sizes here - will run once when the script is loaded
    simulator = simulator
    simulator:setScreen(1, "1x1")
end
---@endsection

--[====[ IN-GAME CODE ]====]
require("Monitor.Campbell")

function dot(x, y)
    screen.drawRectF(x, y, 4, 4)
end

function onDraw()
    black()
    dot(0, 0)
    blue()
    dot(4, 0)
    cyan()
    dot(8, 0)
    green()
    dot(12, 0)
    purple()
    dot(16, 0)
    red()
    dot(20, 0)
    white()
    dot(24, 0)
    yellow()
    dot(28, 0)
    bblack()
    dot(0, 4)
    bblue()
    dot(4, 4)
    bcyan()
    dot(8, 4)
    bgreen()
    dot(12, 4)
    bpurple()
    dot(16, 4)
    bred()
    dot(20, 4)
    bwhite()
    dot(24, 4)
    byellow()
    dot(28, 4)
end
