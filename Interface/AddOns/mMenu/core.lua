if IsAddOnLoaded("Tukui") then local T, C, L = unpack(Tukui) end
--------------------------------------------------------------------------------------
-- "mMenu" - Addon Toggle Menu
-- written by magges
--------------------------------------------------------------------------------------
mMenu = {}
-- Skin functions
function mMenu.skinbutton(f)
	f:SetBackdrop({bgFile = "Interface\\ChatFrame\\ChatFrameBackground", 
		edgeFile = "Interface\\ChatFrame\\ChatFrameBackground",
		tileSize = 0, edgeSize = 1, 
		insets = { left = -1, right = -1, top = -1, bottom = -1}
	})
	f:SetBackdropColor(unpack(mmconfig.BackDropColor))
	f:SetBackdropBorderColor(unpack(mmconfig.BackDropBorderColor))
	f:SetSize(mmconfig.buttonwidth, mmconfig.buttonheight)
end

function mMenu.skintext(f, arg1)
	f:EnableMouse(false)
	f:SetAlpha(1)

	f.text = f:CreateFontString(nil, "LOW")
	f.text:SetPoint("CENTER", 2, -1)
	f.text:SetFont(mmconfig.font, mmconfig.fontheight)
	f.text:SetText(mmconfig.color_text..arg1)
	
	--(mouseover)
	f:SetScript("OnEnter", function()
		UIFrameFadeIn(f, mmconfig.fadetime, 0.4, 1)
		f.text:SetText(mmconfig.mouseover_text..arg1)
		f:SetBackdropColor(unpack(mmconfig.mouseoverBackdrop))
	end)
	f:SetScript("OnLeave", function()
		UIFrameFadeOut(f, mmconfig.fadetime, 1, 0.4)
		f.text:SetText(mmconfig.color_text..arg1)
		f:SetBackdropColor(unpack(mmconfig.BackDropColor))
	end)
	
	if IsAddOnLoaded("Tukui") and TukuiMinimap.shadow then f:CreateShadow("Default") end
end

-- the menu open button
local openmenubutton = CreateFrame("Frame", "mMenuOpen", UIParent)
mMenu.skinbutton(openmenubutton)
openmenubutton:SetPoint("CENTER",0,0)
openmenubutton:SetMovable(true)
if IsAddOnLoaded("Tukui") and TukuiMinimap.shadow then openmenubutton:CreateShadow("Default") end

-- (texture)
openmenubutton.texture = openmenubutton:CreateTexture(nil, "OVERLAY")
if mmconfig.buttonwidth > 13 then
	openmenubutton.texture:SetPoint("CENTER", openmenubutton, "CENTER")
	openmenubutton.texture:SetSize(20, 20)
	openmenubutton.texture:SetTexture("Interface\\addons\\mMenu\\button")
	openmenubutton.texture:SetVertexColor(unpack(mmconfig.color))
	openmenubutton.texture:SetAlpha(1)
end
openmenubutton.texturemo = openmenubutton:CreateTexture(nil, "OVERLAY")
if mmconfig.buttonwidth > 13 then
	openmenubutton.texturemo:SetPoint("CENTER", openmenubutton, "CENTER")
	openmenubutton.texturemo:SetSize(20, 20)
	openmenubutton.texturemo:SetTexture("Interface\\addons\\mMenu\\button")
	openmenubutton.texturemo:SetVertexColor(unpack(mmconfig.mouseover_color))
	openmenubutton.texturemo:SetAlpha(1)
end

-- this frame around the buttons makes it easier for me to manage it and it looks better imo
local menu = CreateFrame("Frame", "mMenuList", UIParent)
mMenu.skinbutton(menu)
if mmconfig.menudirection == true then
	menu:SetPoint("TOPRIGHT", mMenuOpen, "BOTTOMRIGHT", 0, -3)
else
	menu:SetPoint("BOTTOMRIGHT", mMenuOpen, "TOPRIGHT", 0, 3)
end
menu:SetFrameLevel(2)
menu:SetFrameStrata("HIGH")
if IsAddOnLoaded("Tukui") and TukuiMinimap.shadow then menu:CreateShadow("Default") end
menu:Hide()

-- "close all" button
local close = CreateFrame("Frame", "mMenuClose", UIParent)
mMenu.skinbutton(close)
close:SetPoint("RIGHT", openmenubutton, "LEFT",-3,0)
mMenu.skintext(close, "C|r")
if (mmconfig.hideclose) then close:Hide() end

-- "open all" button
local open = CreateFrame("Frame", "mMenuOpen", UIParent)
mMenu.skinbutton(open)
if not (mmconfig.hideclose) then 
	open:SetPoint("RIGHT", close, "LEFT", -3, 0)
else
	open:SetPoint("RIGHT", openmenubutton, "LEFT", -3, 0)
end
mMenu.skintext(open, "O|r")
if (mmconfig.hideopen) then open:Hide() end

--------------------------------------------------------------------------------------
-- "Create Addon Button" function
--------------------------------------------------------------------------------------
function mMenu.CreateAddonButton(f, arg1)
	mMenu.skinbutton(f)
	f:SetSize(mmconfig.addonbuttonwidth, mmconfig.addonbuttonheight)
	f:SetFrameStrata("HIGH")
	f:SetFrameLevel(3)
	
	if mmconfig.menudirection == true then
		if mmenuaddons == 0 then
			f:SetPoint("TOPLEFT", mMenuList, "TOPLEFT", 2, -2)
		else
			f:SetPoint("TOPLEFT", mMenuList, "TOPLEFT", 2, -((mmenuaddons * mmconfig.addonbuttonheight) + 2 + (mmenuaddons*2)))
		end
	else
		if mmenuaddons == 0 then
			f:SetPoint("BOTTOMLEFT", mMenuList, "BOTTOMLEFT", 2, 2)
		else
			f:SetPoint("BOTTOMLEFT", mMenuList, "BOTTOMLEFT", 2, ((mmenuaddons * mmconfig.addonbuttonheight) + 2 + (mmenuaddons*2)))
		end
	end
	
	if mmconfig.hideonclick == true then
		f:SetScript("OnMouseUp", function()
			if not IsShiftKeyDown() then
				mMenuList:Hide()
			end
		end)
	end
	
	f.text = f:CreateFontString(nil, "LOW")
	f.text:SetFont(mmconfig.font, mmconfig.fontheight)
	f.text:SetWidth(mmconfig.addonbuttonwidth - 13)
	f.text:SetPoint("CENTER", f, "CENTER")
	f.text:SetText(mmconfig.color_text..arg1)

	f:SetScript("OnEnter", function()
		f.text:SetText(mmconfig.mouseover_text..arg1)
		f:SetBackdropColor(unpack(mmconfig.mouseoverBackdrop))
	end)
	f:SetScript("OnLeave", function()
		f.text:SetText(mmconfig.color_text..arg1)
		f:SetBackdropColor(unpack(mmconfig.BackDropColor))
	end)
end

--------------------------------------------------------------------------------------
-- Addon Buttons (order)
mmenuaddons = 0 -- Lets go!
--------------------------------------------------------------------------------------

-- Worldmap --------------------------
if (mmconfig.mList.WorldMap) then
	worldmapbutton = CreateFrame("Frame", "mMenuWorldMap", menu)
	mMenu.CreateAddonButton(worldmapbutton, "World Map|r")
	
	--open/close
	worldmapbutton:SetScript("OnMouseDown", function() ToggleFrame(WorldMapFrame) end)
	
	mmenuaddons = mmenuaddons + 1
end

-- Bags --------------------------
if (mmconfig.mList.Bags) then
	bagsbutton = CreateFrame("Frame", "mMenuBags", menu)
	mMenu.CreateAddonButton(bagsbutton, "Bags|r")
	
	--open/close
	bagsbutton:SetScript("OnMouseDown", function() OpenAllBags() end)
	
	mmenuaddons = mmenuaddons + 1
end

-- VuhDO --------------------------
if IsAddOnLoaded("VuhDo") and (mmconfig.mList.VuhDo) then
	vuhdobutton = CreateFrame("Frame", "mMenuVuhdo", menu)
	mMenu.CreateAddonButton(vuhdobutton, "VuhDo|r")
	
	--open/close
	vuhdobutton:SetScript("OnMouseDown", function(self, btn)
		if (btn == "LeftButton") then
			SlashCmdList["VUHDO"]("toggle")
		else
			ToggleFrame(VuhDoBuffWatchMainFrame)
		end
	end)
	
	mmenuaddons = mmenuaddons + 1
end

-- Grid/Grid2 --------------------------
if (IsAddOnLoaded("Grid") or IsAddOnLoaded("Grid2")) and (mmconfig.mList.Grid) then
	gridbutton = CreateFrame("Frame", "mMenuGrid", menu)
	mMenu.CreateAddonButton(gridbutton, "Grid|r")
	
	--open/close
	gridbutton:SetScript("OnMouseDown", function() 
		if IsAddOnLoaded("Grid2") then
			ToggleFrame(Grid2LayoutFrame)
		elseif IsAddOnLoaded("Grid") then
			ToggleFrame(GridLayoutFrame)
		end
	end)
	
	mmenuaddons = mmenuaddons + 1
end

-- Healbot --------------------------
if IsAddOnLoaded("HealBot") and (mmconfig.mList.HealBot) then
	hbbutton = CreateFrame("Frame", "mMenuHealbot", menu)
	mMenu.CreateAddonButton(hbbutton, "HealBot|r")
	
	--open/close
	hbbutton:SetScript("OnMouseDown", function() 
		HB_Timer1=0.01
        if HealBot_Config.DisableHealBot==0 then
            HealBot_Options_DisableHealBot:SetChecked(1)
            HealBot_Options_ToggleHealBot(1)
        else
            HealBot_Options_DisableHealBot:SetChecked(0)
            HealBot_Options_ToggleHealBot(0)
        end
	end)
	
	mmenuaddons = mmenuaddons + 1
end

-- Skada --------------------------
if IsAddOnLoaded("Skada") and (mmconfig.mList.Skada) then
	skadabutton = CreateFrame("Frame", "mMenuSkada", menu)
	mMenu.CreateAddonButton(skadabutton, "Skada|r")
	
	--open/close
	skadabutton:SetScript("OnMouseDown", function() Skada:ToggleWindow() end)
	
	disabled = true -- skada specific .. its more a test but better dont delete it
	
	mmenuaddons = mmenuaddons + 1
end

-- TinyDPS --------------------------
if IsAddOnLoaded("TinyDPS") and (mmconfig.mList.TinyDPS) then
	tdpsbutton = CreateFrame("Frame", "mMenuTDPS", menu)
	mMenu.CreateAddonButton(tdpsbutton, "TinyDPS|r")
	
	--open/close
	tdpsbutton:SetScript("OnMouseDown", function() ToggleFrame(tdpsFrame) end)
	
	mmenuaddons = mmenuaddons + 1
end

-- Numeration --------------------------
if IsAddOnLoaded("Numeration") and (mmconfig.mList.Numeration) then
	numdpsbutton = CreateFrame("Frame", "mMenuNumdps", menu)
	mMenu.CreateAddonButton(numdpsbutton, "Numeration|r")
	
	--open/close + shift key = reset
	numdpsbutton:SetScript("OnMouseDown", function() 
		if not IsShiftKeyDown() then
			ToggleFrame(NumerationFrame)
		else
			NumerationFrame:ShowResetWindow() 
		end
	end)
	
	mmenuaddons = mmenuaddons + 1
end

-- Recount --------------------------
if IsAddOnLoaded("Recount") and (mmconfig.mList.Recount) then
	recountbutton = CreateFrame("Frame", "mMenuRecount", menu)
	mMenu.CreateAddonButton(recountbutton, "Recount|r")
	
	--open/close
	recountbutton:SetScript("OnMouseDown", function() 
		if not IsShiftKeyDown() then
			if Recount.MainWindow:IsShown() then Recount.MainWindow:Hide() else Recount.MainWindow:Show();Recount:RefreshMainWindow() end 
		else
			Recount:ShowReset()
		end
	end)
	
	mmenuaddons = mmenuaddons + 1
end

-- DBM Config --------------------------
if IsAddOnLoaded("DBM-Core") and (mmconfig.mList.DBM) then
	DBMbutton = CreateFrame("Frame", "mMenuDBM", menu)
	mMenu.CreateAddonButton(DBMbutton, "DBM Config|r")
	
	--open/close
	DBMbutton:SetScript("OnMouseDown", function() DBM:LoadGUI() end)
	
	mmenuaddons = mmenuaddons + 1
end

-- Omen --------------------------
if IsAddOnLoaded("Omen") and (mmconfig.mList.Omen) then
	omenbutton = CreateFrame("Frame", "mMenuOmen", menu)
	mMenu.CreateAddonButton(omenbutton, "Omen|r")
	
	--open/close
	omenbutton:SetScript("OnMouseDown", function() Omen:Toggle() end)
	
	mmenuaddons = mmenuaddons + 1
end

-- Raidmark Bar --------------------------- 
if IsAddOnLoaded("TukuiMarkBar") and (mmconfig.mList.Raidmarkbar) then 
    markbarbutton = CreateFrame("Frame", "mMenuMarkbarn", menu) 
    mMenu.CreateAddonButton(markbarbutton, "Raidmarks|r") 
      
    --open/close 
    markbarbutton:SetScript("OnMouseDown", function() ToggleFrame(MarkBarBackground) end)
	
	mmenuaddons = mmenuaddons + 1
end

-- Atlasloot --------------------------
if IsAddOnLoaded("AtlasLoot") and (mmconfig.mList.Atlas) then
	atlasbutton = CreateFrame("Frame", "mMenuAtlasLoot", menu)
	mMenu.CreateAddonButton(atlasbutton, "AtlasLoot|r")
	
	--open/close
	atlasbutton:SetScript("OnMouseDown", function() ToggleFrame(AtlasLootDefaultFrame) end)
	
	mmenuaddons = mmenuaddons + 1
end

-- Altoholic --------------------------
if IsAddOnLoaded("Altoholic") and (mmconfig.mList.Altoholic) then
	altoholicbutton = CreateFrame("Frame", "mMenuAltoholic", menu)
	mMenu.CreateAddonButton(altoholicbutton, "Altoholic|r")
	
	--open/close
	altoholicbutton:SetScript("OnMouseDown", function() ToggleFrame(AltoholicFrame) end)
	
	mmenuaddons = mmenuaddons + 1
end

-- Cascade --------------------------
if IsAddOnLoaded("Cascade") and (mmconfig.mList.Cascade) then
	cascadebutton = CreateFrame("Frame", "mMenuCascade", menu)
	mMenu.CreateAddonButton(cascadebutton, "Cascade|r")
	
	--open/close
	cascadebutton:SetScript("OnMouseDown", function() ToggleFrame(CascadeFrame) end)
	
	mmenuaddons = mmenuaddons + 1
end

-- Archaeo Helper --------------------------
if IsAddOnLoaded("Arh") and (mmconfig.mList.Arh) then
	arhbutton = CreateFrame("Frame", "mMenuArh", menu)
	mMenu.CreateAddonButton(arhbutton, "Arh|r")
	
	--open/close
	arhbutton:SetScript("OnMouseDown", function() ToggleFrame(Arh_MainFrame) end)
	
	mmenuaddons = mmenuaddons + 1
end

-- PhoenixStyle --------------------------
if IsAddOnLoaded("PhoenixStyle") and (mmconfig.mList.PhoenixStyle) then
	phoenixbutton = CreateFrame("Frame", "mMenuPhoenixStyle", menu)
	mMenu.CreateAddonButton(phoenixbutton, "PhoenixStyle|r")
	
	--open/close
	phoenixbutton:SetScript("OnMouseDown", function() ToggleFrame(PSFmain1) ToggleFrame(PSFmain2) ToggleFrame(PSFmain3) end)
	
	mmenuaddons = mmenuaddons + 1
end

-- Tukui Config --------------------------
if IsAddOnLoaded("Tukui_ConfigUI") and IsAddOnLoaded("Tukui") and (mmconfig.mList.TukuiConfig) then
	tukuiconfig = CreateFrame("Frame", "mMenuTukuiConfig", menu)
	mMenu.CreateAddonButton(tukuiconfig, "Tukui Config|r")
	
	--open/close
	tukuiconfig:SetScript("OnMouseDown", function() SlashCmdList["CONFIG"]() end)
	
	mmenuaddons = mmenuaddons + 1
end

-- (Tukui)Elv Config --------------------------
if IsAddOnLoaded("ElvUI_ConfigUI") and IsAddOnLoaded("ElvUI") and (mmconfig.mList.TukuiConfig) then
	elvconfig = CreateFrame("Frame", "mMenuElvConfig", menu)
	mMenu.CreateAddonButton(elvconfig, "Elv Config|r")
	
	--open/close
	elvconfig:SetScript("OnMouseDown", function() SlashCmdList["CONFIG"]() end)
	
	mmenuaddons = mmenuaddons + 1
end

-- Reload UI -------------------------- 
if mmconfig.mList.ReloadUI then
	reloaduibutton = CreateFrame("Frame", "mMenuReloadUI", menu)
	mMenu.CreateAddonButton(reloaduibutton, "Reload UI|r")
	
		-- "Sure?" Button
		surebutton = CreateFrame("Button", nil, reloaduibutton)
		mMenu.CreateAddonButton(surebutton, "!|r")
		surebutton:SetWidth(mmconfig.addonbuttonheight+1)
		surebutton:ClearAllPoints()
		surebutton:SetPoint("LEFT", reloaduibutton, "RIGHT", 2, 0)
		surebutton:RegisterForClicks("AnyUp")
		surebutton:Hide()
		
		--Reload UI
		surebutton:SetScript("OnMouseUp", function() end)
		surebutton:SetScript("OnClick", function() ReloadUI() end)
	
	--open/close
	reloaduibutton:SetScript("OnMouseUp", function() end)
	reloaduibutton:SetScript("OnMouseDown", function() 
		ToggleFrame(surebutton) 
		if surebutton:IsShown() then
			reloaduibutton:SetWidth(mmconfig.addonbuttonwidth - (surebutton:GetWidth()+2))
		else
			reloaduibutton:SetWidth(mmconfig.addonbuttonwidth)
		end
	end)
	
	mmenuaddons = mmenuaddons + 1
end
--------------------------------------------------------------------------------------
-- Addon order ends here
--------------------------------------------------------------------------------------
-- Create a "No Addons" Button if there are no supported addons loaded + hide close & open button
menu:SetHeight((mmenuaddons * mmconfig.addonbuttonheight) + (mmenuaddons * 2) +2)
menu:SetWidth(mmconfig.addonbuttonwidth + 4)
if menu:GetHeight() < mmconfig.addonbuttonheight then
	local noaddons = CreateFrame("Frame", "mMenunoaddons", menu)
	mMenu.CreateAddonButton(noaddons)
	noaddons.text:SetText("|cff9b9b9bNo Addons :<|r")
	
	close:Hide()
	open:Hide()
	menu:SetHeight(mmconfig.addonbuttonheight + 4)
end

-- WIM --------------------------
if IsAddOnLoaded("WIM") and mmconfig.WIMSupport then
	-- W Button
	local wimbutton = CreateFrame("Frame", "mMenuWIM", openmenubutton)
	mMenu.skinbutton(wimbutton)
	wimbutton:SetPoint("LEFT", openmenubutton, "RIGHT", 3,0)
	mMenu.skintext(wimbutton, "W|r")
	
	-- WIM toggle function
	local hiddenWIM 
	function toggleWIM()
		if hiddenWIM then
			WIM.ShowAllWindows()
		else
			WIM.HideAllWindows()
		end
		hiddenWIM = not hiddenWIM 
	end
	
	-- Leftclick = toggle, rightclick = Menu
	wimbutton:SetScript("OnMouseUp", function(parent, btn)
		if(btn == "LeftButton") then
			toggleWIM()
			WIM.Menu:Hide();
		else
			WIM.Menu:ClearAllPoints();
			if(WIM.Menu:IsShown()) then
				WIM.Menu:Hide();
			else
				if mmconfig.menudirection == true then
					WIM.Menu:SetPoint("TOPLEFT", parent, "BOTTOMLEFT", -10, 10);
				else
					WIM.Menu:SetPoint("BOTTOMLEFT", parent, "TOPLEFT", -10, -10);
				end
				WIM.Menu:Show();
			end
		end
	end)
end

--------------------------------------------------------------------------------------
-- function
--------------------------------------------------------------------------------------

-- open menu function
openmenubutton:SetScript("OnMouseDown", function()
	if not IsShiftKeyDown() then
		if menu:IsShown() then
			menu:Hide()
			openmenubutton.texturemo:SetAlpha(1)
			openmenubutton.texture:SetAlpha(1)
			openmenubutton:SetBackdropColor(unpack(mmconfig.BackDropColor))
		else
			menu:Show()	
			openmenubutton.texturemo:SetAlpha(1)
			openmenubutton.texture:SetAlpha(1)
			openmenubutton:SetBackdropColor(unpack(mmconfig.mouseoverBackdrop))		
			UIFrameFadeIn(menu, mmconfig.fadetime, 0, 1)
		end
	else
	openmenubutton:ClearAllPoints()
	openmenubutton:StartMoving()
	end
end)

openmenubutton:SetScript("OnMouseUp", function()
	openmenubutton:StopMovingOrSizing()
end)

-- open all button
open:SetScript("OnMouseDown", function() 
	open:SetBackdropColor(unpack(mmconfig.mouseoverBackdrop))
end)
open:SetScript("OnMouseUp", function()
	if 										(mmconfig.openall.WorldMap) then	WorldMapFrame:Show() end
	if 										(mmconfig.openall.Bags) then		OpenAllBags() end
	if IsAddOnLoaded("VuhDo") and			(mmconfig.openall.VuhDo) then		SlashCmdList["VUHDO"]("show") end
	if IsAddOnLoaded("Grid") and	 		(mmconfig.openall.Grid) then 		GridLayoutFrame:Show() end -- Grid
	if IsAddOnLoaded("Grid2") and	 		(mmconfig.openall.Grid) then 		Grid2LayoutFrame:Show() end -- Grid2
	if IsAddOnLoaded("HealBot") and		 	(mmconfig.openall.HealBot) then 
												if HealBot_Options_DisableHealBot:GetChecked() then
													HealBot_Options_DisableHealBot:SetChecked(0)
													HealBot_Options_ToggleHealBot(0) 
												end end
	if IsAddOnLoaded("Numeration") and		(mmconfig.openall.Numeration) then	NumerationFrame:Show() end
	if IsAddOnLoaded("Skada") and 			(mmconfig.openall.Skada) then 		Skada:SetActive(disabled) end
	if IsAddOnLoaded("Omen") and 			(mmconfig.openall.Omen) then		Omen:Toggle(true) end
	if IsAddOnLoaded("AtlasLoot") and 		(mmconfig.openall.Atlas) then 		AtlasLootDefaultFrame:Show() end
	if IsAddOnLoaded("Recount") and			(mmconfig.openall.Recount) then 	Recount.MainWindow:Show();Recount:RefreshMainWindow() end
	if IsAddOnLoaded("TinyDPS") and	 		(mmconfig.openall.TinyDPS) then 	tdpsFrame:Show() end
	if IsAddOnLoaded("DBM-Code") and		(mmconfig.openall.DBM) then			DBM:LoadGUI() end
	if IsAddOnLoaded("Cascade") and			(mmconfig.openall.Cascade) then		CascadeFrame:Show() end
	if IsAddOnLoaded("Tukui_ConfigUI") and	(mmconfig.openall.TukuiConfig) then 
												if not TukuiConfigUI then SlashCmdList["CONFIG"]()
												else TukuiConfigUI:Show() end end
	if IsAddOnLoaded("ElvUI_ConfigUI") and	(mmconfig.openall.TukuiConfig) then 
												if not ElvuiConfigUI then SlashCmdList["CONFIG"]()
												else ElvuiConfigUI:Show() end end
	if IsAddOnLoaded("TukuiMarkBar") and	(mmconfig.openall.Raidmarkbar) then MarkBarBackground:Show() end
	if IsAddOnLoaded("Arh") and 	 		(mmconfig.openall.Arh) then Arh_MainFrame:Show() end
	if IsAddOnLoaded("PhoenixStyle") and	(mmconfig.openall.PhoenixStyle) then PSFmain1:Show() PSFmain2:Show() PSFmain3:Show() end
	if IsAddOnLoaded("Altoholic") and		(mmconfig.openall.Altoholic) then AltoholicFrame:Show() end
end)

-- close all button
close:SetScript("OnMouseDown", function() 
	close:SetBackdropColor(unpack(mmconfig.mouseoverBackdrop))
end)
close:SetScript("OnMouseUp", function()
	if 										(mmconfig.closeall.WorldMap) then	WorldMapFrame:Hide() end
	if 										(mmconfig.closeall.Bags) then		CloseAllBags() end
	if IsAddOnLoaded("VuhDo") and			(mmconfig.closeall.VuhDo) then		SlashCmdList["VUHDO"]("hide") end
	if IsAddOnLoaded("Grid") and	 		(mmconfig.closeall.Grid) then 		GridLayoutFrame:Hide() end -- Grid
	if IsAddOnLoaded("Grid2") and	 		(mmconfig.closeall.Grid) then 		Grid2LayoutFrame:Hide() end -- Grid2
	if IsAddOnLoaded("HealBot") and	 		(mmconfig.closeall.HealBot) then 
												if not HealBot_Options_DisableHealBot:GetChecked() then
													HealBot_Options_DisableHealBot:SetChecked(1)
													HealBot_Options_ToggleHealBot(1) 
												end end
	if IsAddOnLoaded("Numeration") and		(mmconfig.closeall.Numeration) then	NumerationFrame:Hide() end
	if IsAddOnLoaded("Skada") and			(mmconfig.closeall.Skada) then 		Skada:SetActive(enable) end
	if IsAddOnLoaded("Omen") and	 		(mmconfig.closeall.Omen) then 		Omen:Toggle(false) end
	if IsAddOnLoaded("AtlasLoot") and	 	(mmconfig.closeall.Atlas) then 		AtlasLootDefaultFrame:Hide() end
	if IsAddOnLoaded("Recount") and	 		(mmconfig.closeall.Recount) then if Recount.MainWindow:IsShown() then Recount.MainWindow:Hide() end end
	if IsAddOnLoaded("TinyDPS") and		 	(mmconfig.closeall.TinyDPS) then 	tdpsFrame:Hide() end
	if IsAddOnLoaded("DBM-Core") and		(mmconfig.closeall.DBM) then		if DBM_GUI_OptionsFrame then DBM_GUI_OptionsFrame:Hide() end end
	if IsAddOnLoaded("Cascade") and			(mmconfig.closeall.Cascade) then	CascadeFrame:Hide() end
	if IsAddOnLoaded("Tukui_ConfigUI") and	(mmconfig.closeall.TukuiConfig) then
												if not TukuiConfigUI then return
												else TukuiConfigUI:Hide() end end
	if IsAddOnLoaded("ElvUI_ConfigUI") and	(mmconfig.closeall.TukuiConfig) then
												if not ElvuiConfigUI then return
												else ElvuiConfigUI:Hide() end end									
	if IsAddOnLoaded("TukuiMarkBar") and	(mmconfig.closeall.Raidmarkbar) then MarkBarBackground:Hide() end
	if IsAddOnLoaded("Arh") and				(mmconfig.closeall.Arh) then Arh_MainFrame:Hide() end
	if IsAddOnLoaded("PhoenixStyle") and	(mmconfig.closeall.PhoenixStyle) then PSFmain1:Hide() PSFmain2:Hide() PSFmain3:Hide() end
	if IsAddOnLoaded("Altoholic") and		(mmconfig.closeall.Altoholic) then AltoholicFrame:Hide() end
end)

-- mouseover the "m" button
openmenubutton:SetScript("OnEnter", function()
	if not menu:IsShown() then
		UIFrameFadeIn(openmenubutton.texturemo, mmconfig.fadetime, 0, 1)
		UIFrameFadeOut(openmenubutton.texture, mmconfig.fadetime, 1, 0)
	end
end)
openmenubutton:SetScript("OnLeave", function()
	if not menu:IsShown() then
		UIFrameFadeIn(openmenubutton.texture, mmconfig.fadetime, 0, 1)
		UIFrameFadeOut(openmenubutton.texturemo, mmconfig.fadetime, 1, 0)
	end
end)

-- Slash command
SLASH_MMENU1 = "/mmenu"
SLASH_MMENU2 = "/mm"
SlashCmdList["MMENU"] = function(msg)
	if msg == "reset" then
		openmenubutton:ClearAllPoints()
		openmenubutton:SetPoint("CENTER", UIParent, "CENTER", 0,0)
		print(mmconfig.mouseover_text.."mMenu|r "..mmconfig.color_text.."- Position reset!")
	else
		print(mmconfig.mouseover_text.."mMenu|r "..mmconfig.color_text.."- Help:") 
		print(mmconfig.mouseover_text.."-|r "..mmconfig.color_text.."Move while holding Shift.")
		print(mmconfig.mouseover_text.."-|r "..mmconfig.color_text.."Reset position with|r |cff9b9b9b'/mm reset'|r")
	end
end

-- Tukui Datatext
if IsAddOnLoaded("Tukui") then
	local T, C, L = unpack(Tukui)
	if C["datatext"].mmenu and C["datatext"].mmenu > 0 and mmconfig.tukuisupport then
		mMenuList:ClearAllPoints()
		if mmconfig.menudirection then
			mMenuList:SetPoint("TOP", mMenuDatatextButton, "BOTTOM", 0, -4)
		else
			mMenuList:SetPoint("BOTTOM", mMenuDatatextButton, "TOP", 0, 4)
		end
		mMenuOpen:SetPoint("CENTER", mMenuDatatextButton)
		mMenuOpen:SetSize(.1,.1)
		mMenuOpen:SetFrameStrata("BACKGROUND")
		mMenuOpen:SetFrameLevel(0)
		mMenuOpen:SetMovable(false)
	end
end