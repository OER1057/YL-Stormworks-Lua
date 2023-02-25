-- Author: OER1057
-- GitHub: https://github.com/OER1057
-- Workshop: https://steamcommunity.com/profiles/76561199119398472/myworkshopfiles/?appid=573090
--
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey

--[====[ IN-GAME CODE ]====]
require("PID")
require("Sensors")

MODE_CHANNEL = 20
SEAT_CHANNEL = 21
AP_TARGET_CHANNEL = 23

MODE_NOT_SELECTED = 0
MODE_DIRECT = 1
MODE_STABILIZE = 2
MODE_HOLD = 3
MODE_AUTOPILOT = 4
MODE_LANDING = 5
MODE_LOCK = -1

maxRollSpeedTurnsPerSec = property.getNumber("Roll Speed [turns/s]")
stabilizeIGainAt400Kmph = property.getNumber("Stabilize I Gain at 400 km/h")
stabilizeLookaheadTicks = property.getNumber("Stabilize Lookahead [ticks]")
speedAileronPID = SpeedPid.new(0, stabilizeLookaheadTicks, -1, 1)

maxRollRad = property.getNumber("Hold Roll Angle [deg]") * _DEG_TO_RAD
holdPGain = property.getNumber("Hold P Gain")
holdLookaheadTicks = property.getNumber("Hold Lookahead [ticks]")
rollSpeedPID = NormalPid.new(holdPGain, holdLookaheadTicks, -maxRollSpeedTurnsPerSec, maxRollSpeedTurnsPerSec)

autopilotPGain = property.getNumber("Autopilot P Gain")
autopilotLookaheadTicks = property.getNumber("Autopilot Lookahead [ticks]")
fpdRollPID = NormalPid.new(autopilotPGain, autopilotLookaheadTicks, -maxRollRad, maxRollRad)

locFpdPID = {}

gpsNorth = Delta.new()
gpsEast = Delta.new()

function onTick()
    mode = input.getNumber(MODE_CHANNEL)
    seatRollInput = input.getNumber(SEAT_CHANNEL)
    airSpeedMps = math.max(Sensor:getAirSpeedMps(), 30)

    rollSpeedTurnsPerSec = Sensor:getRollSpeedRadPerSec() / _TURNS_TO_RAD
    rollRad = Sensor:getRollRad()

    gpsNorth:update(Sensor:getGpsNorth())
    gpsEast:update(Sensor:getGpsEast())
    fpdDeg = coordinateToHeadingDegree(gpsNorth.delta, gpsEast.delta)

    if mode == MODE_NOT_SELECTED or mode == MODE_LOCK then
    else
        if mode == MODE_DIRECT then
            speedAileronPID.output = seatRollInput
        else
            if mode == MODE_STABILIZE then
                targetRollSpeedTurnsPerSec = maxRollSpeedTurnsPerSec * seatRollInput
            else
                if mode == MODE_HOLD then
                    targetRollRad = maxRollRad * seatRollInput
                else
                    if mode == MODE_AUTOPILOT then
                        targetFpdDeg = input.getNumber(AP_TARGET_CHANNEL)
                    elseif mode == MODE_LANDING then
                        targetFpdDeg = 0
                        -- targetFpdDeg = locFpdPID:process()
                    end
                    targetRollRad = fpdRollPID:process(0, -deltaToPerTicks(targetFpdDeg - fpdDeg, 0, 360)) -- なぜ負？
                end
                targetRollSpeedTurnsPerSec = rollSpeedPID:process(targetRollRad, rollRad)
            end
            speedAileronPID.iGain = stabilizeIGainAt400Kmph * 400 / (airSpeedMps * _MPS_TO_KPH)
            speedAileronPID:process(targetRollSpeedTurnsPerSec, rollSpeedTurnsPerSec)
        end
    end
    output.setNumber(1, speedAileronPID.output)
    output.setNumber(2, -speedAileronPID.output)
end
