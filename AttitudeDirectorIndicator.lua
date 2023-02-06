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
        simulator:setInputNumber(1, simulator:getSlider(1) * 1000)
        simulator:setInputNumber(2, simulator:getSlider(2) * 5)
        simulator:setInputNumber(3, simulator:getSlider(3) * 1000)
        simulator:setInputNumber(4, simulator:getSlider(4) * 1000)
        simulator:setInputNumber(5, simulator:getSlider(5) - 0.5)
        simulator:setInputNumber(6, simulator:getSlider(6) / 2 - 0.25)
    end
end
---@endsection

--[====[ IN-GAME CODE ]====]

require("Campbell")
require("Math")

centerX = 32
centerY = 32
pitchScaleSize = 32
pitchScaleIntervalDegree = 15

function drawSquareF(x1, y1, x2, y2, x3, y3, x4, y4)
    screen.drawTriangleF(x1, y1, x2, y2, x3, y3)
    screen.drawTriangleF(x1, y1, x4, y4, x3, y3)
end

function drm(x, y, v)
    screen.drawText(x, y - 6 + 6 * (math.max(v % 100, 99) - 99), math.floor((v + 100) / 100 % 10))
    screen.drawText(x, y + 6 * (math.max(v % 100, 99) - 99), math.floor(v / 100 % 10))
    screen.drawText(x + 5, y - 6 + 6 * (math.max(v % 10, 9) - 9), math.floor((v + 10) / 10 % 10))
    screen.drawText(x + 5, y + 6 * (math.max(v % 10, 9) - 9), math.floor(v / 10 % 10))
    screen.drawText(x + 10, y - 6 + 6 * (v % 1), math.floor((v + 1) % 10))
    screen.drawText(x + 10, y + 6 * (v % 1), math.floor(v % 10))
end

function onTick()
    airSpeed = clamp(input.getNumber(1), 0, 999)
    groundSpeed = input.getNumber(2) * 60 * 60 * 60 / 1000
    pressureAltitude = clamp(input.getNumber(3), 0, 999)
    radarAltitude = input.getNumber(4)
    rollRad = input.getNumber(5) * math.pi * 2
    pitchNormal = input.getNumber(6)
    headingDeg = (input.getNumber(12) * 360 + 360) % 360
    flightPathDeg = (input.getNumber(13) * 360 + 360) % 360
end

function onDraw()
    cyan()
    screen.drawClear()
    d0 = pitchNormal * 360 / 45
    yellow()
    drawSquareF(centerX + pitchScaleSize * (-d0 * math.sin(rollRad) + 1.5 * math.cos(rollRad)),
        centerY + pitchScaleSize * (-d0 * math.cos(rollRad) - 1.5 * math.sin(rollRad)),
        centerX + pitchScaleSize * (-d0 * math.sin(rollRad) - 1.5 * math.cos(rollRad)),
        centerY + pitchScaleSize * (-d0 * math.cos(rollRad) + 1.5 * math.sin(rollRad)),
        centerX + pitchScaleSize * ((3 - d0) * math.sin(rollRad) - 1.5 * math.cos(rollRad)),
        centerY + pitchScaleSize * ((3 - d0) * math.cos(rollRad) + 1.5 * math.sin(rollRad)),
        centerX + pitchScaleSize * ((3 - d0) * math.sin(rollRad) + 1.5 * math.cos(rollRad)),
        centerY + pitchScaleSize * ((3 - d0) * math.cos(rollRad) - 1.5 * math.sin(rollRad)))

    bwhite()
    for p = pitchScaleIntervalDegree, 90, pitchScaleIntervalDegree do
        d = (pitchNormal * 360 + p) / 45
        screen.drawLine(centerX + pitchScaleSize * (-d * math.sin(rollRad) + 0.5 * math.cos(rollRad)),
            centerY + pitchScaleSize * (-d * math.cos(rollRad) - 0.5 * math.sin(rollRad)),
            centerX + pitchScaleSize * (-d * math.sin(rollRad) - 0.5 * math.cos(rollRad)),
            centerY + pitchScaleSize * (-d * math.cos(rollRad) + 0.5 * math.sin(rollRad)))
        d = (pitchNormal * 360 - p) / 45
        screen.drawLine(centerX + pitchScaleSize * (-d * math.sin(rollRad) + 0.5 * math.cos(rollRad)),
            centerY + pitchScaleSize * (-d * math.cos(rollRad) - 0.5 * math.sin(rollRad)),
            centerX + pitchScaleSize * (-d * math.sin(rollRad) - 0.5 * math.cos(rollRad)),
            centerY + pitchScaleSize * (-d * math.cos(rollRad) + 0.5 * math.sin(rollRad)))
    end

    screen.setColor(0, 0, 0, 127)
    screen.drawRectF(0, 28, 16, 7)
    screen.drawRectF(48, 28, 16, 7)
    bwhite()
    screen.drawLine(centerX + pitchScaleSize / 8, centerY, centerX - pitchScaleSize / 8, centerY)
    screen.drawLine(centerX, centerY + pitchScaleSize / 8, centerX, centerY - pitchScaleSize / 8)
    drm(1, 29, airSpeed)
    drm(49, 29, pressureAltitude)
    green()
    screen.drawRectF(0, 23, 16, 5)
    screen.drawRectF(0, 35, 16, 5)
    screen.drawRectF(48, 23, 16, 5)
    screen.drawRectF(48, 35, 16, 5)
    bwhite()
    screen.drawText(1, 23, "SPD")
    screen.drawText(1, 35, "KPH")
    screen.drawText(49, 23, "ALT")
    screen.drawText(49, 35, "  M")
    screen.drawText(26, 1, string.format("%03.0f", headingDeg))
    --bgreen()
    bwhite()
    screen.drawText(1, 52, "GS")
    screen.drawText(1, 58, math.floor(groundSpeed + 0.5))
    screen.drawText(49, 52, "RA")
    screen.drawText(49, 58, math.floor(radarAltitude + 0.5))
    screen.drawText(26, 58, string.format("%03.0f", flightPathDeg))
end
