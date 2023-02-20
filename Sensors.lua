-- Author: OER1057
-- GitHub: https://github.com/OER1057/YL-Stormworks-Lua
-- Workshop: https://steamcommunity.com/profiles/76561199119398472/myworkshopfiles/?appid=573090
--
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey

--[====[ IN-GAME CODE ]====]
require("Math")
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
_RAD_TO_DEG = 180 / math.pi
_MPS_TO_KPS = 60 * 60 / 1000
_TICKS_TO_SEC = 1 / 62

function coordinateToHeadingDegree(north, east)
    return (math.atan(east, north) * _RAD_TO_DEG + 360) % 360
end

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
        return input.getNumber(_WIND_SENSOR_SPEED_CHANNEL) * math.cos(Sensor:getAoaTurns() * _TURNS_TO_RAD)
    end,
    getAoaTurns = function()
        return input.getNumber(_WIND_SENSOR_DIRECTION_CHANNEL)
    end,
    -- 別表現
    getGpsX = function(self)
        return self.getXPositionMeter()
    end,
    getGpsY = function(self)
        return self.getZPositionMeter()
    end,
    getGpsNorth = function(self)
        return self.getZPositionMeter()
    end,
    getGpsEast = function(self)
        return self.getXPositionMeter()
    end,
    getAltitudeMeter = function(self)
        return self.getYPositionMeter()
    end,
    getRollRad = function(self)
        -- ローカルx軸のXZ平面に対する角度(右向き正)
        X = self:getXEulerRotationRad()
        Y = self:getYEulerRotationRad()
        Z = self:getZEulerRotationRad()
        if math.sin(X) * math.sin(Y) * math.sin(Z) + math.cos(X) * math.cos(Z) > 0 then -- 裏返しになっていない
            sign = 1
        else -- 裏返しになっている
            sign = -1
        end
        xTilt = math.atan(
            -math.cos(Y) * math.sin(Z), -- xのY成分
            sign * len( -- xのXZ平面への射影の絶対値
                math.cos(Y) * math.cos(Z), -- xのX成分
                -math.sin(Y))) -- xのZ成分
        if sign > 0 then
            return math.asin(math.sin(xTilt) / math.cos(self:getPitchRad())) -- 呪文
        else
            return math.pi - math.asin(math.sin(xTilt) / math.cos(self:getPitchRad()))
        end
    end,
    getPitchRad = function(self)
        -- ローカルz軸のXZ平面に対する角度(下向き正)
        X = self:getXEulerRotationRad()
        Y = self:getYEulerRotationRad()
        Z = self:getZEulerRotationRad()
        return math.atan(
            -math.cos(X) * math.sin(Y) * math.sin(Z) + math.sin(X) * math.cos(Z), -- zのY成分
            len( -- zのXZ平面への射影の絶対値
                math.cos(X) * math.sin(Y) * math.cos(Z) + math.sin(X) * math.sin(Z), -- zのX成分
                math.cos(X) * math.cos(Y))) -- zのZ成分
    end,
    getHeadingDeg = function(self)
        -- ローカルz軸のXZ平面への射影の方位
        X = self:getXEulerRotationRad()
        Y = self:getYEulerRotationRad()
        Z = self:getZEulerRotationRad()
        return
            coordinateToHeadingDegree(
                math.cos(X) * math.cos(Y), -- zのZ成分
                math.cos(X) * math.sin(Y) * math.cos(Z) + math.sin(X) * math.sin(Z)) -- zのX成分
    end,
    -- 要微分
}
