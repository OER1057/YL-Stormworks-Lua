-- Author: OER1057
-- GitHub: https://github.com/OER1057/YL-Stormworks-Lua
-- Workshop: https://steamcommunity.com/profiles/76561199119398472/myworkshopfiles/?appid=573090
--
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey

--[====[ IN-GAME CODE ]====]
require("Math.Clamp")

NormalPID = {
    ---NormalPIDの新しいインスタンスを返します
    ---@param pGain number Pゲイン
    ---@param lookaheadTicks number 先読み量/ticks
    ---@param limitMin number 最小値
    ---@param limitMax number 最大値
    ---@return NormalPID
    new = function(pGain, lookaheadTicks, limitMin, limitMax)
        ---@class NormalPID
        ---@field lastProcessBariable number 現在値
        ---@field pGain number Pゲイン
        ---@field lookaheadTicks number 先読み量/ticks
        ---@field output number 操作量
        ---@field limitMin number 最小値
        ---@field limitMax number 最大値
        return {
            lastProcessVariable = 0,
            pGain = pGain,
            lookaheadTicks = lookaheadTicks,
            output = 0,
            limitMin = limitMin,
            limitMax = limitMax,
            ---操作を実行し、操作量を返します
            ---@param self NormalPID
            ---@param setPoint number 目標値
            ---@param processVariable number 現在値
            ---@return number 操作量
            process = function(self, setPoint, processVariable)
                local processVariableDelta = processVariable - self.lastProcessVariable
                self.lastProcessVariable = processVariable
                self.output = clamp(
                    (setPoint - (processVariable + processVariableDelta * self.lookaheadTicks)) * self.pGain,
                    self.limitMin, self.limitMax)
                return self.output
            end
        }
    end
}
