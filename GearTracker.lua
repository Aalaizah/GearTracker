local sets = {}
local currentGearSets = {}
local name
local count = GetNumEquipmentSets()
print(count)
if count > 0 then
   for i = 1, count, 1 do
      name = GetEquipmentSetInfo(i)
      sets[i] = name
   end
end

for i = 1, count, 1 do
   print('set ' .. i .. ': ' .. sets[i])
end

-- UnitClass(player)
-- <CheckButton name="UIRadioButtonTemplate" virtual="true">...</CheckButton>

function GearTracker_OnLoad(frame)
	frame:RegisterEvent("ADDON_LOADED")
	frame:RegisterEvent("VARIABLES_LOADED")
	-- Mouse handling
	frame:RegisterForDrag("LeftButton")
end

function WowDiabetes_OnEvent(frame, event, ...)
	return eventHandlers[event](frame, ...)
end


function GearTracker_Setup()
end

function GearTracker_Update()
end

function GearTracker_Check()
end