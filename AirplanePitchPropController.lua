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
RPS_CHANNEL = 22
AP_TARGET_CHANNEL = 23

MODE_NOT_SELECTED = 0
MODE_DIRECT = 1
MODE_STABILIZE = 2
MODE_HOLD = 3
MODE_AUTOPILOT = 4
MODE_LANDING = 5
MODE_LOCK = -1

maxPitchSpeedTurnsPerSec = property.getNumber("Pitch Speed [turns/s]")
stabilizeIGainAt40RPS = property.getNumber("Stabilize I Gain at 40 RPS")
stabilizeLookaheadTicks = property.getNumber("Stabilize Lookahead [ticks]")
speedElevatorPID = SpeedPid.new(0, 0, -1, 1)

maxFPAAngleRate = math.tan(property.getNumber("Hold Flight Path Angle [deg]") * math.pi / 180)
holdPGain = property.getNumber("Hold P Gain")
holdLookaheadTicks = property.getNumber("Hold Lookahead [ticks]")
fpaSpeedPID = NormalPid.new(holdPGain, holdLookaheadTicks, -maxPitchSpeedTurnsPerSec, maxPitchSpeedTurnsPerSec)

autopilotPGain = property.getNumber("Autopilot P Gain")
autopilotLookaheadTicks = property.getNumber("Autopilot Lookahead [ticks]")
altFPAPID = NormalPid.new(autopilotPGain, autopilotLookaheadTicks, -maxFPAAngleRate, maxFPAAngleRate)

gsFPAPID = {}

pitchRad = Delta.new()
gpsX = Delta.new()
gpsY = Delta.new()
alt = Delta.new()

function fpaRate()
    return alt.delta / len(gpsX.delta, gpsY.delta)
end

function onTick()
    pitchRad:update(Sensor:getPitchRad2())
    alt:update(Sensor:getAltitudeMeter())
    pitchSpeedTurnsPerSec = deltaToPerTicks(pitchRad.delta, -math.pi, math.pi) / _TURNS_TO_RAD / _TICKS_TO_SEC
    gpsX:update(Sensor:getGpsX())
    gpsY:update(Sensor:getGpsY())
    mode = input.getNumber(MODE_CHANNEL)
    seatPitchInput = input.getNumber(SEAT_CHANNEL)
    propRPS = math.max(input.getNumber(RPS_CHANNEL), 6.666)
    if mode == MODE_NOT_SELECTED or mode == MODE_LOCK then
        -- 出力値を維持
    else
        if mode == MODE_DIRECT then
            speedElevatorPID.output = seatPitchInput
        else
            if mode == MODE_STABILIZE then
                targetPitchSpeedTurnsPerSec = maxPitchSpeedTurnsPerSec * seatPitchInput
            else
                if mode == MODE_HOLD then
                    targetFPARate = -maxFPAAngleRate * seatPitchInput -- マイナス入力で上昇
                else
                    if mode == MODE_AUTOPILOT then
                        targetAltitule = input.getNumber(AP_TARGET_CHANNEL)
                        targetFPARate = altFPAPID:process(targetAltitule, alt.lastValue)
                    elseif mode == MODE_LANDING then
                        targetFPARate = 0
                    end
                end
                targetPitchSpeedTurnsPerSec = -fpaSpeedPID:process(targetFPARate, fpaRate()) -- ピッチアップは負回転
            end
            speedElevatorPID.iGain = stabilizeIGainAt40RPS * 40 / propRPS
            speedElevatorPID.lookaheadTicks = stabilizeLookaheadTicks
            speedElevatorPID:process(targetPitchSpeedTurnsPerSec, pitchSpeedTurnsPerSec)
        end
    end
    output.setNumber(2, speedElevatorPID.output)
end
