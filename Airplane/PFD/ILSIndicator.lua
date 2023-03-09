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
    simulator:setProperty("ILS Indicator Size [%]", 50)
    simulator:setProperty("ILS Max Gap [m]", 50)
    simulator:setProperty("Horizontal FOV [deg]", 90)

    -- Runs every tick just before onTick; allows you to simulate the inputs changing
    ---@param simulator Simulator Use simulator:<function>() to set inputs etc.
    ---@param ticks     number Number of ticks since simulator started
    function onLBSimulatorTick(simulator, ticks)
        simulator:setInputNumber(1, (simulator:getSlider(1) - 0.5) * 2 * 100)
        simulator:setInputNumber(2, (simulator:getSlider(2) - 0.5) * 2 * 100)
        simulator:setInputNumber(3, (simulator:getSlider(3) - 0.5) * 360)
    end
end
---@endsection

--[====[ IN-GAME CODE ]====]
-- input channels
CHANNEL_VERTICAL_GAP = 1
CHANNEL_HORIZONTAL_GAP = 2
CHANNEL_HORIZONTAL_DIRECTION = 3
CHANNEL_DISTANCE = 4

gapLookahead = 30    -- ticks
gapLookaheadSize = 4 -- px

require("Math.Clamp")
require("Monitor.Campbell")
blinker = {
    interval = 40, -- ticks, 設定値
    ratio = 0.6,   -- 0-1(1: on), 設定値
    isOn = true,   -- bool
    count = 0,     -- [0,interval)
    update = function(self)
        self.count = (self.count + 1) % self.interval
        self.isOn = self.count < self.interval * self.ratio
        return self.isOn
    end
}

function onTick()
    ilsVerticalGap = input.getNumber(CHANNEL_VERTICAL_GAP)       -- meter(グライドスロープ上側正)
    ilsHorizontalGap = input.getNumber(CHANNEL_HORIZONTAL_GAP)   -- meter(グライドスロープ右側正)
    hsiDirection = input.getNumber(CHANNEL_HORIZONTAL_DIRECTION) -- deg(正面→右)
    hsiDistance = input.getNumber(CHANNEL_DISTANCE)              -- meter
end

function onDraw()
    if initialized == nil then
        initialized = true
        --
        screenWidth = screen.getWidth()                                                                           -- px
        screenHeight = screen.getHeight()                                                                         -- px
        centerX = screenWidth / 2                                                                                 -- px
        centerY = screenHeight / 2                                                                                -- px
        viewRadius = math.min(screenWidth, screenHeight) * property.getNumber("ILS Indicator Size [%]") / 100 / 2 -- px
        --
        ilsLimit = property.getNumber("ILS Max Gap [m]")                                                          -- meter
        --
        hsiLimit = property.getNumber("Horizontal FOV [deg]") * (2 * viewRadius) / screenWidth                    -- deg
        hsiPositionY = screenHeight - (1 + _FONT_HEIGHT + 1 + 1)
    end
    --
    bred()
    blinker:update()
    -- ILS
    if math.abs(hsiDirection) > 90 or hsiDistance < 0 then -- 前方でないときと通り過ぎたときはエラー表示
        if blinker.isOn then
            screen.drawLine(
                centerX - viewRadius / 2, centerY - viewRadius / 2,
                centerX + viewRadius / 2, centerY + viewRadius / 2)
            screen.drawLine(
                centerX + viewRadius / 2, centerY - viewRadius / 2,
                centerX - viewRadius / 2, centerY + viewRadius / 2)
        end
    else
        -- 横棒
        if true then
            screen.drawRectF(centerX - viewRadius, centerY + viewRadius * clamp(ilsVerticalGap / ilsLimit, -1, 1),
                2 * viewRadius, 1)
        end
        -- 縦棒
        if math.abs(math.atan(ilsHorizontalGap, hsiDistance)) <= math.pi / 2 or blinker.isOn then -- 左右45度範囲内でなければ点滅
            screen.drawRectF(centerX - viewRadius * clamp(ilsHorizontalGap / ilsLimit, -1, 1), centerY - viewRadius,
                1, 2 * viewRadius)
        end
    end
    -- HSI(方向表示)
    if math.abs(hsiDirection) <= 45 or blinker.isOn then -- 左右45度範囲内でなければ点滅
        screen.drawRectF(centerX + viewRadius * clamp(hsiDirection, -hsiLimit, hsiLimit) / hsiLimit, hsiPositionY,
            1, 1)
    end
end
