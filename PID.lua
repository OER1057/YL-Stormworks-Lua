-- Author: OER1057
-- GitHub: https://github.com/OER1057/YL-Stormworks-Lua
-- Workshop: https://steamcommunity.com/profiles/76561199119398472/myworkshopfiles/?appid=573090
--
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey

--[====[ IN-GAME CODE ]====]
require("Math")

NormalPid = {
    new = function(pGain, lookaheadTicks, limitMin, limitMax)
        return {
            lastProcessVariable = 0,
            pGain = pGain,
            lookaheadTicks = lookaheadTicks,
            output = 0,
            limitMin = limitMin,
            limitMax = limitMax,
            process = function(self, setPoint, processVariable)
                local processVariableDelta = processVariable - self.lastProcessVariable
                self.lastProcessVariable = processVariable
                self.output = clamp(
                    setPoint - (processVariable + processVariableDelta * self.lookaheadTicks) * self.pGain
                    , self.limitMin, self.limitMax)
                return self.output
            end
        }
    end
}

SpeedPid = {
    new = function(iGain, lookaheadTicks, limitMin, limitMax)
        return {
            lastProcessVariable = 0,
            iGain = iGain,
            lookaheadTicks = lookaheadTicks,
            output = 0,
            limitMin = limitMin,
            limitMax = limitMax,
            process = function(self, setPoint, processVariable)
                local processVariableDelta = processVariable - self.lastProcessVariable
                self.lastProcessVariable = processVariable
                self.output = clamp(self.output +
                (setPoint - (processVariable + processVariableDelta * self.lookaheadTicks)) * self.iGain
                    , self.limitMin
                    , self.limitMax)
                return self.output
            end
        }
    end
}

-- 一般的な定数

maxThrottle = 1
turbineMinThrottle = 0.01
turbineStartRPS = 0.5
