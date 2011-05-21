--------------------------------------------------------------------------------------
-- General Configuration
--------------------------------------------------------------------------------------
mmconfig = {
	menudirection = false,							-- true = menu below the "m" button
													-- false = menu above the "m" button
	hideonclick = true,								-- Hide the menu after clicking a button (hold shift to not hide the menu)

	buttonwidth = 20,								-- "m"enu Button Width	(better use an even number)
	buttonheight = 20,								-- "m"enu Button Height	(better use an even number)

	addonbuttonwidth = 130,							-- Addons-Button Width
	addonbuttonheight = 25,							-- Addons-Button Height

	fontheight = 8,								-- Fontsize
	font = "Interface\\AddOns\\mmenu\\font.ttf",	-- Font

	color = {.2, .4, .7},							-- Text Color
	mouseover_color = {1, 1, 1, 1},				-- Text Color on mouseover

	BackDropColor = {.05,.05,.05,1 },				-- Frame Background Color
	BackDropBorderColor = {.2,.2,.2,1 },			-- Frame Border Color
	mouseoverBackdrop = {.1,.1,.1,1 },				-- Mouseover BackdropColor
	
	classcolor = false,								-- Classcolored font + texture
	
	fadetime = 0.25,     							-- Fade In or Out Time (in seconds) 
	
	tukuisupport = true,							-- Tukui support for colors & datatext (["mmenu"])
	WIMSupport = true,								-- WIM support?

	mList = {										-- Manage which Addons will be listed in the "m"enu
		WorldMap = false,
		Bags = false,
		VuhDo = true,
		Grid = true,
		HealBot = true,
		Numeration = true, 
		Skada = true,
		TinyDPS = true,
		Recount = true,
		DBM = true,
		Omen = true,
		Atlas = true,
		Cascade = true,
		TukuiConfig = false,
		Arh = true,
		ReloadUI = false,
		Raidmarkbar = true,
		PhoenixStyle = true,
		Altoholic = true,
	},
	
	hideopen = false,								-- Hide the "O"pen all Button?
	openall = {										-- Manage which Addons will be open on the open-all buttons
		WorldMap = false,
		Bags = false,
		VuhDo = true,
		Grid = true,
		HealBot = true,
		Numeration = true, 
		Skada = true,
		TinyDPS = true,
		Recount = true,
		DBM = true,
		Omen = true,
		Atlas = false,
		Cascade = true,
		Arh = false,
		TukuiConfig = false,
		Raidmarkbar = false,
		PhoenixStyle = false,
		Altoholic = false,
	},

	hideclose = false,								-- Hide the "C"lose all Button?
	closeall = {									-- Manage which Addons will be close on the close-all buttons
		WorldMap = false,
		Bags = false,
		VuhDo = true,
		Grid = true,
		HealBot = true,
		Numeration = true, 
		Skada = true,	
		TinyDPS = true,
		Recount = true,
		DBM = true,
		Omen = true,
		Atlas = true,
		Cascade = true,
		Arh = false,
		TukuiConfig = true,
		Raidmarkbar = false,
		PhoenixStyle = false,
		Altoholic = false,
	},
}
--------------------------------------------------------------------------------------
-- Extended Configuration
--------------------------------------------------------------------------------------

-- classcolor
if (mmconfig.classcolor) then
	local classcolor = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[select(2,UnitClass("player"))]
	mmconfig.mouseover_color = {classcolor.r,classcolor.g,classcolor.b,1}
end

-- convert rgb to hex
local rt, gt, bt = unpack(mmconfig.color)
mmconfig.color_text = ("|cff%.2x%.2x%.2x"):format(rt * 255, gt * 255, bt * 255)

-- convert mouseover_color rgb to hex
local r, g, b = unpack(mmconfig.mouseover_color)
mmconfig.mouseover_text = ("|cff%.2x%.2x%.2x"):format(r * 255, g * 255, b * 255)

--------------------------------------------------------------------------------------
-- Tukui Support Configuration
--------------------------------------------------------------------------------------
if mmconfig.tukuisupport and IsAddOnLoaded("Tukui") then
	local T, C, L = unpack(Tukui)
	mmconfig.BackDropColor = (C["media"].backdropcolor)
	mmconfig.BackDropBorderColor = (C["media"].bordercolor)

	-- Duffed edit
	if T.Duffed then
		mmconfig.mouseover_text = T.panelcolor
		mmconfig.mouseover_color = (C["datatext"].color)
	end
	
	-- Datatext Button
	if C["datatext"].mmenu and C["datatext"].mmenu > 1 then
		local Stat = CreateFrame("Frame", "mMenuDatatextButton", TukuiInfoLeft)
		Stat:EnableMouse(true)
		
		local Text = Stat:CreateFontString(nil, "LOW")
		Text:SetFont(unpack(T.Fonts.dFont.setfont))
		Text:SetText(mmconfig.mouseover_text.."m|r"..mmconfig.color_text.."Menu|r")
		T.PP(C["datatext"].mmenu, Text)
		Stat:SetAllPoints(Text)
		
		Stat:SetScript("OnMouseDown", function()
			if mMenuList:IsShown() then
				mMenuList:Hide()
			else
				mMenuList:Show()
				UIFrameFadeIn(mMenuList, mmconfig.fadetime, 0, 1)
			end
		end)
		
		Stat:SetScript("OnEnter", function()
			Text:SetText(mmconfig.mouseover_text.."mMenu|r")
		end)
		Stat:SetScript("OnLeave", function()
			Text:SetText(mmconfig.mouseover_text.."m|r"..mmconfig.color_text.."Menu|r")
		end)
		
		mmconfig.hideopen = true
		mmconfig.hideclose = true
		
		-- (Duffed UI) Forge menudirection
		if T.Duffed then
			if C.datatext.mmenu < 7 then
				mmconfig.menudirection = false
			else
				mmconfig.menudirection = true
			end
		end
	end
end