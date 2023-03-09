-- Author: OER1057
-- GitHub: https://github.com/OER1057
-- Workshop: https://steamcommunity.com/profiles/76561199119398472/myworkshopfiles/?appid=573090
--
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey

--[====[ IN-GAME CODE ]====]
require("PID.SpeedPID")
require("PID.NormalPID")
require("Sensors")

MODE_CHANNEL = 20
SEAT_CHANNEL = 21
RPS_CHANNEL = 22
AP_TARGET_CHANNEL = 23

MODE_NOT_SELECTED = 0
MODE_DIRECT = 1
MODE_STABILIZE = 2
MODE_HOLD = 3
MODE_AUTOPILOT = 4
MODE_LANDING = 5
MODE_LOCK = -1

maxPitchSpeed = property.getNumber("Pitch Speed [turns/s]")            -- turns/s(機首下げ)
stabilizeIGainAt40RPS = property.getNumber("Stabilize I Gain at 40 RPS")
stabilizeLookahead = property.getNumber("Stabilize Lookahead [ticks]") -- ticks
speedElevatorPID = SpeedPID.new(0, stabilizeLookahead, -1, 1)

maxFPA = math.tan(property.getNumber("Hold Flight Path Angle [deg]") * math.pi / 180) -- m/m(上昇)
holdPGain = property.getNumber("Hold P Gain")
holdLookahead = property.getNumber("Hold Lookahead [ticks]")                          -- ticks
fpaSpeedPID = NormalPID.new(holdPGain, holdLookahead, -maxPitchSpeed, maxPitchSpeed)

autopilotPGain = property.getNumber("Autopilot P Gain")
autopilotLookahead = property.getNumber("Autopilot Lookahead [ticks]") -- ticks
altFPAPID = NormalPID.new(autopilotPGain, autopilotLookahead, -maxFPA, maxFPA)

gsFPAPID = {}

pitchRad = Delta.new()
gpsEast = Delta.new()
gpsNorth = Delta.new()
alt = Delta.new()

function fpaRate() -- m/m(上昇)
    return alt.delta / len(gpsEast.delta, gpsNorth.delta)
end

function onTick()
    mode = input.getNumber(MODE_CHANNEL)                         -- MODE_
    seatPitchInput = input.getNumber(SEAT_CHANNEL)               -- +-1(機首下げ)
    propRPS = math.max(input.getNumber(RPS_CHANNEL), 6.666)      -- RPS

    pitchSpeed = Sensor:getPitchSpeedRadPerSec() / _TURNS_TO_RAD -- turns/s(機首下げ)

    alt:update(Sensor:getAltitudeMeter())                        -- m(上)
    gpsEast:update(Sensor:getGpsEast())                          -- m
    gpsNorth:update(Sensor:getGpsNorth())                        -- m

    if mode == MODE_NOT_SELECTED or mode == MODE_LOCK then
    else
        if mode == MODE_DIRECT then
            speedElevatorPID.output = seatPitchInput
        else
            if mode == MODE_STABILIZE then
                targetPitchSpeed = maxPitchSpeed * seatPitchInput -- turns/s(機首下げ)
            else
                if mode == MODE_HOLD then
                    targetFPA = maxFPA * (-seatPitchInput) -- m/m(上昇)
                else
                    if mode == MODE_AUTOPILOT then
                        targetAltitule = input.getNumber(AP_TARGET_CHANNEL)          -- m(上)
                        targetFPA = altFPAPID:process(targetAltitule, alt.lastValue) -- m/m(上昇)
                    elseif mode == MODE_LANDING then
                        targetFPA = 0
                    end
                end
                targetPitchSpeed = -fpaSpeedPID:process(targetFPA, fpaRate())
            end
            speedElevatorPID.iGain = stabilizeIGainAt40RPS * 40 / propRPS
            speedElevatorPID:process(targetPitchSpeed, pitchSpeed)
        end
    end
    output.setNumber(1, speedElevatorPID.output)
end
