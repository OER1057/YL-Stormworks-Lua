-- Author: OER1057
-- GitHub: https://github.com/OER1057
-- Workshop: https://steamcommunity.com/profiles/76561199119398472/myworkshopfiles/?appid=573090
--
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey

--[====[ EDITABLE SIMULATOR CONFIG - *automatically removed from the F7 build output ]====]
---@section __LB_SIMULATOR_ONLY__
do
    ---@type Simulator -- Set properties and screen sizes here - will run once when the script is loaded
    simulator = simulator
    simulator:setScreen(1, "3x3")
    simulator:setProperty("Active Tab Letter Count", 3)
    simulator:setProperty("Other Tabs Letter Count", 2)
    simulator:setProperty("Tabs Count", 8)
    simulator:setProperty("Tab 1 Label", "1st")
    simulator:setProperty("Tab 2 Label", "2nd")
    simulator:setProperty("Tab 3 Label", "3rd")
    simulator:setProperty("Tab 4 Label", "4th")
    simulator:setProperty("Tab 5 Label", "5th")
    simulator:setProperty("Tab 6 Label", "6st")
    simulator:setProperty("Tab 7 Label", "7th")
    simulator:setProperty("Tab 8 Label", "8th")

    -- Runs every tick just before onTick; allows you to simulate the inputs changing
    ---@param simulator Simulator Use simulator:<function>() to set inputs etc.
    ---@param ticks     number Number of ticks since simulator started
    function onLBSimulatorTick(simulator, ticks)
        -- touchscreen defaults
        local screenConnection = simulator:getTouchScreen(1)
        simulator:setInputBool(1, screenConnection.isTouched)
        simulator:setInputNumber(1, screenConnection.width)
        simulator:setInputNumber(2, screenConnection.height)
        simulator:setInputNumber(3, screenConnection.touchX)
        simulator:setInputNumber(4, screenConnection.touchY)
    end
end
---@endsection

--[====[ IN-GAME CODE ]====]
require("Monitor.Campbell")
activeTabWidth = property.getNumber("Active Tab Letter Count") * 5
otherTabsWidth = property.getNumber("Other Tabs Letter Count") * 5

activeTab = 1
tabsCount = property.getNumber("Tabs Count")
tabLabel = {}
for tab = 1, tabsCount do
    tabLabel[tab] = property.getText("Tab " .. tab .. " Label")
end

function onTick()
    isTouched = input.getBool(1)
    touchX = input.getNumber(3)
    touchY = input.getNumber(4)
    if isTouched then pushingTime = pushingTime + 1 or 0 else pushingTime = 0 end
    if pushingTime == 1 and 0 <= touchY and touchY <= 5 then
        pos = 0
        for tab = 1, tabsCount do
            if tab == activeTab then
                pos = pos + activeTabWidth
            else
                if pos + 1 <= touchX and touchX <= pos + otherTabsWidth then
                    activeTab = tab
                end
                pos = pos + otherTabsWidth
            end
        end
    end
    output.setNumber(1, activeTab)
    output.setBool(1, (activeTab - 1) & 1 == 1)
    output.setBool(2, (activeTab - 1) & 2 == 2)
    output.setBool(3, (activeTab - 1) & 4 == 4)
end

function onDraw()
    width = screen.getWidth()
    bblack()
    screen.drawRectF(0, 0, width, 6)

    pos = 0
    for tab = 1, tabsCount do
        if tab == activeTab then
            black()
            screen.drawRectF(pos, 0, activeTabWidth + 1, 6)
            bwhite()
            screen.drawText(pos + 1, 1, tabLabel[tab]:sub(1, activeTabWidth / 5))
            pos = pos + activeTabWidth
        else
            white()
            screen.drawRectF(pos + 1, 1, otherTabsWidth - 1, 5)
            bwhite()
            screen.drawText(pos + 1, 1, tabLabel[tab]:sub(1, otherTabsWidth / 5))
            pos = pos + otherTabsWidth
        end
    end
end
