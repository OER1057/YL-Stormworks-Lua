function move(after, before, rangeMin, rangeMax) -- 移動量
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
