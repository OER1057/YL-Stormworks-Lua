-- Author: OER1057
-- GitHub: https://github.com/OER1057/YL-Stormworks-Lua
-- Workshop: https://steamcommunity.com/profiles/76561199119398472/myworkshopfiles/?appid=573090
--
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey

--[====[ IN-GAME CODE ]====]

require("Math")

SpeedPid = {}
SpeedPid.new = function(iGain, lookaheadTicks, limitMin, limitMax)
    local obj = {}
    obj.lastProcessVariable = 0
    obj.iGain = iGain
    obj.lookaheadTicks = lookaheadTicks
    obj.output = 0
    obj.limitMin = limitMin
    obj.limitMax = limitMax
    function obj.process(self, setPoint, processVariable) -- obj:processにするとminifyでバグる
        local processVariableDelta = processVariable - self.lastProcessVariable
        self.lastProcessVariable = processVariable
        self.output = clamp(self.output +
            (setPoint - (processVariable + processVariableDelta * self.lookaheadTicks)) * self.iGain
            , self.limitMin
            , self.limitMax)
        return self.output
    end

    return obj
end
