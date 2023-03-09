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
