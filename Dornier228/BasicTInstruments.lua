-- Author: OER1057
-- GitHub: https://github.com/OER1057/YL-Stormworks-Lua
-- Workshop: https://steamcommunity.com/profiles/76561199119398472/myworkshopfiles/?appid=573090
--
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey

--[====[ IN-GAME CODE ]====]
require("Sensors")

-- output channels
CHANNEL_SPEED = 1
CHANNEL_ALT = 2

function onTick()
    output.setNumber(CHANNEL_SPEED, Sensor:getAirSpeedMps() * _MPS_TO_KPH)
    output.setNumber(CHANNEL_ALT, Sensor:getAltitudeMeter())
end
