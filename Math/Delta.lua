Delta = {
    ---Deltaの新しいインスタンスを返します
    ---@return Delta
    new = function()
        ---@class Delta
        ---@field lastValue number 現在値
        ---@field delta number 前回値との差分
        return {
            lastValue = 0,
            delta = 0,
            ---現在値を更新し、前回値との差分を返します
            ---@param self Delta
            ---@param newValue number 現在値
            ---@return number 前回値との差分
            update = function(self, newValue)
                self.delta = newValue - self.lastValue
                self.lastValue = newValue
                return self.delta
            end
        }
    end
}
