-- Author: OER1057
-- GitHub: https://github.com/OER1057/YL-Stormworks-Lua
-- Workshop: https://steamcommunity.com/profiles/76561199119398472/myworkshopfiles/?appid=573090
--
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey

--[====[ IN-GAME CODE ]====]
-- input channels
TOUCHDOWN_NORTH_CHANNEL = 20
TOUCHDOWN_EAST_CHANNEL = 21
-- input/output channels
RUNWAY_HEADING_CHANNEL = 22
-- output channels
CHANNEL_VERTICAL_GAP = 1
CHANNEL_HORIZONTAL_GAP = 2
CHANNEL_HORIZONTAL_DIRECTION = 3
CHANNEL_DISTANCE = 4

require("Constants.Units")
require("Airplane.HSI")
require("Airplane.ILS")
require("Sensors")

ILS.glideSlopeAngle = property.getNumber("Glide Slope Angle [deg]") * _DEG_TO_RAD
altitudeOffset = property.getNumber("Altitude Offset [m]")

function outputPassThroughNumber(channel)
    output.setNumber(channel, input.getNumber(channel))
end

function onTick()
    HSI.targetNorth = input.getNumber(TOUCHDOWN_NORTH_CHANNEL)
    HSI.targetEast = input.getNumber(TOUCHDOWN_EAST_CHANNEL)
    HSI.courceHeading = input.getNumber(RUNWAY_HEADING_CHANNEL)
    gpsNorth = Sensor:getGpsNorth()      -- meter
    gpsEast = Sensor:getGpsEast()        -- meter
    altitude = Sensor:getAltitudeMeter() -- meter
    heading = Sensor:getHeadingDeg()     -- deg
    HSI:update(gpsNorth, gpsEast, heading)
    ILS:update(HSI, altitude)
    --
    output.setNumber(CHANNEL_VERTICAL_GAP, ILS.verticalGap)
    output.setNumber(CHANNEL_HORIZONTAL_GAP, ILS.horizontalGap)
    output.setNumber(CHANNEL_HORIZONTAL_DIRECTION, HSI.direction)
    output.setNumber(CHANNEL_DISTANCE, HSI.distance)
    outputPassThroughNumber(RUNWAY_HEADING_CHANNEL)
end
