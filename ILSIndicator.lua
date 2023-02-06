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
    simulator:setScreen(1, "2x2")

    -- Runs every tick just before onTick; allows you to simulate the inputs changing
    ---@param simulator Simulator Use simulator:<function>() to set inputs etc.
    ---@param ticks     number Number of ticks since simulator started
    function onLBSimulatorTick(simulator, ticks)
        simulator:setInputNumber(1, simulator:getSlider(1) * 400 - 200)
        simulator:setInputNumber(2, simulator:getSlider(2) * 400 - 200)
    end
end
---@endsection

--[====[ IN-GAME CODE ]====]

require("Math")
require("Campbell")

centerX = 32
centerY = 32
markerSize = 32 / 2

function onTick()
    localizer = input.getNumber(1)
    glideSlope = input.getNumber(2)
    diffXNormal = math.sin(clamp(localizer / 200, -1, 1) * math.pi / 2)
    diffYNormal = math.sin(clamp(-glideSlope / 200, -1, 1) * math.pi / 2)
end

function onDraw()
    bred()
    screen.drawLine(centerX + markerSize * diffXNormal, centerY - markerSize, centerX + markerSize * diffXNormal,
        centerY + markerSize)
    screen.drawLine(centerX - markerSize, centerY + markerSize * diffYNormal, centerX + markerSize,
        centerY + markerSize * diffYNormal)
end
