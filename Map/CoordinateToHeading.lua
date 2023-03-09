require("Constants.Units")

---マップ上の基準地から目的地を向いた方角を返します
---@param originNorth number 基準地のY座標/m
---@param originEast number 基準地のX座標/m
---@param targetNorth number 目的地のY座標/m
---@param targetEast number 目的地のX座標/m
---@return number 方角 /hdg
function coordinateToHeading(originNorth, originEast, targetNorth, targetEast)
    return (math.atan(targetEast - originEast, targetNorth - originNorth) * _RAD_TO_DEG) % 360
end
