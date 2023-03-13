Buffer = {
    ---循環バッファの新しいインスタンスを返します
    ---@param length number バッファの大きさ
    ---@param initValue number? バッファの初期値。指定しない場合0
    ---@return Buffer
    new = function(length, initValue)
        local newBuffer = {}
        for i = 1, length do
            newBuffer[i] = initValue or 0
        end
        ---@class Buffer
        ---@field length integer バッファの大きさ
        ---@field lastIndex integer 最新の値の位置(0-indexed)
        return {
            length = length,
            buffer = newBuffer,
            lastIndex = 0,
            ---`back`番前の値を返します
            ---@param self Buffer
            ---@param back integer? 指定しない場合0(現在の値)、-nでn番目に古い値
            ---@return number 前回値との差分
            get = function(self, back)
                return self.buffer[(self.lastIndex - (back or 1)) % self.length + 1]
            end,
            ---現在値を更新し、前回値との差分を返します
            ---@param self Buffer
            ---@param newValue number 現在値
            ---@return number 前回値との差分
            set = function(self, newValue)
                self.lastIndex = (self.lastIndex + 1) % self.length
                self.buffer[self.lastIndex + 1] = newValue
                return self:get() - self:get(1)
            end
        }
    end
}
