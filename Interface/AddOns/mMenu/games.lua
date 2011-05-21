-- this frame around the buttons makes it easier for me to manage it and it looks better imo
local gamemenu = CreateFrame("Frame", "mMenuGames", menu)
mMenu.skinbutton(gamemenu)
gamemenu:SetFrameLevel(2)
gamemenu:SetFrameStrata("HIGH")
if mmconfig.menudirection == true then
	gamemenu:SetPoint("TOP", menu, "BOTTOM", 0, -4)
else
	gamemenu:SetPoint("BOTTOM", menu, "TOP", 0, 4)
end
if IsAddOnLoaded("Tukui") and TukuiMinimap.shadow then gamemenu:CreateShadow("Default") end
--------------------------------------------------------------------------------------
local mmenugames = 0 -- Lets go!
--------------------------------------------------------------------------------------
-- Setpoint function
--------------------------------------------------------------------------------------
local function gamesetpoint(f)
	f:ClearAllPoints()
	if mmconfig.menudirection == true then
		if mmenugames == 0 then
			f:SetPoint("TOPLEFT", gamemenu, "TOPLEFT", 2, -2)
		else
			f:SetPoint("TOPLEFT", gamemenu, "TOPLEFT", 2, -((mmenugames * mmconfig.addonbuttonheight) + 2 + (mmenugames*2)))
		end
	else
		if mmenugames == 0 then
			f:SetPoint("BOTTOMLEFT", gamemenu, "BOTTOMLEFT", 2, 2)
		else
			f:SetPoint("BOTTOMLEFT", gamemenu, "BOTTOMLEFT", 2, ((mmenugames * mmconfig.addonbuttonheight) + 2 + (mmenugames*2)))
		end
	end
end
--------------------------------------------------------------------------------------
--- Game Buttons
--------------------------------------------------------------------------------------

-- Tetris --------------------------
if IsAddOnLoaded("Tetris") then
	tetrisbutton = CreateFrame("Frame", "mMenuTetris", gamemenu)
	mMenu.CreateAddonButton(tetrisbutton, "Tetris|r")
	gamesetpoint(tetrisbutton)
	
	--open/close
	tetrisbutton:SetScript("OnMouseDown", function() 
		if not GameTetrisFrame:IsShown() then
			SlashCmdList["TETRIS"]()
		else
			ToggleFrame(GameTetrisFrame)
		end
	end)
	mmenugames = mmenugames + 1
end


-- Bejeweled --------------------------
if IsAddOnLoaded("Bejeweled") then
	bjewbutton = CreateFrame("Frame", "mMenuBejeweled", gamemenu)
	mMenu.CreateAddonButton(bjewbutton, "Bejeweled|r")
	gamesetpoint(bjewbutton)
	
	--open/close
	bjewbutton:SetScript("OnMouseDown", function() ToggleFrame(BejeweledWindow) end)
	
	mmenugames = mmenugames + 1
end

-- hide gamemenu if there are no ..
gamemenu:SetHeight((mmenugames * mmconfig.addonbuttonheight) + (mmenugames * 2) +2)
gamemenu:SetWidth(mmconfig.addonbuttonwidth + 4)

if gamemenu:GetHeight() < mmconfig.addonbuttonheight then gamemenu:Hide() end