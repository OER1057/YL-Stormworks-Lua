require("General.PushButton")

ToggleButton = {
    new = function(defaultState, timeToOnTicks, timeToOffTicks)
        return {
            isOn = defaultState,
            timeToOnTicks = timeToOnTicks,
            timeToOffTicks = timeToOffTicks,
            button = PushButton.new(),
            update = function(self, isPushing)
                self.button:update(isPushing)
                if not self.isOn and self.button.pushedTime == self.timeToOnTicks then
                    self.isOn = true
                elseif self.isOn and self.button.pushedTime == self.timeToOffTicks then
                    self.isOn = false
                end
                return self.isOn
            end
        }
    end
}
