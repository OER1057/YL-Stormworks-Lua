-- Author: OER1057
-- GitHub: https://github.com/OER1057
-- Workshop: https://steamcommunity.com/profiles/76561199119398472/myworkshopfiles/?appid=573090
--
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey

--[====[ IN-GAME CODE ]====]

require("PID")

targetRollSpeedTurnsPerSec = property.getNumber("Roll Speed [turns/s]")
iGainAt400Kmph = property.getNumber("Roll I Gain at 400 km/h")
lookaheadTicks = property.getNumber("Roll Lookahead [ticks]")
aileronPID = SpeedPid.new(0, lookaheadTicks, -1, 1)

function onTick()
    mode = 1
    rollSpeedTurnsPerSec = input.getNumber(7)
    seatRollInput = input.getNumber(31)
    local targetRollSpeedTurnsPerSec = targetRollSpeedTurnsPerSec * seatRollInput
    airSpeed = math.max(input.getNumber(1), 100)
    aileronPID.iGain = iGainAt400Kmph * 400 / airSpeed
    output.setNumber(1, aileronPID:process(targetRollSpeedTurnsPerSec, rollSpeedTurnsPerSec))
    output.setNumber(11, -aileronPID.output)
end
