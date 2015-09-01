local sets = {}
local eventHandlers = {}
local specList = specListTable
local name, currentSpec, count, currentLocation, class

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
        elseif currentSpecSets == nil then
            GearTracker_Setup()
        else
            GearTrackerFrame:Hide()
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
    class = UnitClass("player")
    GearTrackerFrameSpec1ButtonText:SetText(specList[class][1])
    GearTrackerFrameSpec2ButtonText:SetText(specList[class][2])
    GearTrackerFrameSpec3ButtonText:SetText(specList[class][3])
    GearTrackerFrameSpec4Button:Hide()
    if class == "Druid" then
        GearTrackerFrameSpec4Button:Show()
        GearTrackerFrameSpec4ButtonText:SetText(specList[class][4])
    end
    currentGearSets = currentGearSets
    currentSpecSets = currentSpecSets
    count = GetNumEquipmentSets()
end

function eventHandlers.PLAYER_ENTERING_WORLD()
    instanceName, instanceType = GetInstanceInfo()
    if instanceType == "raid" then
        GearTracker_Check()
    end
end

function GearTracker_Setup()
    SetAllButtonsFalse()
    count = GetNumEquipmentSets()
    currentLocation = 1
    currentGearSets = {}
    currentSpecSets = {}
    if count > 0 then
        for i = 1, count, 1 do
            name, icon, setID, isEquipped = GetEquipmentSetInfo(i)
            currentGearSets[i] = {name, isEquipped}
        end
        GearTrackerFrameCurrentGearSetString:SetText(currentGearSets[currentLocation][1])
    end
end

function GearTracker_Update()
    GearTrackerFrame:Show()
    currentGearSets = {}
    currentSpecSets = {}
    count = GetNumEquipmentSets()
    currentLocation = 1
    if count > 0 then
        for i = 1, count, 1 do
            name, icon, setID, isEquipped = GetEquipmentSetInfo(i)
            currentGearSets[i] = {name, isEquipped}
        end
        GearTrackerFrameCurrentGearSetString:SetText(currentGearSets[currentLocation][1])
    end
    --GearTrackerFrame:Hide()
end

function GearTracker_Check()
    specID = GetSpecialization()
    count = GetNumEquipmentSets()
    id, currentSpec = GetSpecializationInfo(specID)
    for i = 1, count, 1 do
        print(currentGearSets[i][1])
        if currentSpecSets[currentGearSets[i][1]][currentSpec] == true then
            print(currentSpecSets[currentGearSets[i][1]][currentSpec])
            break
        else
            message("Correct Equipment not Equipped")
            break
        end
    end
end

function GearTrackerAcceptButton_OnClick()
    if class == "Druid" then
        currentSpecSets[currentGearSets[currentLocation][1]] = { 
            [(specList[class][1])] = GearTrackerFrameSpec1Button:GetChecked(), 
            [(specList[class][2])] = GearTrackerFrameSpec2Button:GetChecked(), 
            [(specList[class][3])] = GearTrackerFrameSpec3Button:GetChecked(), 
            [(specList[class][4])] = GearTrackerFrameSpec4Button:GetChecked()
        }
    else
        currentSpecSets[currentGearSets[currentLocation][1]] = {
            [(specList[class][1])] = GearTrackerFrameSpec1Button:GetChecked(), 
            [(specList[class][2])] = GearTrackerFrameSpec2Button:GetChecked(), 
            [(specList[class][3])] = GearTrackerFrameSpec3Button:GetChecked()
        }
    end
    
    SetAllButtonsFalse()
    currentLocation = currentLocation + 1
    if currentLocation <= count then
        GearTrackerFrameCurrentGearSetString:SetText(currentGearSets[currentLocation][1])
    else
        GearTrackerFrame:Hide()
        currentLocation = 0
    end
end

function SetAllButtonsFalse()
    GearTrackerFrameSpec1Button:SetChecked(false)
    GearTrackerFrameSpec2Button:SetChecked(false)
    GearTrackerFrameSpec3Button:SetChecked(false)
    GearTrackerFrameSpec4Button:SetChecked(false)
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
        GearTracker_Update()
    end
end