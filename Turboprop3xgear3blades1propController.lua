-- Author: OER1057
-- GitHub: https://github.com/OER1057/YL-Stormworks-Lua
-- Workshop: https://steamcommunity.com/profiles/76561199119398472/myworkshopfiles/?appid=573090
--
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey

--[====[ IN-GAME CODE ]====]

require("PID")

-- 3-3-1 固有設定値
iGain = 0.005
throttlePID = SpeedPid.new(iGain, nil, turbineMinThrottle, maxThrottle)
function lookaheadTicks(turbineRPS)
    return 1 / (turbineRPS + 10) * 2000 + 9
end

idleRPS = property.getNumber("Idle RPS")
maxRPS = property.getNumber("100% RPS")
engineNumber = property.getNumber("Engine Number")

function onTick()
    throttleInputPercent = input.getNumber(1)
    turbineRPS = input.getNumber(2)
    isEngineOn = input.getBool(engineNumber)
    isStarterOn = input.getBool(16)

    if isEngineOn then
        throttlePID.lookaheadTicks = lookaheadTicks(turbineRPS)
        targetRPS = math.max(idleRPS, maxRPS * throttleInputPercent / 100)
        throttlePID:process(targetRPS, turbineRPS)
    else
        throttlePID.output = 0
    end
    output.setNumber(1, throttlePID.output)

    if isEngineOn and isStarterOn and turbineRPS < turbineStartRPS then
        starterThrottle = 1
    else
        starterThrottle = 0
    end
    output.setNumber(2, starterThrottle)
end
