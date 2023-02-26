-- 単位換算
_TURNS_TO_RAD = 2 * math.pi
_TURNS_TO_DEG = 360
_DEG_TO_RAD = math.pi / 180
_RAD_TO_DEG = _DEG_TO_RAD ^ -1
_MPS_TO_KPH = 3.6 -- 60 * 60 / 1000
_SEC_TO_TICKS = 62
_TICKS_TO_SEC = _SEC_TO_TICKS ^ -1

function clamp(val, min, max)
    return math.max(math.min(val, max), min)
end

function round(val)
    return math.floor(val + 0.5)
end

function between(val, min, max)
    return min <= val and val < max
end

function len(x, y)
    return math.sqrt(x ^ 2 + y ^ 2)
end

function coordinateToHeading(originNorth, originEast, targetNorth, targetEast) -- deg(北→東)
    return (math.atan(targetEast - originEast, targetNorth - originNorth) * _RAD_TO_DEG + 360) % 360
end

function move(after, before, rangeMin, rangeMax) -- 移動量
    local move = after - before
    local range = rangeMax - rangeMin
    if move < 0 then -- オーバーフローの可能性
        fixedMove = move + range -- (x + move + range) - x
    else -- アンダーフローの可能性
        fixedMove = move - range -- (x + move - range) - x
    end
    if math.abs(move) < math.abs(fixedMove) then -- 補正後より変化量が小さかったら
        return move -- 補正前
    else
        return fixedMove
    end
end

Delta = {
    new = function()
        return {
            lastValue = 0,
            delta = 0,
            update = function(self, newValue)
                self.delta = newValue - self.lastValue
                self.lastValue = newValue
                return self.delta
            end
        }
    end
}
