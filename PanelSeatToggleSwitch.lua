-- Author: OER1057
-- GitHub: https://github.com/OER1057/YL-Stormworks-Lua
-- Workshop: https://steamcommunity.com/profiles/76561199119398472/myworkshopfiles/?appid=573090
--
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey

--[====[ IN-GAME CODE ]====]
require("Constants.Units")
require("MonitorButton")

-- input channels
local CHANNEL_PANEL_INPUT = 1
local CHANNEL_SEAT_INPUT = 2

-- output channels
local SWITCH_STATE_CHANNEL = 1
do
    local defauleState = property.getBool("Default State")
    local timeToOn = math.max(1, property.getNumber("Off -> On Time [s]") * _SEC_TO_TICKS)  -- ticks
    local timeToOff = math.max(1, property.getNumber("On -> Off Time [s]") * _SEC_TO_TICKS) -- ticks
    switch = ToggleButton.new(defauleState, timeToOn, timeToOff)
end


function onTick()
    switch:update(input.getBool(CHANNEL_PANEL_INPUT) or input.getBool(CHANNEL_SEAT_INPUT))
    output.setBool(SWITCH_STATE_CHANNEL, switch.isOn)
end
