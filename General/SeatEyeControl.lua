-- Author: OER1057
-- GitHub: https://github.com/OER1057/YL-Stormworks-Lua
-- Workshop: https://steamcommunity.com/profiles/76561199119398472/myworkshopfiles/?appid=573090
--
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey
--[====[ IN-GAME CODE ]====]
require("General.PushButton")

eyeControlChannel = property.getNumber("Hotkey")
eyeControlAxisX = property.getNumber("Axis X")
eyeControlAxisY = property.getNumber("Axis Y")
eyeControlRatioX = property.getNumber("Ratio X")
eyeControlRatioY = property.getNumber("Ratio Y")
eyeControlInvertY = property.getNumber("Y Positive Direction")

function passThrough()
    for i = 1, 32 do
        output.setNumber(i, input.getNumber(i))
        output.setBool(i, input.getBool(i))
    end
end

eyeControlSwitch = PushButton.new()

function onTick()
    passThrough()
    eyeControlSwitch:update(input.getBool(eyeControlChannel))
    if eyeControlSwitch.isPushed then
        lookX = input.getNumber(9)  -- turns(右)
        lookY = input.getNumber(10) -- turns(上)
        if eyeControlInvertY then
            lookY = -lookY          -- turns(下)
        end
        if eyeControlSwitch.isPushedNow then
            lookXBase = lookX
            lookYBase = lookY
        end
        output.setNumber(eyeControlAxisX, input.getNumber(eyeControlAxisX) + eyeControlRatioX * (lookX - lookXBase))
        output.setNumber(eyeControlAxisY, input.getNumber(eyeControlAxisY) + eyeControlRatioY * (lookY - lookYBase))
    end
end
