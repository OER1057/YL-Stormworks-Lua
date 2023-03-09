-- Author: OER1057
-- GitHub: https://github.com/OER1057/YL-Stormworks-Lua
-- Workshop: https://steamcommunity.com/profiles/76561199119398472/myworkshopfiles/?appid=573090
--
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey

--[====[ IN-GAME CODE ]====]
require("Constants.Units")
require("Map.CoordinateToHeading")
require("Math.Len")
require("Math.Move")

---@class HSI
---@field targetNorth number 目的地のY座標/m
---@field targetEast number 目的地のX座標/m
---@field courceHeading number 経路の方位/hdg
---@field distance number 目的地への距離/m(前方)
---@field targetHeading number 目的地の方位/hdg
---@field direction number 目的地の機首方位に対する向き/deg(正面→右)
---@field gap number 経路に対する距離(右)
HSI = {
    targetNorth = 0,
    targetEast = 0,
    courceHeading = 0,
    distance = 0,
    targetHeading = 0,
    direction = 0,
    gap = 0,
    ---HSIを更新します
    ---@param self HSI
    ---@param gpsNorth number 現在地のY座標/m
    ---@param gpsEast number 現在値のX座標/m
    ---@param heading number 機首方位/hdg
    update = function(self, gpsNorth, gpsEast, heading)
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
