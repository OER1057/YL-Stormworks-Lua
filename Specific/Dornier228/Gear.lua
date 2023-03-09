-- Author: OER1057
-- GitHub: https://github.com/OER1057/YL-Stormworks-Lua
-- Workshop: https://steamcommunity.com/profiles/76561199119398472/myworkshopfiles/?appid=573090
--
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey

--[====[ EDITABLE SIMULATOR CONFIG - *automatically removed from the F7 build output ]====]
---@section __LB_SIMULATOR_ONLY__
do
    ---@type Simulator -- Set properties and screen sizes here - will run once when the script is loaded
    simulator = simulator

    -- Runs every tick just before onTick; allows you to simulate the inputs changing
    ---@param simulator Simulator Use simulator:<function>() to set inputs etc.
    ---@param ticks     number Number of ticks since simulator started
    function onLBSimulatorTick(simulator, ticks)
        -- NEW! button/slider options from the UI
        simulator:setInputBool(1, simulator:getIsToggled(1))
    end

    ;
end
---@endsection


--[====[ IN-GAME CODE ]====]
require("Constants.Units")

-- input channels
CHANNEL_GEAR_LEVER = 1
CHANNEL_TILT_L = 2
CHANNEL_TILT_R = 3

-- output channels
IS_LOCKED_CHANNEL = 1
NOSE_ROTATION_CHANNEL = 2
MAIN_L_ROTATION_CHANNEL = 3
MAIN_R_ROTATION_CHANNEL = 4
COVER_ROTATION_CHANNEL = 5

mainToCoverThreshold = 0.5
coverToMainThreshold = 0.5

noseSpeed = 1 / (3 * _SEC_TO_TICKS)    -- /ticks
mainMinSpeed = 1 / (3 * _SEC_TO_TICKS) -- /ticks
mainMaxSpeed = 1 / (6 * _SEC_TO_TICKS) -- /ticks
mainSpeed = function()                 -- /ticks
    return mainMinSpeed + math.random() * (mainMaxSpeed - mainMinSpeed)
end
coverSpeed = 1 / (3 * _SEC_TO_TICKS) -- /ticks

noseRotation = 0                     -- 0-1(下→上)
mainLRotation = 0                    -- 0-1(下→上)
mainRRotation = 0                    -- 0-1(下→上)
coverRotation = 0                    -- 0-1(下→上)


function onTick()
    isGearDown = not input.getBool(CHANNEL_GEAR_LEVER)
    if isGearDown then
        noseRotation = math.max(noseRotation - noseSpeed, 0)
        if coverRotation < coverToMainThreshold then
            mainLRotation = math.max(mainLRotation - mainSpeed(), 0)
            mainRRotation = math.max(mainRRotation - mainSpeed(), 0)
        end
        coverRotation = math.max(coverRotation - coverSpeed, 0)
    else
        noseRotation = math.min(noseRotation + noseSpeed, 1)
        mainLRotation = math.min(mainLRotation + mainSpeed(), 1)
        mainRRotation = math.min(mainRRotation + mainSpeed(), 1)
        if math.min(mainLRotation, mainRRotation) > mainToCoverThreshold then
            coverRotation = math.min(coverRotation + coverSpeed, 1)
        end
    end
    output.setNumber(NOSE_ROTATION_CHANNEL, -noseRotation)
    output.setNumber(MAIN_L_ROTATION_CHANNEL, -mainLRotation)
    output.setNumber(MAIN_R_ROTATION_CHANNEL, -mainRRotation)
    output.setNumber(COVER_ROTATION_CHANNEL, -coverRotation)
    --
    output.setBool(IS_LOCKED_CHANNEL,
        math.abs(input.getNumber(CHANNEL_TILT_L) - input.getNumber(CHANNEL_TILT_R)) < 10 / _TURNS_TO_DEG)
end
