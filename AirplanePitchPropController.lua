-- Author: OER1057
-- GitHub: https://github.com/OER1057
-- Workshop: https://steamcommunity.com/profiles/76561199119398472/myworkshopfiles/?appid=573090
--
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey

--[====[ IN-GAME CODE ]====]

require("PID")

targetPitchSpeedTurnsPerSec = property.getNumber("Pitch Speed [turns/s]")
iGainAt40RPS = property.getNumber("Pitch I Gain at 40 RPS")
lookaheadTicks = property.getNumber("Pitch Lookahead [ticks]")
elevatorPID = SpeedPid.new(0, lookaheadTicks, -1, 1)

function onTick()
    mode = 1
    pitchSpeedTurnsPerSec = input.getNumber(8)
    seatPitchInput = input.getNumber(31)
    local targetPitchSpeedTurnsPerSec = targetPitchSpeedTurnsPerSec * seatPitchInput
    propRPS = math.max(input.getNumber(32), 6.666)
    elevatorPID.iGain = iGainAt40RPS * 40 / propRPS
    output.setNumber(2, elevatorPID:process(targetPitchSpeedTurnsPerSec, pitchSpeedTurnsPerSec))
end
