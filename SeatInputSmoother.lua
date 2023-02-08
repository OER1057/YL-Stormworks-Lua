-- Author: OER1057
-- GitHub: https://github.com/OER1057/YL-Stormworks-Lua
-- Workshop: https://steamcommunity.com/profiles/76561199119398472/myworkshopfiles/?appid=573090
--
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey

--[====[ IN-GAME CODE ]====]

InputSmoother = {
    new = function(maxValue, timeToMaxTicks, timeToZeroTicks)
        return {
            output = 0,
            positiveOutput = 0,
            negativeOutput = 0,
            update = function(self, input)
                if input == 0 then
                    self.positiveOutput = math.max(0, self.positiveOutput - maxValue / timeToZeroTicks)
                    self.negativeOutput = math.min(0, self.negativeOutput + maxValue / timeToZeroTicks)
                elseif input > 0 then
                    self.positiveOutput = math.min(maxValue, self.positiveOutput + maxValue / timeToMaxTicks)
                    self.negativeOutput = 0
                else
                    self.positiveOutput = 0
                    self.negativeOutput = math.max(-maxValue, self.negativeOutput - maxValue / timeToMaxTicks)
                end
                self.output = self.positiveOutput + self.negativeOutput
                return self.output
            end
        }
    end
}
