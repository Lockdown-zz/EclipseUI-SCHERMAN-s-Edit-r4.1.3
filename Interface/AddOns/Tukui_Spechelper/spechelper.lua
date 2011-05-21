-----------------------------------------------
-- Spec Helper, by EPIC
-----------------------------------------------
local T, C, L = unpack(Tukui) -- Import: T - functions, constants, variables; C - config; L - locales

-- colors
local hoverovercolor = {.2, .4, .7}
local cp = "|cff319f1b" -- +
local cm = "|cff9a1212" -- -
local dr, dg, db = unpack({ .2, .4, .7 })
panelcolor = ("|cff%.2x%.2x%.2x"):format(dr * 255, dg * 255, db * 255)

-- Gear Settings
local Autogearswap = true
local set1 = 1 -- this is the gear set that gets equiped with your primary spec.
local set2 = 2 -- this is the gear set that gets equiped with your secondary spec.

--functions
local function HasDualSpec() if GetNumTalentGroups() > 1 then return true end end

local function ActiveTalents()
	local tree1 = select(5,GetTalentTabInfo(1))
	local tree2 = select(5,GetTalentTabInfo(2))
	local tree3 = select(5,GetTalentTabInfo(3))
	local Tree = GetPrimaryTalentTree(false,false,GetActiveTalentGroup())
	return tree1, tree2, tree3, Tree
end	

local function UnactiveTalents()
	if GetActiveTalentGroup() == 1 then
		secondary = 2
	else
		secondary = 1
	end
	local sTree1 = select(5,GetTalentTabInfo(1,false,false, secondary))
	local sTree2 = select(5,GetTalentTabInfo(2,false,false, secondary))
	local sTree3 = select(5,GetTalentTabInfo(3,false,false, secondary))
	local sTree = GetPrimaryTalentTree(false,false,(secondary))
	return sTree1, sTree2, sTree3, sTree
end
local function AutoGear()
	if GetActiveTalentGroup() == 1 then
		UseEquipmentSet(GetEquipmentSetInfo(set1))
	else
		UseEquipmentSet(GetEquipmentSetInfo(set2))
	end
end

-----------
-- Spec
-----------
local spec = CreateFrame("Button", "Spec", UIParent)
spec:CreatePanel("Default", 1, 20, "TOPRIGHT", UIParent, "TOPRIGHT", -32, -212)

	-- Positioning
	if TukuiMinimap then
		spec:SetPoint("TOPLEFT", TukuiMinimap, "BOTTOMLEFT", 0, -13)
		spec:SetPoint("TOPRIGHT", TukuiMinimap, "BOTTOMRIGHT", -23, -13)
	end
	if TukuiMinimapStatsLeft and TukuiMinimapStatsRight then
		spec:SetPoint("TOPLEFT", TukuiMinimapStatsLeft, "BOTTOMLEFT", 0, -3)
		spec:SetPoint("TOPRIGHT", TukuiMinimapStatsRight, "BOTTOMRIGHT", -23, -3)
	end
	if RaidBuffReminder then
		spec:SetPoint("TOPLEFT", RaidBuffReminder, "BOTTOMLEFT", 0, -3)
		spec:SetPoint("TOPRIGHT", RaidBuffReminder, "BOTTOMRIGHT", -23, -3)
	end	
	-- Text
	spec.t = spec:CreateFontString(spec, "OVERLAY")
	spec.t:SetPoint("CENTER")
	spec.t:SetFont(unpack(T.Fonts.dFont.setfont))

	local int = 1
	local function Update(self, t)
	int = int - t
	if int > 0 then return end
		if not GetPrimaryTalentTree() then spec.t:SetText("No talents") return end
		local tree1, tree2, tree3, Tree = ActiveTalents()
		name = select(2, GetTalentTabInfo(Tree))
		spec.t:SetText(name.." "..panelcolor..tree1.."/"..tree2.."/"..tree3)
		if HasDualSpec() then
			local sTree1, sTree2, sTree3, sTree = UnactiveTalents()
			sName = select(2, GetTalentTabInfo(sTree))
			spec:SetScript("OnEnter", function() spec.t:SetText(cm..sName.." "..panelcolor..sTree1.."/"..sTree2.."/"..sTree3) end)
			spec:SetScript("OnLeave", function() spec.t:SetText(name.." "..panelcolor..tree1.."/"..tree2.."/"..tree3) end)
		end
		int = 1
		self:SetScript("OnUpdate", nil)
	end
	
	local function OnEvent(self, event)
		if event == "PLAYER_ENTERING_WORLD" then
			self:UnregisterEvent("PLAYER_ENTERING_WORLD")
		else
			self:SetScript("OnUpdate", Update)
		end
	end
	
	spec:RegisterEvent("PLAYER_TALENT_UPDATE")
	spec:RegisterEvent("PLAYER_ENTERING_WORLD")
	spec:RegisterEvent("CHARACTER_POINTS_CHANGED")
	spec:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
	spec:SetScript("OnEvent", OnEvent) 

	spec:SetScript("OnClick", function(self) 
	local i = GetActiveTalentGroup()
		if i == 1 then SetActiveTalentGroup(2) end
		if i == 2 then SetActiveTalentGroup(1) end
	end)

----------------
--Toggle Button
----------------
local toggle = CreateFrame("Button", "Toggle", Spec)
toggle:CreatePanel("Default", 20, 20, "TOPLEFT", Spec, "TOPRIGHT", 3, 0)

	if C.general.ali == true then
	toggle:SetBackdropColor(unpack(C.general.color))
	end

		toggle.t = toggle:CreateFontString(nil, "OVERLAY")
		toggle.t:SetPoint("CENTER")
		toggle.t:SetFont(unpack(T.Fonts.dFont.setfont))
		toggle.t:SetText(cp.."+|r")
		toggle:SetScript("OnEnter", function(self) self:SetBackdropBorderColor(unpack(hoverovercolor)) end)
		toggle:SetScript("OnLeave", function(self) self:SetBackdropBorderColor(unpack(C.media.bordercolor)) end)
		
		toggle:SetScript("OnClick", function(self) 
			if DPS:IsShown() then	
				DPS:Hide()
				toggle.t:SetText(cp.."+|r")
			else
				DPS:Show()
				toggle.t:SetText(cm.."-|r")
			end
		end)
		
--------------
-- DPS layout
--------------
local dps = CreateFrame("Button", "DPS", Toggle, "SecureActionButtonTemplate")
dps:CreatePanel("Default", 28, 19, "TOPRIGHT", Toggle, "BOTTOMRIGHT", 0, -3)
dps:Hide()		
dps.t = dps:CreateFontString(nil, "OVERLAY")
dps.t:SetPoint("CENTER")
dps.t:SetFont(unpack(T.Fonts.dFont.setfont))
dps.t:SetText("DPS")

dps:SetScript("OnEnter", function(self) self:SetBackdropBorderColor(unpack(hoverovercolor)) end)
dps:SetScript("OnLeave", function(self) self:SetBackdropBorderColor(unpack(C.media.bordercolor)) end)
dps:SetAttribute("type", "macro")
dps:SetAttribute("macrotext", "/dps")
---------------	
-- Heal layout
---------------
local heal = CreateFrame("Button", "HEAL", DPS, "SecureActionButtonTemplate")
heal:CreatePanel("Default", 29, 19, "RIGHT", DPS, "LEFT", -3, 0)
		
heal.t = heal:CreateFontString(nil, "OVERLAY")
heal.t:SetPoint("CENTER")
heal.t:SetFont(unpack(T.Fonts.dFont.setfont))
heal.t:SetText("HEAL")

heal:SetScript("OnEnter", function(self) self:SetBackdropBorderColor(unpack(hoverovercolor)) end)
heal:SetScript("OnLeave", function(self) self:SetBackdropBorderColor(unpack(C.media.bordercolor)) end)
heal:SetAttribute("type", "macro")
heal:SetAttribute("macrotext", "/heal")
------------
--Key Binds
------------
local binds = CreateFrame("Button", "Binds", HEAL, "SecureActionButtonTemplate")
binds:CreatePanel("Default", 30, 19, "RIGHT", HEAL, "LEFT", -3, 0)

binds.t = binds:CreateFontString(nil, "OVERLAY")
binds.t:SetPoint("CENTER")
binds.t:SetFont(unpack(T.Fonts.dFont.setfont))
binds.t:SetText("Bind")

binds:SetScript("OnEnter", function(self) self:SetBackdropBorderColor(unpack(hoverovercolor)) end)
binds:SetScript("OnLeave", function(self) self:SetBackdropBorderColor(unpack(C.media.bordercolor)) end)
binds:SetAttribute("type", "macro")
binds:SetAttribute("macrotext", "/bindkey")
		
------------
--Move UI
------------
local mui = CreateFrame("Button", "MoveUI", Binds, "SecureActionButtonTemplate")
mui:CreatePanel("Default", 48, 19, "RIGHT", Binds, "LEFT", -3, 0)
		
mui.t = mui:CreateFontString(nil, "OVERLAY")
mui.t:SetPoint("CENTER")
mui.t:SetFont(unpack(T.Fonts.dFont.setfont))
mui.t:SetText("Move UI")

mui:SetScript("OnEnter", function(self) self:SetBackdropBorderColor(unpack(hoverovercolor)) end)
mui:SetScript("OnLeave", function(self) self:SetBackdropBorderColor(unpack(C.media.bordercolor)) end)
mui:SetAttribute("type", "macro")
mui:SetAttribute("macrotext", "/moveui")

------------------		
-- Gear switching
------------------
local gearSets = CreateFrame("Frame", "gearSets", DPS)	
for i = 1, 10 do
		gearSets[i] = CreateFrame("Button", "gearSets"..i, DPS)
		gearSets[i]:CreatePanel("Default", 19, 19, "CENTER", DPS, "CENTER", 0, 0)

		if i == 1 then
			gearSets[i]:Point("TOPRIGHT", DPS, "BOTTOMRIGHT", 0, -3)
		else
			gearSets[i]:SetPoint("BOTTOMRIGHT", gearSets[i-1], "BOTTOMLEFT", -3, 0)
		end
		gearSets[i].texture = gearSets[i]:CreateTexture(nil, "BORDER")
		gearSets[i].texture:SetTexCoord(0.08, 0.92, 0.08, 0.92)
		gearSets[i].texture:SetPoint("TOPLEFT", gearSets[i] ,"TOPLEFT", 2, -2)
		gearSets[i].texture:SetPoint("BOTTOMRIGHT", gearSets[i] ,"BOTTOMRIGHT", -2, 2)
		gearSets[i].texture:SetTexture(select(2, GetEquipmentSetInfo(i)))
		gearSets[i]:Hide()
	
	gearSets[i]:RegisterEvent("PLAYER_ENTERING_WORLD")
	gearSets[i]:RegisterEvent("EQUIPMENT_SETS_CHANGED")
	gearSets[i]:SetScript("OnEvent", function(self, event)
	local points, pt = 0, GetNumEquipmentSets()
	local frames = { gearSets[1]:IsShown(), gearSets[2]:IsShown(), gearSets[3]:IsShown(), gearSets[4]:IsShown(), 
					 gearSets[5]:IsShown(), gearSets[6]:IsShown(), gearSets[7]:IsShown(), gearSets[8]:IsShown(), --I can't believe this works
					 gearSets[9]:IsShown(), gearSets[10]:IsShown() }
		if pt > points then
			for i = points + 1, pt do
				gearSets[i]:Show()
			end
		end
		if frames[pt+1] == 1 then
			gearSets[pt+1]:Hide()
		end
		
		gearSets[i].texture = gearSets[i]:CreateTexture(nil, "BORDER")
		gearSets[i].texture:SetTexCoord(0.08, 0.92, 0.08, 0.92)
		gearSets[i].texture:SetPoint("TOPLEFT", gearSets[i] ,"TOPLEFT", 2, -2)
		gearSets[i].texture:SetPoint("BOTTOMRIGHT", gearSets[i] ,"BOTTOMRIGHT", -2, 2)
		gearSets[i].texture:SetTexture(select(2, GetEquipmentSetInfo(i)))
		
		gearSets[i]:SetScript("OnClick", function(self) UseEquipmentSet(GetEquipmentSetInfo(i)) end)
		gearSets[i]:SetScript("OnEnter", function(self) self:SetBackdropBorderColor(unpack(hoverovercolor)) end)
		gearSets[i]:SetScript("OnLeave", function(self) self:SetBackdropBorderColor(unpack(C.media.bordercolor)) end)
		
		gearSets[set1]:SetBackdropBorderColor(0,1,0)
		gearSets[set2]:SetBackdropBorderColor(1,0,0)
		gearSets[set1]:SetScript("OnEnter", nil)
		gearSets[set1]:SetScript("OnLeave", nil)
		gearSets[set2]:SetScript("OnEnter", nil)
		gearSets[set2]:SetScript("OnLeave", nil)
	end)
end	
if Autogearswap == true then
	gearsetfunc = CreateFrame("Frame", "gearSetfunc", UIParent)
	gearsetfunc:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
	gearsetfunc:SetScript("OnEvent", function(self, event)
	AutoGear()
	end) 
end