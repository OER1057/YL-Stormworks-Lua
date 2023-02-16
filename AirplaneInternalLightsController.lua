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
    simulator:setProperty("CKPT Default State", true)
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

buttonName = { "CKPT", "CABN", "BLT", "SMK", "EXT" }
for index, name in ipairs(buttonName) do
    if index <= 2 then
        x = 8 + 29 * (index - 1)
        y = 11
        buttonWidth = 19
        buttonHeight = 5
    else
        x = 5 + 20 * (index - 3)
        y = 25
        buttonWidth = 14
        buttonHeight = 5
    end
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
    output.setBool(1, buttons["CKPT"].isOn)
    output.setBool(2, buttons["CABN"].isOn)
    output.setBool(3, buttons["BLT"].isOn)
    output.setBool(4, buttons["SMK"].isOn)
    output.setBool(5, buttons["EXT"].isOn)
end

function onDraw()
    black()
    screen.drawClear()
    bwhite()
    screen.drawText(8, 1, "INT");
    screen.drawText(27, 1, "LIGHTS")
    screen.drawText(20, 18, "SIGNS")
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
