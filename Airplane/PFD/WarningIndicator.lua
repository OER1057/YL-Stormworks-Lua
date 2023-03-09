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
        simulator:setInputBool(1, simulator:getIsToggled(1))
        simulator:setInputBool(2, simulator:getIsToggled(2))
        simulator:setInputBool(3, simulator:getIsToggled(3))
        simulator:setInputBool(4, simulator:getIsToggled(4))
        simulator:setInputBool(5, simulator:getIsToggled(5))
        simulator:setInputBool(6, simulator:getIsToggled(6))
        simulator:setInputBool(7, simulator:getIsToggled(7))
        simulator:setInputBool(30, simulator:getIsToggled(8))
        simulator:setInputBool(31, simulator:getIsToggled(9))
        simulator:setInputBool(32, simulator:getIsToggled(10))
    end
end
---@endsection

--[====[ IN-GAME CODE ]====]
require("Monitor.Campbell")
centerX = 32
centerY = 32

function onTick()
    gpwsSinkRate = input.getBool(1)
    gpwsTerrain = input.getBool(2)
    gpwsPullUp = input.getBool(3)
    gpwsTooLow = input.getBool(4)
    gpwsTooLowGear = input.getBool(5)
    gpwsTooLowFlaps = input.getBool(6)
    stall = input.getBool(7)
    tcasTraffic = input.getBool(30)
    tcasDescend = input.getBool(31)
    tcasClimb = input.getBool(32)
end

function onDraw()
    if gpwsPullUp or stall or tcasDescend or tcasClimb then
        screen.setColor(40, 0, 0, 127)
        if gpwsPullUp then
            screen.drawRectF(centerX - 18, centerY - 4, 36, 7)
            bwhite()
            screen.drawText(centerX - 17, centerY - 3, "PULL UP")
        elseif stall then
            screen.drawRectF(centerX - 13, centerY - 4, 26, 7)
            bwhite()
            screen.drawText(centerX - 12, centerY - 3, "Stall")
        elseif tcasClimb then
            screen.drawRectF(centerX - 13, centerY - 4, 26, 7)
            bwhite()
            screen.drawText(centerX - 12, centerY - 3, "Climb")
        elseif tcasDescend then
            screen.drawRectF(centerX - 19, centerY - 4, 38, 7)
            bwhite()
            screen.drawText(centerX - 18, centerY - 3, "Descend")
        end
    else
        textToShow = "\n"
        if gpwsSinkRate then textToShow = textToShow .. " Sink Rate\n"; end
        if gpwsTerrain then textToShow = textToShow .. " Terrain\n"; end
        if gpwsTooLow then textToShow = textToShow .. " Too Low\n"; end
        if gpwsTooLowGear then textToShow = textToShow .. " Gear\n"; end
        if gpwsTooLowFlaps then textToShow = textToShow .. " Flaps\n"; end
        if tcasTraffic then textToShow = textToShow .. " Traffic\n"; end
        bred()
        screen.drawTextBox(0, 0, centerX * 2, centerY * 2, textToShow, 0, 0)
    end
end
