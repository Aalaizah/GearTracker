local sets = {}
local eventHandlers = {}
local name, currentSpec, count, currentLocation

-- UnitClass(player)
-- <CheckButton name="UIRadioButtonTemplate" virtual="true">...</CheckButton>

function GearTracker_OnLoad(frame)
	frame:RegisterEvent("ADDON_LOADED")
	frame:RegisterEvent("VARIABLES_LOADED")
    frame:RegisterEvent("PLAYER_ENTERING_WORLD")
    frame:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
    frame:RegisterEvent("READY_CHECK")
    frame:RegisterEvent("WEAR_EQUIPMENT_SET")
	-- Mouse handling
	frame:RegisterForDrag("LeftButton")
end

function GearTracker_OnEvent(frame, event, ...)
	return eventHandlers[event](frame, ...)
end

function eventHandlers.ADDON_LOADED(frame, ...)
    if ... == "GearTracker" then
        if currentGearSets == nil then
            GearTracker_Setup()
        end
    end
    frame:UnregisterEvent("ADDON_LOADED")
end

function eventHandlers.ACTIVE_TALENT_GROUP_CHANGED()
    GearTracker_Update()
end

function eventHandlers.READY_CHECK()
    GearTracker_Check()
end

function eventHandlers.WEAR_EQUIPMENT_SET()
    GearTracker_Update()
    GearTracker_Check()
end

function eventHandlers.VARIABLES_LOADED()
    GearTrackerFrameSpec1ButtonText:SetText("Brewmaster")
    GearTrackerFrameSpec2ButtonText:SetText("Windwalker")
    GearTrackerFrameSpec3ButtonText:SetText("Mistweaver")
    GearTrackerFrameSpec4ButtonText:SetText("Other")
end

function eventHandlers.PLAYER_ENTERING_WORLD()
    instanceName, instanceType = GetInstanceInfo()
    if instanceType == "raid" then
        GearTracker_Check()
    end
end

function GearTracker_Setup()
    count = GetNumEquipmentSets()
    local currentGearSets = {}
    if count > 0 then
       for i = 1, count, 1 do
          name = GetEquipmentSetInfo(i)
          sets[i] = {name, isEquipped}
          currentGearSets[i] = {name, isEquipped}
       end
    end
    GearTrackerFrameCurrentGearSetString:SetText(sets[1][1])
end

function GearTracker_Update()
    currentGearSets = {}
    count = GetNumEquipmentSets()
    if count > 0 then
       for i = 1, count, 1 do
          name, icon, setID, isEquipped = GetEquipmentSetInfo(i)
          sets[i] = {name, isEquipped}
       end
    end
    print(sets[1][1])
    GearTrackerFrameCurrentGearSetString:SetText(sets[1][1])
    --GearTrackerFrame:Hide()
end

function GearTracker_Check()
    --[[for i=1, table.maxn(currentGearSets) do
        --for k=1, table.maxn(currentGearSets[i]) do
            print(currentGearSets[i])
        --end
    end]]
    specID = GetSpecialization()
    id, currentSpec = GetSpecializationInfo(specID)
    GearTrackerFrameSpec1ButtonText:SetText(currentSpec)
    for k, v in pairs(currentGearSets) do
        if v[1] == name then
            if v[2] == false then
                message("Correct Equipment not Equiped")
            end
        end
    end
    GearTrackerFrame:Hide()
end

SLASH_GEARTRACKER1, SLASH_GEARTRACKER2 = '/geartracker', '/gt'
function SlashCmdList.GEARTRACKER(msg, editbox)
    if msg == 'reset' or msg == 'setup' then
        GearTracker_Setup()
    elseif msg == 'update' then
        GearTracker_Update()
    elseif msg == 'check' then
        GearTracker_Check()
    else
        if GearTrackerFrame:IsShown() then
            GearTrackerFrame:Hide()
        else
            GearTrackerFrame:Show()
        end
    end
end