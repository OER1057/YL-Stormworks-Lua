---@class TouchArea
---@field areaList Area{}
---@field whichArea string 点が含まれている領域の名前
TouchArea = {
    areaList = {},
    whichArea = "",
    ---領域を追加します
    ---@param self TouchArea
    ---@param name string 名前
    ---@param x number 始点のX座標
    ---@param y number 始点のY座標
    ---@param xSize number X方向の大きさ
    ---@param ySize number Y方向の大きさ
    addArea = function(self, name, x, y, xSize, ySize)
        ---@class Area
        ---@field xStart number 始点のX座標
        ---@field yStart number 始点のY座標
        ---@field xEnd number 終点のX座標
        ---@field yEnd number 終点のY座標
        self.areaList[name] = { xStart = x, yStart = y, xEnd = x + xSize, yEnd = y + ySize }
    end,
    ---判定を更新し、点が含まれている領域の名前を返します
    ---@param self TouchArea
    ---@param isTouched boolean タッチ中か否か
    ---@param x number タッチ点のX座標
    ---@param y number タッチ点のY座標
    ---@return string 領域の名前
    update = function(self, isTouched, x, y)
        self.whichArea = nil
        if isTouched then
            for name, area in pairs(self.areaList) do
                if between(x, area.xStart, area.xEnd) and between(y, area.yStart, area.yEnd) then
                    self.whichArea = name
                    break
                end
            end
        end
        return self.whichArea
    end
}
