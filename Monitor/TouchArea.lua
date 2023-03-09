TouchArea = {
    areaList = {},
    whichArea = nil,
    addArea = function(self, name, x, y, xSize, ySize)
        self.areaList[name] = { xStart = x, yStart = y, xEnd = x + xSize, yEnd = y + ySize }
    end,
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
