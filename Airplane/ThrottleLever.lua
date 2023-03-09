-- Author: OER1057
-- GitHub: https://github.com/OER1057/YL-Stormworks-Lua
-- Workshop: https://steamcommunity.com/profiles/76561199119398472/myworkshopfiles/?appid=573090
--
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey

--[====[ IN-GAME CODE ]====]
require("Math.Clamp")
require("General.SeatInputSmoother")

maxThrottle = property.getNumber("Max Throttle")
minThrottle = property.getNumber("Min Throttle")
leverPerTicks = property.getNumber("Lever Sensibility [/ticks]")
leverDelayTicks = property.getNumber("Lever Delay [ticks]")
seatPerTicks = property.getNumber("Seat Sensibility [/ticks]")
seatDelayTicks = property.getNumber("Seat Delay [ticks]")

smoothedLeverInput = InputSmoother.new(leverPerTicks, leverDelayTicks, 1)
smoothedSeatInput = InputSmoother.new(seatPerTicks, seatDelayTicks, 1)
throttleOutput = minThrottle

function onTick()
    isLeverUpPushed = input.getBool(1)
    isLeverDownPushed = input.getBool(2)
    seatThrottleInput = input.getNumber(4)

    if isLeverUpPushed then
        smoothedLeverInput:update(1)
    elseif isLeverDownPushed then
        smoothedLeverInput:update(-1)
    else
        smoothedLeverInput:update(0)
    end

    smoothedSeatInput:update(seatThrottleInput)

    throttleOutput = clamp(throttleOutput + smoothedLeverInput.output + smoothedSeatInput.output, minThrottle,
        maxThrottle)

    output.setNumber(1, throttleOutput)
end
