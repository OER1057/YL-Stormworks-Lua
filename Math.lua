function clamp(val, min, max)
    return math.max(math.min(val, max), min)
end

function between(val, min, max)
    return min <= val and val < max
end

function len(x, y)
    return math.sqrt(x ^ 2 + y ^ 2)
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
