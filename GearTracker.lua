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
        if currentGearSets == nil then
            GearTracker_Setup()
        end
    end
    frame:UnregisterEvent("ADDON_LOADED")
end

function eventHandlers.VARIABLES_LOADED()
end

function eventHandlers.PLAYER_ENTERING_WORLD()
    if GetInstanceInfo() == "raid" then
        GearTracker_Check()
    end
end

function GearTracker_Setup()
    --print("Setup")
    count = GetNumEquipmentSets()
    if count > 0 then
       for i = 1, count, 1 do
          name = GetEquipmentSetInfo(i)
          sets[i] = {name, isEquipped}
          currentGearSets[i] = {name, isEquipped}
       end
    end
    --[[for i = 1, count, 1 do
       print('set ' .. i .. ': ' .. sets[i])
       testSet = GetEquipmentSetItemIDs(sets[i])
       currentGearSets[i] = testSet
    end]]
end

function GearTracker_Update()
    --print("Update")
    currentGearSets = {}
    count = GetNumEquipmentSets()
    if count > 0 then
       for i = 1, count, 1 do
          name, icon, setID, isEquipped = GetEquipmentSetInfo(i)
          sets[i] = {name, isEquipped}
          currentGearSets[i] = {name, isEquipped}
       end
    end
    --[[for i = 1, count, 1 do
       print('set ' .. i .. ': ' .. sets[i])
       testSet = GetEquipmentSetItemIDs(sets[i])
       currentGearSets[i] = {sets[i], testSet}
    end]]
end

function GearTracker_Check()
    --print("Checking Gear")
    --[[for i=1, table.maxn(currentGearSets) do
        --for k=1, table.maxn(currentGearSets[i]) do
            print(currentGearSets[i])
        --end
    end]]
    specID = GetSpecialization()
    id, name = GetSpecializationInfo(specID)
    for k, v in pairs(currentGearSets) do
        if v[1] == name then
            --print(v[1] .. " " .. tostring(v[2]))
            if v[2] == false then
                message("Correct Equipment not Equiped")
            end
        end
    end
end

SLASH_GEARTRACKER1, SLASH_GEARTRACKER2 = '/geartracker', '/gt'
function SlashCmdList.GEARTRACKER(msg, editbox)
    if msg == 'reset' or msg == 'setup' then
        GearTracker_Setup()
    elseif msg == 'update' then
        GearTracker_Update()
    elseif msg == 'test' then
        print(sets)
        for i=1, table.maxn(sets) do
            print('set ' .. i .. ': ' .. sets[i])
        end
    else
        if GearTrackerFrame:IsShown() then
            GearTrackerFrame:Hide()
        else
            GearTrackerFrame:Show()
        end
    end
end