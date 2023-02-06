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
    simulator:setScreen(1, "3x3")
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

function inarea(n, x, y) return area[n][1] <= x and x < area[n][1] + area[n][3] and area[n][2] <= y and
        y < area[n][2] + area[n][4];
end

area = {}
for x = 1, 2 do
    for y = 0, 2 do
        area[2 * y + x] = { -21 + 29 * x, 11 + 7 * y, 19, 5 }
    end
end
switchLabel = { "NAVI", "LOGO", "BCON", "TAXI", "STRB", "LNDG" }
switchState = { property.getBool("NAVI Default State"),
    property.getBool("LOGO Default State"),
    property.getBool("BCON Default State"),
    property.getBool("TAXI Default State"),
    property.getBool("STRB Default State"),
    property.getBool("LNDG Default State") }

function onTick()
    isTouched = input.getBool(1)
    touchX = input.getNumber(3)
    touchY = input.getNumber(4)
    if isTouched then
        pushingTime = pushingTime + 1 or 0
    else
        pushingTime = 0
    end
    isTouchedNow = pushingTime == 1
    for num = 1, #area do
        if isTouchedNow and inarea(num, touchX, touchY) then
            switchState[num] = not switchState[num]
        end
        output.setBool(num, switchState[num])
    end
    -- end
end

function onDraw()
    black()
    screen.drawClear()
    bwhite()
    screen.drawText(8, 1, "EXT");
    screen.drawText(27, 1, "LIGHTS")
    for num = 1, #area do
        bwhite()
        screen.drawText(area[num][1], area[num][2], switchLabel[num])
        if switchState[num] then
            bgreen()
            screen.drawRectF(area[num][1], area[num][2] + area[num][4], area[num][3], 1)
        end
    end
end
