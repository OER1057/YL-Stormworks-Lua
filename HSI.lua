-- Author: OER1057
-- GitHub: https://github.com/OER1057/YL-Stormworks-Lua
-- Workshop: https://steamcommunity.com/profiles/76561199119398472/myworkshopfiles/?appid=573090
--
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey

--[====[ IN-GAME CODE ]====]
require("Math")

HSI = {
    targetNorth = 0, -- meter, 設定値
    targetEast = 0, -- meter, 設定値
    courceHeading = 0, -- deg(北→東), 設定値
    distance = 0, -- meter(前方: 正)
    targetHeading = 0, -- deg(北→東)
    direction = 0, -- deg(正面→右)
    gap = 0, -- meter(コースの右側正)
    --
    update = function(self, gpsNorth, gpsEast, heading) -- meter, meter, deg(北→東)
        self.distance = len(gpsNorth - self.targetNorth, gpsEast - self.targetEast)
        if math.abs(move(self.targetHeading, self.courceHeading, -180, 180)) > 90 then
            self.distance = -self.distance
        end
        self.targetHeading = coordinateToHeading(gpsNorth, gpsEast, self.targetNorth, self.targetEast)
        self.direction = move(self.targetHeading, heading, 0, 360)
        self.gap =
            -math.abs(self.distance) * math.sin(move(self.targetHeading, self.courceHeading, -180, 180) * _DEG_TO_RAD)
    end
}
