-- Author: OER1057
-- GitHub: https://github.com/OER1057/YL-Stormworks-Lua
-- Workshop: https://steamcommunity.com/profiles/76561199119398472/myworkshopfiles/?appid=573090
--
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey

--[====[ IN-GAME CODE ]====]
require("Sensors")

function onTick()
    output.setNumber(1, Sensor:getHeadingDeg() / _TURNS_TO_DEG)
    output.setNumber(2, Sensor:getPitchRad() / _TURNS_TO_RAD)
    output.setNumber(3, Sensor:getRollRad() / _TURNS_TO_RAD)
end
