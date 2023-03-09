---`val`が`min`以上`max`未満の範囲にあるかどうかを返します
---@param val number
---@param min number
---@param max number
---@return boolean
function between(val, min, max)
    return min <= val and val < max
end
