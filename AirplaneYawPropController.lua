-- Author: OER1057
-- GitHub: https://github.com/OER1057
-- Workshop: https://steamcommunity.com/profiles/76561199119398472/myworkshopfiles/?appid=573090
--
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey

--[====[ IN-GAME CODE ]====]

require("PID")

targetYawSpeedTurnsPerSec = property.getNumber("Yaw Speed [turns/s]")
iGainAt40RPS = property.getNumber("Yaw I Gain at 40 RPS")
lookaheadTicks = property.getNumber("Yaw Lookahead [ticks]")
rudderPID = SpeedPid.new(0, lookaheadTicks, -1, 1)

function onTick()
    mode = 1
    yawSpeedTurnsPerSec = input.getNumber(9)
    seatYawInput = input.getNumber(31)
    local targetYawSpeedTurnsPerSec = targetYawSpeedTurnsPerSec * seatYawInput
    propRPS = math.max(input.getNumber(32), 6.666)
    rudderPID.iGain = iGainAt40RPS * 40 / propRPS
    output.setNumber(4, rudderPID:process(targetYawSpeedTurnsPerSec, yawSpeedTurnsPerSec))
end
