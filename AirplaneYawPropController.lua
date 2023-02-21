-- Author: OER1057
-- GitHub: https://github.com/OER1057
-- Workshop: https://steamcommunity.com/profiles/76561199119398472/myworkshopfiles/?appid=573090
--
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey

--[====[ IN-GAME CODE ]====]
require("Math")
require("PID")
require("Sensors")

MODE_CHANNEL = 20
SEAT_CHANNEL = 21
RPS_CHANNEL = 22

MODE_NOT_SELECTED = 0
MODE_DIRECT = 1
MODE_STABILIZE = 2
MODE_TURN_COORDINATE = 3

maxYawSpeedTurnsPerSec = property.getNumber("Yaw Speed [turns/s]")
stabilizeIGainAt40RPS = property.getNumber("Stabilize I Gain at 40 RPS")
stabilizeLookaheadTicks = property.getNumber("Stabilize Lookahead [ticks]")
speedRudderPID = SpeedPid.new(0, stabilizeLookaheadTicks, -1, 1)

gravityMpsPerSec = property.getNumber("Gravity [m/s/s]")

gpsNorth = Delta.new()
gpsEast = Delta.new()

function onTick()
    mode = input.getNumber(MODE_CHANNEL)
    seatYawInput = input.getNumber(SEAT_CHANNEL)
    propRPS = math.max(input.getNumber(RPS_CHANNEL), 6.666)

    yawSpeedTurnsPerSec = Sensor:getYawSpeedRadPerSec() / _TURNS_TO_RAD

    rollRad = Sensor:getRollRad()
    gpsNorth:update(Sensor:getGpsNorth())
    gpsEast:update(Sensor:getGpsEast())
    groundSpeedMps = len(gpsNorth.delta, gpsEast.delta) / _TICKS_TO_SEC

    if mode == MODE_NOT_SELECTED or mode == MODE_LOCK then
    else
        if mode == MODE_DIRECT then
            speedRudderPID.output = seatYawInput
        else
            if mode == MODE_STABILIZE then
                targetYawSpeedTurnsPerSec = maxYawSpeedTurnsPerSec * seatYawInput
            elseif mode == MODE_TURN_COORDINATE then
                targetYawSpeedTurnsPerSec = (gravityMpsPerSec * math.sin(rollRad)) / groundSpeedMps / _TURNS_TO_RAD
            end
            speedRudderPID.iGain = stabilizeIGainAt40RPS * 40 / propRPS
            speedRudderPID:process(targetYawSpeedTurnsPerSec, yawSpeedTurnsPerSec)
        end
    end
    output.setNumber(1, speedRudderPID.output)
end
