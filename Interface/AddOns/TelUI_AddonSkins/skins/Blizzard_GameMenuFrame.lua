if IsAddOnLoaded("Tukui") then return end -- TukUI already has this skinned


Mod_AddonSkins:RegisterSkin("Blizzard_GameMenuFrame",function(Skin,skin,Layout,layout,config)

	-- GameMenuFrame On-Screen position
	Layout.PositionGameMenuFrame = dummy
	GameMenuFrame:HookScript("OnShow",function(self) layout:PositionGameMenuFrame(frame) end)
	
	-- GameMenuFrame Skin
	function Skin:SkinGameMenuFrame(frame)
		-- Skin the dialog and all the buttons
		self:SkinBackgroundFrame(frame)
		self:SkinUIButton(GameMenuButtonOptions)
		self:SkinUIButton(GameMenuButtonSoundOptions)
		self:SkinUIButton(GameMenuButtonUIOptions)
		self:SkinUIButton(GameMenuButtonMacOptions)
		self:SkinUIButton(GameMenuButtonKeybindings)
		self:SkinUIButton(GameMenuButtonMacros)
		self:SkinUIButton(GameMenuButtonRatings)
		self:SkinUIButton(GameMenuButtonLogout)
		self:SkinUIButton(GameMenuButtonQuit)
		self:SkinUIButton(GameMenuButtonContinue)
		-- Replace the header
		if not frame.header then
			frame.header = CreateFrame("Frame",nil,frame)
			local header = frame.header
			self:SkinBackgroundFrame(header)
			header:SetPoint("CENTER",frame,"TOP")
			header:SetSize(GameMenuFrameHeader:GetWidth()-30,config.fontSize+config.buttonSpacing*2)
			-- Header Text
			header.text = header:CreateFontString(nil,"ARTWORK")
			header.text:SetFont(config.font,config.fontSize,config.fontFlags)
			header.text:SetText(MAIN_MENU)
			header.text:SetPoint("CENTER")
			GameMenuFrameHeader:SetTexture(nil)
			select(2,GameMenuFrame:GetRegions()):SetAlpha(0)
		end
	end
	GameMenuFrame:HookScript("OnShow",function(self) skin:SkinGameMenuFrame(self) end)
	
end)