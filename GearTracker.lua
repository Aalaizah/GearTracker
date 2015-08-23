local sets = {}
local eventHandlers = {}
local name, currentSpec, count

-- UnitClass(player)
-- <CheckButton name="UIRadioButtonTemplate" virtual="true">...</CheckButton>

function GearTracker_OnLoad(frame)
	frame:RegisterEvent("ADDON_LOADED")
	frame:RegisterEvent("VARIABLES_LOADED")
    frame:RegisterEvent("PLAYER_ENTERING_WORLD")
	-- Mouse handling
	frame:RegisterForDrag("LeftButton")
end

function GearTracker_OnEvent(frame, event, ...)
	return eventHandlers[event](frame, ...)
end

function eventHandlers.ADDON_LOADED(frame, ...)
    if ... == "GearTracker" then
        --if currentGearSets[1] == nil then
            GearTracker_Setup()
        --end
    end
    frame:UnregisterEvent("ADDON_LOADED")
end

function eventHandlers.VARIABLES_LOADED()
end

function eventHandlers.PLAYER_ENTERING_WORLD()
    GearTracker_Check()
end

function GearTracker_Setup()
    print("Setup")
    count = GetNumEquipmentSets()
    if count > 0 then
       for i = 1, count, 1 do
          name = GetEquipmentSetInfo(i)
          sets[i] = name
       end
    end
    for i = 1, count, 1 do
       print('set ' .. i .. ': ' .. sets[i])
    end
end

function GearTracker_Update()
    print("Update")
end

function GearTracker_Check()
    print("Checking Gear")
end

SLASH_GEARTRACKER1, SLASH_GEARTRACKER2 = '/geartracker', '/gt'
function SlashCmdList.GEARTRACKER(msg, editbox)
    if msg == 'reset' or msg == 'setup' then
        GearTracker_Setup()
    elseif msg == 'update' then
        GearTracker_Update()
    else
        if GearTrackerFrame:IsShown() then
            GearTrackerFrame:Hide()
        else
            GearTrackerFrame:Show()
        end
    end
end