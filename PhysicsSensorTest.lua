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
        simulator:setInputNumber(4, (simulator:getSlider(1) - 0.5) * 2 * math.pi)
        simulator:setInputNumber(5, (simulator:getSlider(2) - 0.5) * math.pi)
        simulator:setInputNumber(6, (simulator:getSlider(3) - 0.5) * 2 * math.pi)
    end
end
---@endsection

--[====[ IN-GAME CODE ]====]
sin = math.sin
cos = math.cos

function turnAroundX(vector, X)
    return {
        x = vector.x,
        y = vector.y * cos(X) - vector.z * sin(X),
        z = vector.y * sin(X) + vector.z * cos(X)
    }
end

function turnAroundY(vector, Y)
    return {
        x = vector.x * cos(Y) + vector.z * sin(Y),
        y = vector.y,
        z = -vector.x * sin(Y) + vector.z * cos(Y)
    }
end

function turnAroundZ(vector, Z)
    return {
        x = vector.x * cos(Z) - vector.y * sin(Z),
        y = vector.x * sin(Z) + vector.y * cos(Z),
        z = vector.z
    }
end

function onTick()
    -- ワールド座標軸XYZオイラー角(rad)
    X = input.getNumber(4)
    Y = input.getNumber(5)
    Z = input.getNumber(6)
    -- ローカル座標の基底
    localX = { x = 1, y = 0, z = 0 }
    localY = { x = 0, y = 1, z = 0 }
    localZ = { x = 0, y = 0, z = 1 }
    -- X軸まわり回転
    localX = turnAroundX(localX, X)
    localY = turnAroundX(localY, X)
    localZ = turnAroundX(localZ, X)
    -- Y軸まわり回転
    localX = turnAroundY(localX, Y)
    localY = turnAroundY(localY, Y)
    localZ = turnAroundY(localZ, Y)
    -- Z軸まわり回転
    localX = turnAroundZ(localX, Z)
    localY = turnAroundZ(localY, Z)
    localZ = turnAroundZ(localZ, Z)
end

require("Monitor.Campbell")
function onDraw()
    screenWidth = screen.getWidth()
    screenHeight = screen.getHeight()
    centerX = screenWidth / 2
    centerY = screenHeight / 2
    radius = math.min(screenWidth, screenHeight) / 2
    -- ワールド軸
    white()
    screen.drawLine(centerX, centerY, screenWidth, centerY)
    screen.drawLine(centerX, centerY, centerX, 0)
    -- ローカル軸
    bred()
    screen.drawLine(centerX, centerY, centerX + localX.x * radius, centerY - localX.z * radius)
    bgreen()
    screen.drawLine(centerX, centerY, centerX + localY.x * radius, centerY - localY.z * radius)
    bblue()
    screen.drawLine(centerX, centerY, centerX + localZ.x * radius, centerY - localZ.z * radius)
end
