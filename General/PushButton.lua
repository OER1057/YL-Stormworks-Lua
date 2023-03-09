-- Author: OER1057
-- GitHub: https://github.com/OER1057/YL-Stormworks-Lua
-- Workshop: https://steamcommunity.com/profiles/76561199119398472/myworkshopfiles/?appid=573090
--
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey

--[====[ IN-GAME CODE ]====]
require("Math.Between")

PushButton = {
    ---PushButtonの新しいインスタンスを返します
    ---@return PushButton
    new = function()
        ---@class PushButton
        ---@field pushedTime integer 押されていた時間/ticks
        ---@field isPushedNow boolean 押された瞬間か否か
        ---@field isPushed boolean 押されているか否か
        return {
            pushedTime = 0,
            isPushedNow = false,
            isPushed = false,
            ---状態を更新します
            ---@param self PushButton
            ---@param isPushing boolean 押しているか否か
            update = function(self, isPushing)
                if isPushing then
                    self.isPushed = true
                    self.pushedTime = self.pushedTime + 1
                else
                    self.isPushed = false
                    self.pushedTime = 0
                end
                self.isPushedNow = self.pushedTime == 1
            end
        }
    end
}
