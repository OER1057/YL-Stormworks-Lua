require("General.PushButton")

ToggleButton = {
    ---ToggleButtonの新しいインスタンスを返します
    ---@return ToggleButton
    new = function(defaultState, timeToOnTicks, timeToOffTicks)
        ---@class ToggleButton
        ---@field isOn boolean オンか否か
        ---@field timeToOnTicks integer オンにするために押し続ける時間/ticks
        ---@field timeToOffTicks integer オフにするために押し続ける時間/ticks
        return {
            isOn = defaultState,
            timeToOnTicks = timeToOnTicks,
            timeToOffTicks = timeToOffTicks,
            button = PushButton.new(),
            ---状態を更新します
            ---@param self ToggleButton
            ---@param isPushing boolean 押しているか否か
            ---@return boolean
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
