-- Author: OER1057
-- GitHub: https://github.com/OER1057/YL-Stormworks-Lua
-- Workshop: https://steamcommunity.com/profiles/76561199119398472/myworkshopfiles/?appid=573090
--
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey

--[====[ IN-GAME CODE ]====]
require("Math.Delta")
require("Math.Delta.Buffer")

CHANNEL_ROLL_MODE = 1
CHANNEL_PITCH_MODE = 2
CHANNEL_YAW_MODE = 3

MODE_NOT_SELECTED = 0
MODE_DIRECT = 1
MODE_STABILIZE = 2
MODE_HOLD = 3
MODE_TURN_COORDINATE = 3
MODE_AUTOPILOT = 4
MODE_LANDING = 5
MODE_LOCK = -1

local _WARN_LENGTH = 90 -- ticks

rollMode = Buffer.new(_WARN_LENGTH, MODE_NOT_SELECTED)
pitchMode = Buffer.new(_WARN_LENGTH, MODE_NOT_SELECTED)
yawMode = Buffer.new(_WARN_LENGTH, MODE_NOT_SELECTED)

function onTick()
    rollMode:set(input.getNumber(CHANNEL_ROLL_MODE))
    pitchMode:set(input.getNumber(CHANNEL_PITCH_MODE))
    yawMode:set(input.getNumber(CHANNEL_YAW_MODE))
    if (rollMode:get() <= MODE_HOLD and rollMode:get(-1) >= MODE_AUTOPILOT)
        or (pitchMode:get() <= MODE_HOLD and pitchMode:get(-1) >= MODE_AUTOPILOT)
        or (yawMode:get() <= MODE_STABILIZE and yawMode:get(-1) >= MODE_TURN_COORDINATE) then
        warning = true;
    else
        warning = false;
    end
    output.setBool(1, warning)
end
