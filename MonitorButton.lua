-- Author: OER1057
-- GitHub: https://github.com/OER1057/YL-Stormworks-Lua
-- Workshop: https://steamcommunity.com/profiles/76561199119398472/myworkshopfiles/?appid=573090
--
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey

--[====[ IN-GAME CODE ]====]
require("Math.Between")

PushButton = {
    new = function()
        return {
            pushedTime = 0,
            isPushedNow = false,
            isPushed = false,
            update = function(self, isPushing)
                if isPushing then
                    self.isPushed = true
                    self.pushedTime = self.pushedTime + 1
                else
                    self.isPushed = false
                    self.pushedTime = 0
                end
                self.isPushedNow = self.pushedTime == 1
            end
        }
    end
}

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
