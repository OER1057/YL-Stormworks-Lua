---最小値と最大値の間で循環するような2つの値について、境界を考慮した変化量を返します。
---@param after number 変化後
---@param before number 変化前
---@param rangeMin number 最小値
---@param rangeMax number 最大値
---@return number 変化量
function move(after, before, rangeMin, rangeMax)
    local move = after - before
    local range = rangeMax - rangeMin
    if move < 0 then                             -- オーバーフローの可能性
        fixedMove = move + range                 -- (x + move + range) - x
    else                                         -- アンダーフローの可能性
        fixedMove = move - range                 -- (x + move - range) - x
    end
    if math.abs(move) < math.abs(fixedMove) then -- 補正後より変化量が小さかったら
        return move                              -- 補正前
    else
        return fixedMove
    end
end
