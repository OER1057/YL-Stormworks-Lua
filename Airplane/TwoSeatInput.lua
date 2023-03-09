-- Author: OER1057
-- GitHub: https://github.com/OER1057/YL-Stormworks-Lua
-- Workshop: https://steamcommunity.com/profiles/76561199119398472/myworkshopfiles/?appid=573090
--
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey

--[====[ IN-GAME CODE ]====]
-- input channels
-- 01-10, 31, 32: seat 1
-- 17-26, 15, 16: seat 2

secondSeatOffset = 16

function onTick()
    -- number 1-10
    for i = 1, 10 do
        local firstInput = input.getNumber(i)
        local secondInput = input.getNumber(secondSeatOffset + i)
        output.setNumber(i, firstInput + secondInput)
    end
    -- bool 1-6
    for i = 1, 6 do
        local firstInput = input.getBool(i)
        local secondInput = input.getBool(secondSeatOffset + i)
        output.setBool(i, firstInput or secondInput)
    end
    -- bool 31-32
    for i = 31, 32 do
        local firstInput = input.getBool(i)
        local secondInput = input.getBool( -secondSeatOffset + i)
        output.setBool(i, firstInput or secondInput)
    end
end
