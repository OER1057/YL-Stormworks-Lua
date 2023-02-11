function clamp(val, min, max)
    return math.max(math.min(val, max), min)
end

function between(val, min, max)
    return min <= val and val < max
end
