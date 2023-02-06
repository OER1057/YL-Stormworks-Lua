-- Author: OER1057
-- GitHub: https://github.com/OER1057
-- Workshop: https://steamcommunity.com/profiles/76561199119398472/myworkshopfiles/?appid=573090
--
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey

--[====[ IN-GAME CODE ]====]

require("Math")

PitchSpeedTurnsPerSec = {
    now = 0,
    delta = 0,
    update = function(self, nowval)
        self.delta = nowval - self.now
        self.now = nowval
    end
}
elevatorOutput = 0
targetPitchSpeedTurnsPerSec = property.getNumber("Pitch Speed [turns/s]")
iGainAt40RPS = property.getNumber("Pitch I Gain at 40 RPS")
lookaheadTicks = property.getNumber("Pitch Lookahead [ticks]")

function onTick()
    mode = 1
    PitchSpeedTurnsPerSec:update(input.getNumber(8))
    seatPitchInput = input.getNumber(31)
    propRPS = math.max(input.getNumber(32), 6.666)
    iGain = iGainAt40RPS * 40 / propRPS
    elevatorOutput = clamp(elevatorOutput +
        (
        targetPitchSpeedTurnsPerSec * seatPitchInput -
            (PitchSpeedTurnsPerSec.now + PitchSpeedTurnsPerSec.delta * lookaheadTicks)) * iGain, -1, 1)
    output.setNumber(2, elevatorOutput)
end
