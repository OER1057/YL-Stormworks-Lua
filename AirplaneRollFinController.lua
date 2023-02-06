-- Author: OER1057
-- GitHub: https://github.com/OER1057
-- Workshop: https://steamcommunity.com/profiles/76561199119398472/myworkshopfiles/?appid=573090
--
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey

--[====[ IN-GAME CODE ]====]

require("Math")

RollSpeedTurnsPerSec = {
    now = 0,
    delta = 0,
    update = function(self, nowval)
        self.delta = nowval - self.now
        self.now = nowval
    end
}
aileronOutput = 0
targetRollSpeedTurnsPerSec = property.getNumber("Roll Speed [turns/s]")
iGainAt400Kmph = property.getNumber("Roll I Gain at 400 km/h")
lookaheadTicks = property.getNumber("Roll Lookahead [ticks]")

function onTick()
    mode = 1
    RollSpeedTurnsPerSec:update(input.getNumber(7))
    seatRollInput = input.getNumber(31)
    airSpeed = math.max(input.getNumber(1), 100)
    iGain = iGainAt400Kmph * 400 / airSpeed
    aileronOutput = clamp(aileronOutput +
        (
        targetRollSpeedTurnsPerSec * seatRollInput -
            (RollSpeedTurnsPerSec.now + RollSpeedTurnsPerSec.delta * lookaheadTicks)) * iGain, -1, 1)
    output.setNumber(1, aileronOutput)
    output.setNumber(11, -aileronOutput)
end
