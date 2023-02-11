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

    ;
end
---@endsection

--[====[ IN-GAME CODE ]====]
require("MonitorButton")

TouchArea:addArea("1", 0, 0, 16, 16)
TouchArea:addArea("2", 16, 0, 16, 16)
TouchArea:addArea("3", 0, 16, 16, 16)
TouchArea:addArea("4", 16, 16, 16, 16)

push1 = PushButton.new()
push2 = PushButton.new()
push3 = PushButton.new()
push4 = PushButton.new()

toggle1 = ToggleButton.new(false, 1, 1)
toggle2 = ToggleButton.new(true, 1, 1)
toggle3 = ToggleButton.new(false, 60, 1)
toggle4 = ToggleButton.new(false, 1, 60)

function onTick()
    isTouched = input.getBool(1)
    touchX = input.getNumber(3)
    touchY = input.getNumber(4)
    TouchArea:update(isTouched, touchX, touchY)
    area1IsTouched = TouchArea.whichArea == "1"
    area2IsTouched = TouchArea.whichArea == "2"
    area3IsTouched = TouchArea.whichArea == "3"
    area4IsTouched = TouchArea.whichArea == "4"
    output.setBool(1, area1IsTouched)
    output.setBool(2, area2IsTouched)
    output.setBool(3, area3IsTouched)
    output.setBool(4, area4IsTouched)

    push1:update(area1IsTouched)
    push2:update(area2IsTouched)
    push3:update(area3IsTouched)
    push4:update(area4IsTouched)
    output.setNumber(1, push1.pushedTime)
    output.setNumber(2, push2.pushedTime)
    output.setNumber(3, push3.pushedTime)
    output.setNumber(4, push4.pushedTime)

    toggle1:update(area1IsTouched)
    toggle2:update(area2IsTouched)
    toggle3:update(area3IsTouched)
    toggle4:update(area4IsTouched)
    output.setBool(5, toggle1.isOn)
    output.setBool(6, toggle2.isOn)
    output.setBool(7, toggle3.isOn)
    output.setBool(8, toggle4.isOn)
end
