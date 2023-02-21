-- Author: OER1057
-- GitHub: https://github.com/OER1057/YL-Stormworks-Lua
-- Workshop: https://steamcommunity.com/profiles/76561199119398472/myworkshopfiles/?appid=573090
--
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey

--[====[ IN-GAME CODE ]====]
require("HSI")

ILS = {
    glideSlopeAngle = 0.05236, -- rad, 設定値
    runwayHeading = 0, -- deg(北→東), 設定値
    horizontalGap = 0, -- meter(グライドスロープより右側正)
    verticalGap = 0, -- meter(グライドスロープより上側正)
    --
    update = function(self, HSI, altitude) -- HSIobj, meter, HSIの目的地を着陸位置に設定
        self.horizontalGap = HSI.gap
        self.verticalGap = altitude - HSI.distance * math.tan(self.glideSlopeAngle)
    end,
}
