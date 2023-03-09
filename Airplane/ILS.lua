-- Author: OER1057
-- GitHub: https://github.com/OER1057/YL-Stormworks-Lua
-- Workshop: https://steamcommunity.com/profiles/76561199119398472/myworkshopfiles/?appid=573090
--
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey

--[====[ IN-GAME CODE ]====]
require("Airplane.HSI")

---@class ILS
---@field glideSlopeAngle number グライドスロープの角度/rad
---@field runwayHeading number 滑走路方位/hdg
---@field horizontalGap number グライドスロープとの水平方向の差異/m(右側)
---@field verticalGap number グライドスロープとの鉛直方向の差異/m(上側)
ILS = {
    glideSlopeAngle = 0.05236,
    runwayHeading = 0,
    horizontalGap = 0,
    verticalGap = 0,
    ---ILSを更新します
    ---@param self ILS
    ---@param HSI HSI 目的地を着陸位置に設定
    ---@param altitude number 現在高度
    update = function(self, HSI, altitude)
        self.horizontalGap = HSI.gap
        self.verticalGap = altitude - HSI.distance * math.tan(self.glideSlopeAngle)
    end,
}
