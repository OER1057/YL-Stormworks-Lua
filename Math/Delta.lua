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

---直近の1回微分を返します
---@param buffer Buffer 循環バッファのインスタンス
---@return number 1回微分
function Delta(buffer)
    return buffer:get() - buffer:get(1)
end

---直近の2回微分を返します
---@param buffer Buffer 循環バッファのインスタンス
---@return number 2回微分
function DDelta(buffer)
    return Delta(buffer) - (buffer:get(1) - buffer:get(2))
end
