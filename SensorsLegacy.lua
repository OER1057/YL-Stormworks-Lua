-- Author: OER1057
-- GitHub: https://github.com/OER1057/YL-Stormworks-Lua
-- Workshop: https://steamcommunity.com/profiles/76561199119398472/myworkshopfiles/?appid=573090
--
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey

--[====[ IN-GAME CODE ]====]
-- 単位換算
_TURNS_TO_RAD = 2 * math.pi
_TURNS_TO_DEG = 360
_MPS_TO_KPH = 60 * 60 / 1000

Sensor = {
    getAirSpeedMps = function()
        return input.getNumber(1) / _MPS_TO_KPH
    end,
    getAltitudeMeter = function()
        return input.getNumber(3)
    end,
    getRadarAltitudeMeter = function()
        return input.getNumber(4)
    end,
    getRollRad = function()
        return input.getNumber(5) * _TURNS_TO_RAD
    end,
    getPitchRad = function()
        return input.getNumber(6) * _TURNS_TO_RAD
    end,
    getRollSpeedTurnsPerSec = function()
        return input.getNumber(7)
    end,
    getPitchSpeedTurnsPerSec = function()
        return input.getNumber(8)
    end,
    getYawSpeedTurnsPerSec = function()
        return input.getNumber(9)
    end,
    getGpsX = function()
        return input.getNumber(10)
    end,
    getGpsY = function()
        return input.getNumber(11)
    end,
    getFrontDistance = function()
        return input.getNumber(14)
    end,
    getHeadingTurns = function()
        return input.getNumber(12)
    end,
    getHeadingDeg = function()
        return (input.getNumber(12) * _TURNS_TO_DEG + 360) % 360
    end
}
