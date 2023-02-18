-- Author: OER1057
-- GitHub: https://github.com/OER1057/YL-Stormworks-Lua
-- Workshop: https://steamcommunity.com/profiles/76561199119398472/myworkshopfiles/?appid=573090
--
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey

--[====[ IN-GAME CODE ]====]
-- チャンネル
_ALT_OFFSET_CHANNEL = 32
_BOTTOM_DISTANCE_SENSOR_CHANNEL = 30
_FRONT_DISTANCE_SENSOR_CHANNEL = 29
_FRONT_DISTANCE_OFFSET_CHANNEL = 31
_WIND_SENSOR_SPEED_CHANNEL = 28
_WIND_SENSOR_DIRECTION_CHANNEL = 27
-- 単位換算
_TURNS_TO_RAD = 2 * math.pi
_TURNS_TO_DEG = 360
_MPS_TO_KPS = 60 * 60 / 1000

Sensor = {
    -- センサ生値
    ---- Physics Sensor
    getXPositionMeter = function()
        return input.getNumber(1)
    end,
    getYPositionMeter = function()
        return input.getNumber(2) - input.getNumber(_ALT_OFFSET_CHANNEL)
    end,
    getZPositionMeter = function()
        return input.getNumber(3)
    end,
    getXEulerRotationRad = function()
        return input.getNumber(4)
    end,
    getYEulerRotationRad = function()
        return input.getNumber(5)
    end,
    getZEulerRotationRad = function()
        return input.getNumber(6)
    end,
    getXVelocityMps = function()
        return input.getNumber(7)
    end,
    getYVelocityMps = function()
        return input.getNumber(8)
    end,
    getZVelocityMps = function()
        return input.getNumber(9)
    end,
    getXAngularVelocityTurnsPerSec = function()
        return input.getNumber(10)
    end,
    getYAngularVelocityTurnsPerSec = function()
        return input.getNumber(11)
    end,
    getZAngularVelocityTurnsPerSec = function()
        return input.getNumber(12)
    end,
    getAbsoluteVelocityMps = function()
        return input.getNumber(13)
    end,
    getAbsoluteAngularVelocityTurnsPerSec = function()
        return input.getNumber(14)
    end,
    ---- Distance Sensor
    getRadarAltitudeMeter = function()
        return input.getNumber(_BOTTOM_DISTANCE_SENSOR_CHANNEL) - input.getNumber(_ALT_OFFSET_CHANNEL)
    end,
    getFrontDistance = function()
        return input.getNumber(_FRONT_DISTANCE_SENSOR_CHANNEL) - input.getNumber(_FRONT_DISTANCE_OFFSET_CHANNEL)
    end,
    ---- Wind Sensor
    getAirSpeedMps = function()
        return input.getNumber(_WIND_SENSOR_SPEED_CHANNEL) * math.cos(Sensor.getAoaTurns * _TURNS_TO_RAD)
    end,
    getAoaTurns = function()
        return input.getNumber(_WIND_SENSOR_DIRECTION_CHANNEL)
    end,
    -- 別表現
    getGpsX = Sensor.getXPositionMeter(),
    getGpsY = Sensor.getZPositionMeter(),
    getAltitudeMeter = Sensor.getYPositionMeter(),
    getRollSpeedTurnsPerSec = -Sensor.getXAngularVelocityTurnsPerSec(),
    getPitchSpeedTurnsPerSec = -Sensor.getZAngularVelocityTurnsPerSec(),
    getYawSpeedTurnsPerSec = Sensor.getYAngularVelocityTurnsPerSec(),
    -- 計算値
    getRollRad = function()
        return input.getNumber(0)
    end,
    getPitchRad = function()
        return input.getNumber(0)
    end,
    getHeadingDeg = function()
        return input.getNumber(0)
    end,
}
