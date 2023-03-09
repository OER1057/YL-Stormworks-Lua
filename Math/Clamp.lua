---`val`を`min`から`max`の間に挟みこんだ値を返します
---@param val number
---@param min number
---@param max number
---@return number
function clamp(val, min, max)
    return math.max(math.min(val, max), min)
end
