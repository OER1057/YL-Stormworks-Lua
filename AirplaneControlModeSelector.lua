-- Author: OER1057
-- GitHub: https://github.com/OER1057/YL-Stormworks-Lua
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
    simulator:setProperty("Default Roll Mode", 1)
    simulator:setProperty("Default Pitch Mode", 1)
    simulator:setProperty("Default Yaw Mode", 3)

    -- Runs every tick just before onTick; allows you to simulate the inputs changing
    ---@param simulator Simulator Use simulator:<function>() to set inputs etc.
    ---@param ticks     number Number of ticks since simulator started
    function onLBSimulatorTick(simulator, ticks)
        -- touchscreen defaults
        local screenConnection = simulator:getTouchScreen(1)
        simulator:setInputBool(1, screenConnection.isTouched)
        simulator:setInputNumber(1, screenConnection.width)
        simulator:setInputNumber(2, screenConnection.height)
        simulator:setInputNumber(3, screenConnection.touchX)
        simulator:setInputNumber(4, screenConnection.touchY)
    end
end
---@endsection


--[====[ IN-GAME CODE ]====]
require("Campbell")
require("MonitorButton")

rollMode = {
    current = property.getNumber("Default Roll Mode"),
    names = { "Direct", "Stabilize", "Hold", "Autopilot", "Landing" }
}
pitchMode = {
    current = property.getNumber("Default Pitch Mode"),
    names = { "Direct", "Stabilize", "Hold", "Autopilot", "Landing" }
}
yawMode = {
    current = property.getNumber("Default Yaw Mode"),
    names = { "Direct", "Stabilize", "TurnCoordinate" }
}

buttons = {}
buttonName = { "DirectRoll", "StabilizeRoll", "HoldRoll", "AutopilotRoll", "LandingRoll",
    "DirectPitch", "StabilizePitch", "HoldPitch", "AutopilotPitch", "LandingPitch",
    "DirectYaw", "StabilizeYaw", "TurnCoordinateYaw" }
buttonWidth = 4
buttonHeight = 5
for index, name in ipairs(buttonName) do
    x = 7 + 5 * ((index - 1) % 5)
    y = 11 + 7 * math.floor((index - 1) / 5)
    TouchArea:addArea(name, x, y, buttonWidth, buttonHeight)
    buttons[name] = PushButton.new()
end

function onTick()
    isTouched = input.getBool(1)
    touchX = input.getNumber(3)
    touchY = input.getNumber(4)
    TouchArea:update(isTouched, touchX, touchY)
    for name, button in pairs(buttons) do
        button:update(TouchArea.whichArea == name)
    end

    for index, name in pairs(rollMode.names) do
        buttonName = name .. "Roll"
        if buttons[buttonName].isPushedNow then
            rollMode.current = index
        end
    end
    for index, name in pairs(pitchMode.names) do
        buttonName = name .. "Pitch"
        if buttons[buttonName].isPushedNow then
            pitchMode.current = index
        end
    end
    if rollMode.current >= 4 then
        yawMode.current = 3
    else
        for index, name in pairs(yawMode.names) do
            buttonName = name .. "Yaw"
            if buttons[buttonName].isPushedNow then
                yawMode.current = index
            end
        end
    end


    if isTouched then
        output.setNumber(1, -1)
        output.setNumber(2, -1)
        output.setNumber(3, -1)
    else
        output.setNumber(1, rollMode.current)
        output.setNumber(2, pitchMode.current)
        output.setNumber(3, yawMode.current)
    end
end

function onDraw()
    black()
    screen.drawClear()
    bwhite()
    screen.drawText(7, 1, "CTRL")
    screen.drawText(1, 11, "R")
    screen.drawText(1, 18, "P")
    screen.drawText(1, 25, "Y")
    for name, button in pairs(buttons) do
        bwhite()
        screen.drawText(TouchArea.areaList[name].xStart, TouchArea.areaList[name].yStart, string.sub(name, 1, 1))
    end
    bgreen()
    screen.drawRectF(7 + 5 * (rollMode.current - 1), 11 + buttonHeight, buttonWidth, 1)
    screen.drawRectF(7 + 5 * (pitchMode.current - 1), 18 + buttonHeight, buttonWidth, 1)
    screen.drawRectF(7 + 5 * (yawMode.current - 1), 25 + buttonHeight, buttonWidth, 1)
end
