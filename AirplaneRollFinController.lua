-- Author: OER1057
-- GitHub: https://github.com/OER1057
-- Workshop: https://steamcommunity.com/profiles/76561199119398472/myworkshopfiles/?appid=573090
--
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey

--[====[ IN-GAME CODE ]====]
require("Constants.Units")
require("Map.CoordinateToHeading")
require("Math.Delta")
require("Math.Move")
require("PID.SpeedPID")
require("PID.NormalPID")
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

maxRollSpeed = property.getNumber("Roll Speed [turns/s]") -- turns/s(右)
stabilizeIGainAt400Kph = property.getNumber("Stabilize I Gain at 400 km/h")
stabilizeLookahead = property.getNumber("Stabilize Lookahead [ticks]")
speedAileronPID = SpeedPID.new(0, stabilizeLookahead, -1, 1)

maxRoll = property.getNumber("Hold Roll Angle [deg]") * _DEG_TO_RAD -- rad(右)
holdPGain = property.getNumber("Hold P Gain")
holdLookahead = property.getNumber("Hold Lookahead [ticks]")
rollSpeedPID = NormalPID.new(holdPGain, holdLookahead, -maxRollSpeed, maxRollSpeed)

autopilotPGain = property.getNumber("Autopilot P Gain")
autopilotLookahead = property.getNumber("Autopilot Lookahead [ticks]")
fpdRollPID = NormalPID.new(autopilotPGain, autopilotLookahead, -maxRoll, maxRoll)

locFpdPID = {}

gpsNorth = Delta.new()
gpsEast = Delta.new()

function onTick()
    mode = input.getNumber(MODE_CHANNEL)
    seatRollInput = input.getNumber(SEAT_CHANNEL)              -- +-1(右)
    airSpeed = math.max(Sensor:getAirSpeedMps(), 30)           -- m/s

    rollSpeed = Sensor:getRollSpeedRadPerSec() / _TURNS_TO_RAD -- turns/s(右)
    roll = Sensor:getRollRad()                                 -- rad(右)

    gpsNorth:update(Sensor:getGpsNorth())
    gpsEast:update(Sensor:getGpsEast())
    fpd = coordinateToHeading(gpsNorth.delta, gpsEast.delta) -- deg(北→東)

    if mode == MODE_NOT_SELECTED or mode == MODE_LOCK then
    else
        if mode == MODE_DIRECT then
            speedAileronPID.output = seatRollInput
        else
            if mode == MODE_STABILIZE then
                targetRollSpeed = maxRollSpeed * seatRollInput -- turns/s(右)
            else
                if mode == MODE_HOLD then
                    targetRoll = maxRoll * seatRollInput -- rad(右)
                else
                    if mode == MODE_AUTOPILOT then
                        targetFPD = input.getNumber(AP_TARGET_CHANNEL) -- deg(北→東)
                    elseif mode == MODE_LANDING then
                        targetFPD = 0
                    end
                    targetRoll = fpdRollPID:process(0, move(fpd, targetFPD, 0, 360))
                end
                targetRollSpeed = rollSpeedPID:process(targetRoll, roll)
            end
            speedAileronPID.iGain = stabilizeIGainAt400Kph * 400 / (airSpeed * _MPS_TO_KPH)
            speedAileronPID:process(targetRollSpeed, rollSpeed)
        end
    end
    output.setNumber(1, speedAileronPID.output)
    output.setNumber(2, -speedAileronPID.output)
end
