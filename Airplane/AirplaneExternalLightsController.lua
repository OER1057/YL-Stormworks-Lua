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
    simulator:setScreen(1, "2x1")
    simulator:setProperty("NAVI Default State", true)
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

buttons = {}

buttonName = { "NAVI", "LOGO", "BCON", "TAXI", "STRB", "LNDG" }
buttonWidth = 19
buttonHeight = 5
for index, name in ipairs(buttonName) do
    x = 8 + 29 * ((index - 1) % 2)
    y = 11 + 7 * math.floor((index - 1) / 2)
    TouchArea:addArea(name, x, y, buttonWidth, buttonHeight)
    defaultState = property.getBool(name .. " Default State")
    buttons[name] = ToggleButton.new(defaultState, 1, 1)
end

function onTick()
    isTouched = input.getBool(1)
    touchX = input.getNumber(3)
    touchY = input.getNumber(4)
    TouchArea:update(isTouched, touchX, touchY)
    for name, button in pairs(buttons) do
        button:update(TouchArea.whichArea == name)
    end
    output.setBool(1, buttons["NAVI"].isOn)
    output.setBool(2, buttons["LOGO"].isOn)
    output.setBool(3, buttons["BCON"].isOn)
    output.setBool(4, buttons["TAXI"].isOn)
    output.setBool(5, buttons["STRB"].isOn)
    output.setBool(6, buttons["LNDG"].isOn)
end

function onDraw()
    black()
    screen.drawClear()
    bwhite()
    screen.drawText(8, 1, "EXT");
    screen.drawText(27, 1, "LIGHTS")
    for name, button in pairs(buttons) do
        bwhite()
        screen.drawText(TouchArea.areaList[name].xStart, TouchArea.areaList[name].yStart, name)
        if button.isOn then
            bgreen()
            screen.drawRectF(TouchArea.areaList[name].xStart, TouchArea.areaList[name].yEnd,
                TouchArea.areaList[name].xEnd - TouchArea.areaList[name].xStart, 1)
        end
    end
end
