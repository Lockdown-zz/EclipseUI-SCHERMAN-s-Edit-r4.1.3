-- [[ FreeUI functions ]]

local texture = "Interface\\ChatFrame\\ChatFrameBackground"

local classcolors = {
	["HUNTER"] = { r = 0.58, g = 0.86, b = 0.49 },
	["WARLOCK"] = { r = 0.6, g = 0.47, b = 0.85 },
	["PALADIN"] = { r = 1, g = 0.22, b = 0.52 },
	["PRIEST"] = { r = 0.8, g = 0.87, b = .9 },
	["MAGE"] = { r = 0, g = 0.76, b = 1 },
	["ROGUE"] = { r = 1, g = 0.91, b = 0.2 },
	["DRUID"] = { r = 1, g = 0.49, b = 0.04 },
	["SHAMAN"] = { r = 0, g = 0.6, b = 0.6 };
	["WARRIOR"] = { r = 0.9, g = 0.65, b = 0.45 },
	["DEATHKNIGHT"] = { r = 0.77, g = 0.12 , b = 0.23 },
}

Aurora = {
	["backdrop"] = texture,
	["glow"] = "Interface\\AddOns\\Aurora\\glow",
}

Aurora.dummy = function() end

Aurora.CreateBD = function(f, a)
	f:SetBackdrop({
		bgFile = Aurora.backdrop, 
		edgeFile = Aurora.backdrop, 
		edgeSize = 1, 
	})
	f:SetBackdropColor(.04, .04, .04, 0.9)
	f:SetBackdropBorderColor(.07, .07, .07)
end

Aurora.CreateSD = function(parent, size, r, g, b, alpha, offset)
	local sd = CreateFrame("Frame", nil, parent)
	sd.size = size or 5
	sd.offset = offset or 0
	sd:SetBackdrop({
		edgeFile = Aurora.glow,
		edgeSize = sd.size,
	})
	sd:SetPoint("TOPLEFT", parent, -sd.size - 1 - sd.offset, sd.size + 1 + sd.offset)
	sd:SetPoint("BOTTOMRIGHT", parent, sd.size + 1 + sd.offset, -sd.size - 1 - sd.offset)
	sd:SetBackdropBorderColor(r or 0, g or 0, b or 0)
	sd:SetAlpha(alpha or 1)
end

Aurora.CreatePulse = function(frame, speed, mult, alpha) -- pulse function originally by nightcracker
	frame.speed = speed or .05
	frame.mult = mult or 1
	frame.alpha = alpha or 1
	frame.tslu = 0 -- time since last update
	frame:SetScript("OnUpdate", function(self, elapsed)
		self.tslu = self.tslu + elapsed
		if self.tslu > self.speed then
			self.tslu = 0
			self:SetAlpha(self.alpha)
		end
		self.alpha = self.alpha - elapsed*self.mult
		if self.alpha < 0 and self.mult > 0 then
			self.mult = self.mult*-1
			self.alpha = 0
		elseif self.alpha > 1 and self.mult < 0 then
			self.mult = self.mult*-1
		end
	end)
end

-- [[ Addon core ]]

local Skin = CreateFrame("Frame", nil, UIParent)
local _, class = UnitClass("player")
local c
if CUSTOM_CLASS_COLORS then 
	c = CUSTOM_CLASS_COLORS[class]
else
	c = classcolors[class]
end

Aurora.Reskin = function(f)
	local glow = CreateFrame("Frame", nil, f)
	glow:SetBackdrop({
		edgeFile = Aurora.glow,
		edgeSize = 5,
	})
	glow:SetPoint("TOPLEFT", f, -6, 6)
	glow:SetPoint("BOTTOMRIGHT", f, 6, -6)
	glow:SetBackdropBorderColor(c.r, c.g, c.b)
	glow:SetAlpha(0)

	f:SetNormalTexture("")
	f:SetHighlightTexture("")
	f:SetPushedTexture("")
	f:SetDisabledTexture("")

	Aurora.CreateBD(f, .25)

	f:HookScript("OnEnter", function(self) self:SetBackdropBorderColor(c.r, c.g, c.b) self:SetBackdropColor(c.r, c.g, c.b, .1) Aurora.CreatePulse(glow) end)
 	f:HookScript("OnLeave", function(self) self:SetBackdropBorderColor(0, 0, 0) self:SetBackdropColor(0, 0, 0, .25) glow:SetScript("OnUpdate", nil) glow:SetAlpha(0) end)
end

Aurora.CreateTab = function(f)
	local sd = CreateFrame("Frame", nil, f)
	sd:SetBackdrop({
		bgFile = Aurora.backdrop,
		edgeFile = Aurora.glow,
		edgeSize = 5,
		insets = { left = 5, right = 5, top = 5, bottom = 5 },
	})
	sd:SetPoint("TOPLEFT", 6, -2)
	sd:SetPoint("BOTTOMRIGHT", -6, 0)
	sd:SetBackdropColor(0, 0, 0, .5)
	sd:SetBackdropBorderColor(0, 0, 0)
	sd:SetFrameStrata("LOW")

	f:SetHighlightTexture("")
end

local function ReskinScroll(f)
	local frame = f:GetName()

	if _G[frame.."Track"] then _G[frame.."Track"]:Hide() end
	if _G[frame.."BG"] then _G[frame.."BG"]:Hide() end

	local bu = _G[frame.."ThumbTexture"]
	bu:SetAlpha(0)
	bu:SetWidth(17)

	local bg = CreateFrame("Frame", nil, f)
	bg:SetPoint("TOPLEFT", bu, 0, -2)
	bg:SetPoint("BOTTOMRIGHT", bu, 0, 4)
	Aurora.CreateBD(bg, .25)

	local up = _G[frame.."ScrollUpButton"]
	local down = _G[frame.."ScrollDownButton"]

	Aurora.Reskin(up)
	Aurora.Reskin(down)

	up:SetWidth(17)
	down:SetWidth(17)

	local uptex = up:CreateTexture(nil, "OVERLAY")
	uptex:SetTexture("Interface\\AddOns\\Aurora\\arrow-up-active")
	uptex:SetSize(8, 8)
	uptex:SetPoint("CENTER")
	uptex:SetVertexColor(1, 1, 1)

	local downtex = down:CreateTexture(nil, "OVERLAY")
	downtex:SetTexture("Interface\\AddOns\\Aurora\\arrow-down-active")
	downtex:SetSize(16, 16)
	downtex:SetPoint("CENTER")
	downtex:SetVertexColor(1, 1, 1)
end

local function ReskinDropDown(f)
	local frame = f:GetName()

	_G[frame.."Left"]:SetAlpha(0)
	_G[frame.."Middle"]:SetAlpha(0)
	_G[frame.."Right"]:SetAlpha(0)

	local down = _G[frame.."Button"]

	down:SetSize(20, 20)
	down:ClearAllPoints()
	down:SetPoint("RIGHT", -18, 2)

	Aurora.Reskin(down)

	local downtex = down:CreateTexture(nil, "OVERLAY")
	downtex:SetTexture("Interface\\AddOns\\Aurora\\arrow-down-active")
	downtex:SetSize(16, 16)
	downtex:SetPoint("CENTER")
	downtex:SetVertexColor(1, 1, 1)

	local bg = CreateFrame("Frame", nil, f)
	bg:SetPoint("TOPLEFT", 16, -4)
	bg:SetPoint("BOTTOMRIGHT", -18, 8)
	bg:SetFrameLevel(0)
	Aurora.CreateBD(bg, .25)
end

local function ReskinClose(f, a1, p, a2, x, y)
	f:SetSize(17, 17)

	if not a1 then
		f:SetPoint("TOPRIGHT", -4, -4)
	else
		f:ClearAllPoints()
		f:SetPoint(a1, p, a2, x, y)
	end

	f:SetNormalTexture("")
	f:SetHighlightTexture("")
	f:SetPushedTexture("")
	f:SetDisabledTexture("")

	Aurora.CreateBD(f, .25)

	local text = f:CreateFontString(nil, "OVERLAY")
	text:SetFont("Interface\AddOns\Tukui\media\fonts\\combat_font.TTF", 14, "THINOUTLINE")
	text:SetPoint("CENTER", 1, 1)
	text:SetText("x")

	f:HookScript("OnEnter", function(self) text:SetTextColor(1, .1, .1) end)
 	f:HookScript("OnLeave", function(self) text:SetTextColor(1, 1, 1) end)
end

Skin:RegisterEvent("ADDON_LOADED")
Skin:SetScript("OnEvent", function(self, event, addon)	
	if addon == "Aurora" then

		-- [[ Headers ]]

		local header = {"GameMenuFrame", "InterfaceOptionsFrame", "AudioOptionsFrame", "VideoOptionsFrame", "ChatConfigFrame", "ColorPickerFrame"}
		for i = 1, getn(header) do
		local title = _G[header[i].."Header"]
			if title then
				title:SetTexture("")
				title:ClearAllPoints()
				if title == _G["GameMenuFrameHeader"] then
					title:SetPoint("TOP", GameMenuFrame, 0, 7)
				else
					title:SetPoint("TOP", header[i], 0, 0)
				end
			end
		end

		-- [[ Simple backdrops ]]

		local skins = {"AutoCompleteBox", "BNToastFrame", "TicketStatusFrameButton", "DropDownList1Backdrop", "DropDownList2Backdrop", "DropDownList1MenuBackdrop", "DropDownList2MenuBackdrop", "LFDSearchStatus", "FriendsTooltip", "GhostFrame", "GhostFrameContentsFrame", "DropDownList1MenuBackdrop", "DropDownList2MenuBackdrop", "DropDownList1Backdrop", "DropDownList2Backdrop", "GearManagerDialogPopup"}

		for i = 1, getn(skins) do
			Aurora.CreateBD(_G[skins[i]])
		end

		local shadowskins = {"StaticPopup1", "StaticPopup2", "GameMenuFrame", "InterfaceOptionsFrame", "VideoOptionsFrame", "AudioOptionsFrame", "LFDDungeonReadyStatus", "ChatConfigFrame", "SpellBookFrame", "CharacterFrame", "PVPFrame", "WorldStateScoreFrame", "StackSplitFrame", "AddFriendFrame", "FriendsFriendsFrame", "ColorPickerFrame", "ReadyCheckFrame", "PetStableFrame", "LFDDungeonReadyDialog", "ReputationDetailFrame", "LFDRoleCheckPopup", "RaidInfoFrame", "PVPBannerFrame", "RolePollPopup", "LFDParentFrame"}

		for i = 1, getn(shadowskins) do
			Aurora.CreateBD(_G[shadowskins[i]])
			Aurora.CreateSD(_G[shadowskins[i]])
		end

		local simplebds = {"SpellBookCompanionModelFrame", "SecondaryProfession1", "SecondaryProfession2", "SecondaryProfession3", "SecondaryProfession4", "ChatConfigCategoryFrame", "ChatConfigBackgroundFrame", "ChatConfigChatSettingsLeft", "ChatConfigChatSettingsClassColorLegend", "ChatConfigChannelSettingsLeft", "ChatConfigChannelSettingsClassColorLegend", "FriendsFriendsList", "QuestLogCount", "FriendsFrameBroadcastInput", "HelpFrameKnowledgebaseSearchBox", "HelpFrameTicketScrollFrame", "HelpFrameGM_ResponseScrollFrame1", "HelpFrameGM_ResponseScrollFrame2"}
		for i = 1, getn(simplebds) do
			local simplebd = _G[simplebds[i]]
			Aurora.CreateBD(simplebd, .25)
		end

		for i = 1, 5 do
			local tab = _G["SpellBookSkillLineTab"..i]
			local a1, p, a2, x, y = tab:GetPoint()
			local bg = CreateFrame("Frame", nil, tab)
			bg:SetPoint("TOPLEFT", -1, 1)
			bg:SetPoint("BOTTOMRIGHT", 1, -1)
			bg:SetFrameLevel(tab:GetFrameLevel()-1)
			tab:SetPoint(a1, p, a2, x + 11, y)
			Aurora.CreateSD(tab, 5, 0, 0, 0, 1, 1)
			Aurora.CreateBD(bg, 1)
			select(3, tab:GetRegions()):SetTexCoord(.08, .92, .08, .92)
			select(4, tab:GetRegions()):SetTexCoord(.08, .92, .08, .92)
		end

		-- [[ Scroll bars ]]

		local scrollbars = {"FriendsFrameFriendsScrollFrameScrollBar", "QuestLogScrollFrameScrollBar", "QuestLogDetailScrollFrameScrollBar", "CharacterStatsPaneScrollBar", "PVPHonorFrameTypeScrollFrameScrollBar", "PVPHonorFrameInfoScrollFrameScrollBar", "LFDQueueFrameSpecificListScrollFrameScrollBar", "GossipGreetingScrollFrameScrollBar", "HelpFrameKnowledgebaseScrollFrameScrollBar", "HelpFrameTicketScrollFrameScrollBar", "PaperDollTitlesPaneScrollBar", "PaperDollEquipmentManagerPaneScrollBar", "SendMailScrollFrameScrollBar", "OpenMailScrollFrameScrollBar", "RaidInfoScrollFrameScrollBar", "ReputationListScrollFrameScrollBar"}
		for i = 1, getn(scrollbars) do
			bar = _G[scrollbars[i]]
			ReskinScroll(bar)
		end

		-- [[ Dropdowns ]]

		local dropdowns = {"FriendsFrameStatusDropDown", "LFDQueueFrameTypeDropDown", "LFRBrowseFrameRaidDropDown", "WhoFrameDropDown"}
		for i = 1, getn(dropdowns) do
			button = _G[dropdowns[i]]
			ReskinDropDown(button)
		end

		-- [[ Backdrop frames ]]

		FriendsBD = CreateFrame("Frame", nil, FriendsFrame)
		FriendsBD:SetPoint("TOPLEFT", 10, -30)
		FriendsBD:SetPoint("BOTTOMRIGHT", -34, 76)

		QuestBD = CreateFrame("Frame", nil, QuestLogFrame)
		QuestBD:SetPoint("TOPLEFT", 6, -9)
		QuestBD:SetPoint("BOTTOMRIGHT", -2, 6)
		QuestBD:SetFrameLevel(QuestLogFrame:GetFrameLevel()-1)

		QFBD = CreateFrame("Frame", nil, QuestFrame)
		QFBD:SetPoint("TOPLEFT", 6, -15)
		QFBD:SetPoint("BOTTOMRIGHT", -26, 64)
		QFBD:SetFrameLevel(QuestFrame:GetFrameLevel()-1)

		QDBD = CreateFrame("Frame", nil, QuestLogDetailFrame)
		QDBD:SetPoint("TOPLEFT", 6, -9)
		QDBD:SetPoint("BOTTOMRIGHT", 0, 0)
		QDBD:SetFrameLevel(QuestLogDetailFrame:GetFrameLevel()-1)

		GossipBD = CreateFrame("Frame", nil, GossipFrame)
		GossipBD:SetPoint("TOPLEFT", 6, -15)
		GossipBD:SetPoint("BOTTOMRIGHT", -26, 64)

		LFRBD = CreateFrame("Frame", nil, LFRParentFrame)
		LFRBD:SetPoint("TOPLEFT", 10, -10)
		LFRBD:SetPoint("BOTTOMRIGHT", 0, 4)

		MerchBD = CreateFrame("Frame", nil, MerchantFrame)
		MerchBD:SetPoint("TOPLEFT", 10, -10)
		MerchBD:SetPoint("BOTTOMRIGHT", -34, 61)
		MerchBD:SetFrameLevel(MerchantFrame:GetFrameLevel()-1)

		MailBD = CreateFrame("Frame", nil, MailFrame)
		MailBD:SetPoint("TOPLEFT", 10, -12)
		MailBD:SetPoint("BOTTOMRIGHT", -34, 73)

		OMailBD = CreateFrame("Frame", nil, OpenMailFrame)
		OMailBD:SetPoint("TOPLEFT", 10, -12)
		OMailBD:SetPoint("BOTTOMRIGHT", -34, 73)
		OMailBD:SetFrameLevel(OpenMailFrame:GetFrameLevel()-1)

		DressBD = CreateFrame("Frame", nil, DressUpFrame)
		DressBD:SetPoint("TOPLEFT", 10, -10)
		DressBD:SetPoint("BOTTOMRIGHT", -30, 72)
		DressBD:SetFrameLevel(DressUpFrame:GetFrameLevel()-1)

		TaxiBD = CreateFrame("Frame", nil, TaxiFrame)
		TaxiBD:SetPoint("TOPLEFT", 3, -23)
		TaxiBD:SetPoint("BOTTOMRIGHT", -5, 3)
		TaxiBD:SetFrameStrata("LOW")
		TaxiBD:SetFrameLevel(TaxiFrame:GetFrameLevel()-1)

		NPCBD = CreateFrame("Frame", nil, QuestNPCModel)
		NPCBD:SetPoint("TOPLEFT")
		NPCBD:SetPoint("RIGHT")
		NPCBD:SetPoint("BOTTOM", QuestNPCModelTextScrollFrame)
		NPCBD:SetFrameLevel(QuestNPCModel:GetFrameLevel()-1)

		TradeBD = CreateFrame("Frame", nil, TradeFrame)
		TradeBD:SetPoint("TOPLEFT", 10, -12)
		TradeBD:SetPoint("BOTTOMRIGHT", -30, 52)
		TradeBD:SetFrameLevel(TradeFrame:GetFrameLevel()-1)

		ItemBD = CreateFrame("Frame", nil, ItemTextFrame)
		ItemBD:SetPoint("TOPLEFT", 16, -8)
		ItemBD:SetPoint("BOTTOMRIGHT", -28, 62)
		ItemBD:SetFrameLevel(ItemTextFrame:GetFrameLevel()-1)

		TabardBD = CreateFrame("Frame", nil, TabardFrame)
		TabardBD:SetPoint("TOPLEFT", 16, -8)
		TabardBD:SetPoint("BOTTOMRIGHT", -28, 76)
		TabardBD:SetFrameLevel(TabardFrame:GetFrameLevel()-1)

		GMBD = CreateFrame("Frame", nil, HelpFrame)
		GMBD:SetPoint("TOPLEFT")
		GMBD:SetPoint("BOTTOMRIGHT")
		GMBD:SetFrameLevel(HelpFrame:GetFrameLevel()-1)

		local FrameBDs = {"FriendsBD", "QuestBD", "QFBD", "QDBD", "GossipBD", "LFRBD", "MerchBD", "MailBD", "OMailBD", "DressBD", "TaxiBD", "TradeBD", "ItemBD", "TabardBD", "GMBD"}
		for i = 1, getn(FrameBDs) do
			FrameBD = _G[FrameBDs[i]]
			if FrameBD then
				Aurora.CreateBD(FrameBD)
				Aurora.CreateSD(FrameBD)
			end
		end

		Aurora.CreateBD(NPCBD)

		local line = CreateFrame("Frame", nil, QuestNPCModel)
		line:SetPoint("BOTTOMLEFT", 0, -1)
		line:SetPoint("BOTTOMRIGHT", 0, -1)
		line:SetHeight(1)
		line:SetFrameLevel(QuestNPCModel:GetFrameLevel()-1)
		Aurora.CreateBD(line, 0)

		if class == "HUNTER" or class == "MAGE" or class == "DEATHKNIGHT" or class == "WARLOCK" then
			if class == "HUNTER" then
				for i = 1, 10 do
					local bd = CreateFrame("Frame", nil, _G["PetStableStabledPet"..i])
					bd:SetPoint("TOPLEFT", -1, 1)
					bd:SetPoint("BOTTOMRIGHT", 1, -1)
					Aurora.CreateBD(bd)
					bd:SetBackdropColor(0, 0, 0, 0)
					_G["PetStableStabledPet"..i]:SetNormalTexture("")
					_G["PetStableStabledPet"..i]:GetRegions():SetTexCoord(.08, .92, .08, .92)
				end
			end

			PetModelFrameShadowOverlay:Hide()
			PetPaperDollFrameExpBar:GetRegions():Hide()
			select(2, PetPaperDollFrameExpBar:GetRegions()):Hide()

			local bbg = CreateFrame("Frame", nil, PetPaperDollFrameExpBar)
			bbg:SetPoint("TOPLEFT", -1, 1)
			bbg:SetPoint("BOTTOMRIGHT", 1, -1)
			bbg:SetFrameLevel(PetPaperDollFrameExpBar:GetFrameLevel()-1)
			Aurora.CreateBD(bbg, .25)
		end

		PaperDollSidebarTab3:HookScript("OnClick", function()
			for i = 1, 8 do
				local bu = _G["PaperDollEquipmentManagerPaneButton"..i]
				local bd = select(4, bu:GetRegions())
				local ic = select(9, bu:GetRegions())

				bd:Hide()
				bd.Show = Aurora.dummy
				ic:SetTexCoord(.08, .92, .08, .92)

				local f = CreateFrame("Frame", nil, bu)
				f:SetPoint("TOPLEFT", ic, -1, 1)
				f:SetPoint("BOTTOMRIGHT", ic, 1, -1)
				f:SetFrameLevel(bu:GetFrameLevel()-1)
				Aurora.CreateBD(f, 0)
			end
		end)

		GhostFrameContentsFrameIcon:SetTexCoord(.08, .92, .08, .92)

		local GhostBD = CreateFrame("Frame", nil, GhostFrameContentsFrame)
		GhostBD:SetPoint("TOPLEFT", GhostFrameContentsFrameIcon, -1, 1)
		GhostBD:SetPoint("BOTTOMRIGHT", GhostFrameContentsFrameIcon, 1, -1)
		Aurora.CreateBD(GhostBD, 0)

		for i = 1, 7 do
			local bu = _G["MailItem"..i.."Button"]
			local st = _G["MailItem"..i.."ButtonSlot"]
			local ic = _G["MailItem"..i.."Button".."Icon"]

			st:Hide()
			ic:SetTexCoord(.08, .92, .08, .92)

			local bg = CreateFrame("Frame", nil, bu)
			bg:SetPoint("TOPLEFT", -1, 1)
			bg:SetPoint("BOTTOMRIGHT", 1, -1)
			bg:SetFrameLevel(bu:GetFrameLevel()-1)
			Aurora.CreateBD(bg, 0)
		end

		TokenFrame:HookScript("OnShow", function()
			for i=1, GetCurrencyListSize() do
				local button = _G["TokenFrameContainerButton"..i]

				if button then
					button.highlight:SetAlpha(0)
					button.categoryMiddle:SetAlpha(0)	
					button.categoryLeft:SetAlpha(0)	
					button.categoryRight:SetAlpha(0)

					if button.icon then
						button.icon:SetTexCoord(.08, .92, .08, .92)
					end
				end
			end
		end)

		local function UpdateFactionSkins()
			for i=1, GetNumFactions() do
				local statusbar = _G["ReputationBar"..i.."ReputationBar"]

				if statusbar then
					statusbar:SetStatusBarTexture(texture)

					if not statusbar.reskinned then
						Aurora.CreateBD(statusbar, .25)
						statusbar.reskinned = true
					end

					_G["ReputationBar"..i.."Background"]:SetTexture(nil)
					_G["ReputationBar"..i.."LeftLine"]:SetAlpha(0)
					_G["ReputationBar"..i.."BottomLine"]:SetAlpha(0)
					_G["ReputationBar"..i.."ReputationBarHighlight1"]:SetTexture(nil)
					_G["ReputationBar"..i.."ReputationBarHighlight2"]:SetTexture(nil)	
					_G["ReputationBar"..i.."ReputationBarAtWarHighlight1"]:SetTexture(nil)
					_G["ReputationBar"..i.."ReputationBarAtWarHighlight2"]:SetTexture(nil)
					_G["ReputationBar"..i.."ReputationBarLeftTexture"]:SetTexture(nil)
					_G["ReputationBar"..i.."ReputationBarRightTexture"]:SetTexture(nil)
				end		
			end		
		end

		ReputationFrame:HookScript("OnShow", UpdateFactionSkins)
		hooksecurefunc("ReputationFrame_OnEvent", UpdateFactionSkins)

		LFDQueueFrameCapBarProgress:SetTexture(texture)
		LFDQueueFrameCapBarCap1:SetTexture(texture)
		LFDQueueFrameCapBarCap2:SetTexture(texture)

		LFDQueueFrameCapBarLeft:Hide()
		LFDQueueFrameCapBarMiddle:Hide()
		LFDQueueFrameCapBarRight:Hide()
		LFDQueueFrameCapBarBG:SetTexture(nil)

		for i = 1, 6 do
			_G["LFDQueueFrameCapBarDivider"..i]:Hide()
		end

		LFDQueueFrameCapBar.backdrop = CreateFrame("Frame", nil, LFDQueueFrameCapBar)
		LFDQueueFrameCapBar.backdrop:SetPoint("TOPLEFT", LFDQueueFrameCapBar, "TOPLEFT", -1, -2)
		LFDQueueFrameCapBar.backdrop:SetPoint("BOTTOMRIGHT", LFDQueueFrameCapBar, "BOTTOMRIGHT", -1, 2)
		LFDQueueFrameCapBar.backdrop:SetFrameLevel(0)
		Aurora.CreateBD(LFDQueueFrameCapBar.backdrop)

		LFDQueueFrameRandomScrollFrame:SetWidth(304)

		LFDQueueFrameRandom:HookScript("OnShow", function()
			for i = 1, LFD_MAX_REWARDS do
				local button = _G["LFDQueueFrameRandomScrollFrameChildFrameItem"..i]
				local cta = _G["LFDQueueFrameRandomScrollFrameChildFrameItem"..i.."ShortageBorder"]
				local icon = _G["LFDQueueFrameRandomScrollFrameChildFrameItem"..i.."IconTexture"]
				local count = _G["LFDQueueFrameRandomScrollFrameChildFrameItem"..i.."Count"]
				local na = _G["LFDQueueFrameRandomScrollFrameChildFrameItem"..i.."NameFrame"]
				local role1 = _G["LFDQueueFrameRandomScrollFrameChildFrameItem"..i.."RoleIcon1"]
				local role2 = _G["LFDQueueFrameRandomScrollFrameChildFrameItem"..i.."RoleIcon2"]
				local role3 = _G["LFDQueueFrameRandomScrollFrameChildFrameItem"..i.."RoleIcon3"]

				if button then
					icon:SetTexCoord(.08, .92, .08, .92)
					if cta then cta:SetAlpha(0) end
					if not button.bg then
						button.bg = CreateFrame("Frame", nil, button)
						button.bg:SetPoint("TOPLEFT", icon, "TOPLEFT", -1, 1)
						button.bg:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 1, -1)
						button.bg:SetFrameLevel(0)
						Aurora.CreateBD(button.bg)
						icon:SetParent(button.bg)
						icon:SetDrawLayer("OVERLAY")
						count:SetDrawLayer("OVERLAY")
						na:SetTexture(0, 0, 0, .25)
						na:SetSize(118, 39)

						button.bg2 = CreateFrame("Frame", nil, button)
						button.bg2:SetPoint("TOPLEFT", na, "TOPLEFT", 10, 0)
						button.bg2:SetPoint("BOTTOMRIGHT", na, "BOTTOMRIGHT")
						Aurora.CreateBD(button.bg2, 0)

						if count then
							count:SetParent(button.bg)
						end
						if role1 then
							role1:SetParent(button.bg)
						end
						if role2 then
							role2:SetParent(button.bg)
						end
						if role3 then
							role3:SetParent(button.bg)
						end
					end
				end
			end
		end)

		-- Spellbook

		local function SpellButtons(self, first)
			for i = 1, SPELLS_PER_PAGE do
				local button = _G["SpellButton"..i]
				local icon = _G["SpellButton"..i.."IconTexture"]

				if first then
					_G["SpellButton"..i.."Background"]:SetAlpha(0)
					_G["SpellButton"..i.."TextBackground"]:Hide()
					_G["SpellButton"..i.."SlotFrame"]:SetAlpha(0)
					_G["SpellButton"..i.."UnlearnedSlotFrame"]:SetAlpha(0)
				end

				if _G["SpellButton"..i.."Highlight"] then
					_G["SpellButton"..i.."Highlight"]:SetTexture(c.r, c.g, c.b, 0.3)
					_G["SpellButton"..i.."Highlight"]:ClearAllPoints()
					_G["SpellButton"..i.."Highlight"]:SetAllPoints(icon)
				end

				if icon then
					icon:SetTexCoord(.08, .92, .08, .92)
					if not button.bg then
						button.bg = CreateFrame("Frame", nil, button)
						button.bg:SetPoint("TOPLEFT", icon, -1, 1)
						button.bg:SetPoint("BOTTOMRIGHT", icon, 1, -1)
						button.bg:SetFrameLevel(0)
						Aurora.CreateBD(button.bg, 0)	
					end
				end
			end
		end
		SpellButtons(nil, true)
		hooksecurefunc("SpellButton_UpdateButton", SpellButtons)

		-- Professions

		local professionbuttons = {
			"PrimaryProfession1SpellButtonTop",
			"PrimaryProfession1SpellButtonBottom",
			"PrimaryProfession2SpellButtonTop",
			"PrimaryProfession2SpellButtonBottom",
			"SecondaryProfession1SpellButtonLeft",
			"SecondaryProfession1SpellButtonRight",
			"SecondaryProfession2SpellButtonLeft",
			"SecondaryProfession2SpellButtonRight",
			"SecondaryProfession3SpellButtonLeft",
			"SecondaryProfession3SpellButtonRight",
			"SecondaryProfession4SpellButtonLeft",
			"SecondaryProfession4SpellButtonRight",		
		}

		for _, button in pairs(professionbuttons) do
			local icon = _G[button.."IconTexture"]
			local bu = _G[button]
			_G[button.."NameFrame"]:SetAlpha(0)

			if icon then
				icon:SetTexCoord(.08, .92, .08, .92)
				icon:ClearAllPoints()
				icon:SetPoint("TOPLEFT", 2, -2)
				icon:SetPoint("BOTTOMRIGHT", -2, 2)
				if not bu.bg then
					bu.bg = CreateFrame("Frame", nil, bu)
					bu.bg:SetPoint("TOPLEFT", icon, -1, 1)
					bu.bg:SetPoint("BOTTOMRIGHT", icon, 1, -1)
					bu.bg:SetFrameLevel(0)
					Aurora.CreateBD(bu.bg)
				end
			end					
		end

		for i = 1, 2 do
			local bu = _G["PrimaryProfession"..i]
			local bg = CreateFrame("Frame", nil, bu)
			bg:SetPoint("TOPLEFT")
			bg:SetPoint("BOTTOMRIGHT", 0, -4)
			bg:SetFrameLevel(0)
			Aurora.CreateBD(bg, .25)
		end

		-- Mounts and pets

		for i = 1, NUM_COMPANIONS_PER_PAGE do
			local bu = _G["SpellBookCompanionButton"..i]
			local bg = _G["SpellBookCompanionButton"..i.."TextBackground"]
			local ic = _G["SpellBookCompanionButton"..i.."IconTexture"]

			bg:Hide()
			if ic then
				ic:SetTexCoord(.08, .92, .08, .92)

				bu.bd = CreateFrame("Frame", nil, bu)
				bu.bd:SetPoint("TOPLEFT", ic, -1, 1)
				bu.bd:SetPoint("BOTTOMRIGHT", ic, 1, -1)
				Aurora.CreateBD(bu.bd, 0)

				bu:SetCheckedTexture(nil)
			end
		end

		-- Merchant Frame

		for i = 1, 12 do
			local button = _G["MerchantItem"..i]
			local bu = _G["MerchantItem"..i.."ItemButton"]
			local ic = _G["MerchantItem"..i.."ItemButtonIconTexture"]
			local mo = _G["MerchantItem"..i.."MoneyFrame"]

			_G["MerchantItem"..i.."SlotTexture"]:Hide()
			_G["MerchantItem"..i.."NameFrame"]:Hide()
			_G["MerchantItem"..i.."Name"]:SetHeight(20)
			local a1, p, a2= bu:GetPoint()
			bu:SetPoint(a1, p, a2, -2, -2)
			bu:SetNormalTexture("")
			bu:SetSize(40, 40)

			local a3, p2, a4, x, y = mo:GetPoint()
			mo:SetPoint(a3, p2, a4, x, y+2)

			Aurora.CreateBD(bu, 0)

			button.bd = CreateFrame("Frame", nil, button)
			button.bd:SetPoint("TOPLEFT", 39, 0)
			button.bd:SetPoint("BOTTOMRIGHT")
			button.bd:SetFrameLevel(0)
			Aurora.CreateBD(button.bd, .25)

			ic:SetTexCoord(.08, .92, .08, .92)
			ic:ClearAllPoints()
			ic:SetPoint("TOPLEFT", 1, -1)
			ic:SetPoint("BOTTOMRIGHT", -1, 1)
		end

		MerchantBuyBackItemSlotTexture:Hide()
		MerchantBuyBackItemNameFrame:Hide()
		MerchantBuyBackItemItemButton:SetNormalTexture("")

		Aurora.CreateBD(MerchantBuyBackItemItemButton, 0)
		Aurora.CreateBD(MerchantBuyBackItem, .25)

		MerchantBuyBackItemItemButtonIconTexture:SetTexCoord(.08, .92, .08, .92)
		MerchantBuyBackItemItemButtonIconTexture:ClearAllPoints()
		MerchantBuyBackItemItemButtonIconTexture:SetPoint("TOPLEFT", 1, -1)
		MerchantBuyBackItemItemButtonIconTexture:SetPoint("BOTTOMRIGHT", -1, 1)

		-- [[ Hide regions ]]

		CharacterFramePortrait:Hide()
		for i = 1, 5 do
			select(i, CharacterModelFrame:GetRegions()):Hide()
		end
		for i = 1, 3 do
			select(i, QuestLogFrame:GetRegions()):Hide()
			for j = 1, 2 do
				select(i, _G["PVPBannerFrameCustomization"..j]:GetRegions()):Hide()
			end
		end
		QuestLogDetailFrame:GetRegions():Hide()
		QuestFramePortrait:Hide()
		GossipFramePortrait:Hide()
		for i = 1, 6 do
			for j = 1, 3 do
				select(i, _G["FriendsTabHeaderTab"..j]:GetRegions()):Hide()
				select(i, _G["FriendsTabHeaderTab"..j]:GetRegions()).Show = Aurora.dummy
			end
		end
		FriendsFrameTitleText:Hide()
		SpellBookFramePortrait:Hide()
		SpellBookCompanionModelFrameShadowOverlay:Hide()
		PVPFramePortrait:Hide()
		PVPHonorFrameBGTex:Hide()
		LFRParentFrameIcon:Hide()
		for i = 1, 5 do
			select(i, MailFrame:GetRegions()):Hide()
		end
		OpenMailFrameIcon:Hide()
		OpenMailHorizontalBarLeft:Hide()
		select(13, OpenMailFrame:GetRegions()):Hide()
		OpenStationeryBackgroundLeft:Hide()
		OpenStationeryBackgroundRight:Hide()
		for i = 4, 7 do
			select(i, SendMailFrame:GetRegions()):Hide()
		end
		SendStationeryBackgroundLeft:Hide()
		SendStationeryBackgroundRight:Hide()
		MerchantFramePortrait:Hide()
		DressUpFramePortrait:Hide()
		select(2, DressUpFrame:GetRegions()):Hide()
		for i = 8, 11 do
			select(i, DressUpFrame:GetRegions()):Hide()
		end
		TaxiFrameTitleText:Hide()
		TradeFrameRecipientPortrait:Hide()
		TradeFramePlayerPortrait:Hide()
		for i = 1, 4 do
			select(i, GearManagerDialogPopup:GetRegions()):Hide()
		end
		StackSplitFrame:GetRegions():Hide()
		ItemTextFrame:GetRegions():Hide()
		ItemTextScrollFrameMiddle:Hide()
		PetStableFramePortrait:Hide()
		ReputationDetailCorner:Hide()
		ReputationDetailDivider:Hide()
		QuestNPCModelShadowOverlay:Hide()
		TabardFrame:GetRegions():Hide()
		PetStableModelShadow:Hide()
		LFDParentFrameEyeFrame:Hide()
		RaidInfoDetailFooter:Hide()
		RaidInfoDetailHeader:Hide()
		RaidInfoDetailCorner:Hide()
		select(4, RaidInfoFrame:GetRegions()):Hide()
		for i = 1, 9 do
			select(i, QuestLogCount:GetRegions()):Hide()
		end
		for i = 4, 8 do
			select(i, FriendsFrameBroadcastInput:GetRegions()):Hide()
			select(i, HelpFrameKnowledgebaseSearchBox:GetRegions()):Hide()
		end
		select(3, PVPBannerFrame:GetRegions()):Hide()
		for i = 1, 9 do
			select(i, HelpFrame:GetRegions()):Hide()
		end
		HelpFrameHeader:Hide()
		ReadyCheckListenerFrame:GetRegions():SetAlpha(0)
		HelpFrameLeftInset:GetRegions():Hide()
		for i = 10, 13 do
			select(i, HelpFrameLeftInset:GetRegions()):Hide()
		end
		LFDParentFrameRoleBackground:Hide()
		LFDQueueFrameCapBarShadow:Hide()
		LFDQueueFrameBackground:Hide()
		select(4, HelpFrameTicket:GetChildren()):Hide()
		HelpFrameKnowledgebaseStoneTex:Hide()
		HelpFrameKnowledgebaseNavBarOverlay:Hide()
		GhostFrameLeft:Hide()
		GhostFrameRight:Hide()
		GhostFrameMiddle:Hide()
		for i = 3, 6 do
			select(i, GhostFrame:GetRegions()):Hide()
		end
		PaperDollSidebarTabs:GetRegions():Hide()
		select(2, PaperDollSidebarTabs:GetRegions()):Hide()
		select(6, PaperDollEquipmentManagerPaneEquipSet:GetRegions()):Hide()
		select(5, HelpFrameGM_Response:GetChildren()):Hide()
		select(6, HelpFrameGM_Response:GetChildren()):Hide()

		select(2, PVPHonorFrameInfoScrollFrameScrollBar:GetRegions()):Hide()
		select(3, PVPHonorFrameInfoScrollFrameScrollBar:GetRegions()):Hide()
		select(4, PVPHonorFrameInfoScrollFrameScrollBar:GetRegions()):Hide()
		PVPHonorFrameTypeScrollFrame:GetRegions():Hide()
		select(2, PVPHonorFrameTypeScrollFrame:GetRegions()):Hide()

		for i = 1, 6 do
			_G["HelpFrameButton"..i.."Selected"]:SetAlpha(0)
		end

		for i = 1, 12 do
			local bu = "SpellButton"..i
			local ic = _G[bu.."IconTexture"]
			_G[bu.."TextBackground"]:SetAlpha(0)
			_G[bu.."SlotFrame"]:SetAlpha(0)
			_G[bu.."Background"]:SetAlpha(0)
			ic:SetTexCoord(.08, .92, .08, .92)
			ic:SetPoint("TOPLEFT", 1, -1)
			ic:SetPoint("BOTTOMRIGHT", -1, 1)
			Aurora.CreateBD(_G[bu], 0)
		end

		local slots = {
			"Head", "Neck", "Shoulder", "Shirt", "Chest", "Waist", "Legs", "Feet", "Wrist",
			"Hands", "Finger0", "Finger1", "Trinket0", "Trinket1", "Back", "MainHand",
			"SecondaryHand", "Ranged", "Tabard",
		}

		for i = 1, getn(slots) do
			_G["Character"..slots[i].."Slot"]:SetNormalTexture("")
			_G["Character"..slots[i].."Slot"]:GetRegions():SetTexCoord(.08, .92, .08, .92)
			local bd = CreateFrame("Frame", nil, _G["Character"..slots[i].."Slot"])
			bd:SetPoint("TOPLEFT", -1, 1)
			bd:SetPoint("BOTTOMRIGHT", 1, -1)
			Aurora.CreateBD(bd)
			bd:SetBackdropColor(0, 0, 0, 0)
		end

		_G["ReadyCheckFrame"]:HookScript("OnShow", function(self) if UnitIsUnit("player", self.initiator) then self:Hide() end end)

		-- [[ Loot ]]

		if not IsAddOnLoaded("Butsu") and not IsAddOnLoaded("XLoot") then
			LootFramePortraitOverlay:Hide()
			select(3, LootFrame:GetRegions()):Hide()
			LootCloseButton:Hide()

			-- LootFrame:SetWidth(190)
			LootFrame:SetHeight(.001)
			LootFrame:SetHeight(.001)

			local reskinned = 1

			LootFrame:HookScript("OnShow", function()
				for i = reskinned, GetNumLootItems() do
					local bu = _G["LootButton"..i]
					local qu = _G["LootButton"..i.."IconQuestTexture"]
					if not bu then return end
					local _, _, _, _, _, _, _, bg, na = bu:GetRegions()

					-- LootFrame:SetHeight(100 + 37 * i)

					local LootBD = CreateFrame("Frame", nil, bu)
					LootBD:SetFrameLevel(LootFrame:GetFrameLevel()-1)
					LootBD:SetPoint("TOPLEFT", 38, -1)
					LootBD:SetPoint("BOTTOMRIGHT", bu, 170, 1)

					Aurora.CreateBD(LootBD)
					Aurora.CreateBD(bu)

					bu:SetNormalTexture("")
					bu:GetRegions():SetTexCoord(.08, .92, .08, .92)
					bu:GetRegions():SetPoint("TOPLEFT", 1, -1)
					bu:GetRegions():SetPoint("BOTTOMRIGHT", -1, 1)
					bg:Hide()
					qu:SetTexture("Interface\\AddOns\\Aurora\\quest")
					qu:SetVertexColor(1, 0, 0)
					qu:SetTexCoord(.03, .97, .03, .995)
					qu.SetTexture = Aurora.dummy
					na:SetWidth(174)

					reskinned = i + 1
				end
			end)
		end

		-- [[ Bags ]]

		if not IsAddOnLoaded("Baggins") and not IsAddOnLoaded("Stuffing") and not IsAddOnLoaded("Combuctor") and not IsAddOnLoaded("cargBags") and not IsAddOnLoaded("ArkInventory") then
			for i = 1, 5 do
				local con = _G["ContainerFrame"..i]
				for j = 1, 7 do
					select(j, con:GetRegions()):Hide()
					select(j, con:GetRegions()).Show = Aurora.dummy
				end
				for k = 1, MAX_CONTAINER_ITEMS do
					_G["ContainerFrame"..i.."Item"..k]:SetNormalTexture("")
					_G["ContainerFrame"..i.."Item"..k.."IconTexture"]:SetTexCoord(.08, .92, .08, .92)
					_G["ContainerFrame"..i.."Item"..k.."IconQuestTexture"]:SetTexture("Interface\\AddOns\\FreeBags\\border")
					_G["ContainerFrame"..i.."Item"..k.."IconQuestTexture"]:SetVertexColor(1, 0, 0)
					_G["ContainerFrame"..i.."Item"..k.."IconQuestTexture"]:SetTexCoord(0.05, .955, 0.05, .965)
					_G["ContainerFrame"..i.."Item"..k.."IconQuestTexture"].SetTexture = Aurora.dummy
					local bd = CreateFrame("Frame", nil, _G["ContainerFrame"..i.."Item"..k])
					bd:SetPoint("TOPLEFT", -1, 1)
					bd:SetPoint("BOTTOMRIGHT", 1, -1)
					bd:SetFrameLevel(0)
					Aurora.CreateBD(bd, 0)
				end

				local f = CreateFrame("Frame", nil, con)
				f:SetPoint("TOPLEFT", 8, -4)
				f:SetPoint("BOTTOMRIGHT", -4, 3)
				f:SetFrameLevel(con:GetFrameLevel()-1)
				Aurora.CreateBD(f, .6)
			end
		end

		-- [[ Tooltips ]]

		if not IsAddOnLoaded("CowTip") and not IsAddOnLoaded("TipTac") and not IsAddOnLoaded("FreebTip") and not IsAddOnLoaded("lolTip") then
			do
				local tooltips = {
					"GameTooltip",
					"ItemRefTooltip",
					"ShoppingTooltip1",
					"ShoppingTooltip2",
					"ShoppingTooltip3",
					"WorldMapTooltip",
					"ChatMenu",
					"EmoteMenu",
					"LanguageMenu",
					"VoiceMacroMenu",
				}

				for i = 1, #tooltips do
					local t = _G[tooltips[i]]
					t:SetBackdrop(nil)
					local bg = CreateFrame("Frame", nil, t)
					bg:SetBackdrop({ 
						bgFile = Aurora.backdrop, 
						edgeFile = Aurora.backdrop,
						edgeSize = 1,
					})
					bg:SetBackdropColor(0, 0, 0, .6)
					bg:SetBackdropBorderColor(0, 0, 0)
					bg:SetWidth(t:GetWidth())
					bg:SetHeight(t:GetHeight())
					bg:SetPoint("TOPLEFT")
					bg:SetPoint("BOTTOMRIGHT")
					bg:SetFrameStrata("DIALOG")
				end
			end

			local sb = _G["GameTooltipStatusBar"]
			sb:SetHeight(3)
			sb:ClearAllPoints()
			sb:SetPoint("BOTTOMLEFT", GameTooltip, "BOTTOMLEFT", 1, 1)
			sb:SetPoint("BOTTOMRIGHT", GameTooltip, "BOTTOMRIGHT", -1, 1)
		end

		-- [[ Text colour functions ]]

		NORMAL_QUEST_DISPLAY = "|cffffffff%s|r"
		TRIVIAL_QUEST_DISPLAY = "|cffffffff%s (low level)|r"

		GameFontBlackMedium:SetTextColor(1, 1, 1)
		QuestFont:SetTextColor(1, 1, 1)
		MailTextFontNormal:SetTextColor(1, 1, 1)
		InvoiceTextFontNormal:SetTextColor(1, 1, 1)
		InvoiceTextFontSmall:SetTextColor(1, 1, 1)
		SpellBookPageText:SetTextColor(.8, .8, .8)

		local newquestcolor = function(template, parentFrame, acceptButton, material)
			QuestInfoTitleHeader:SetTextColor(1, 1, 1);
			QuestInfoDescriptionHeader:SetTextColor(1, 1, 1);
			QuestInfoObjectivesHeader:SetTextColor(1, 1, 1);
			QuestInfoRewardsHeader:SetTextColor(1, 1, 1);
			-- other text
			QuestInfoDescriptionText:SetTextColor(1, 1, 1);
			QuestInfoObjectivesText:SetTextColor(1, 1, 1);
			QuestInfoGroupSize:SetTextColor(1, 1, 1);
			QuestInfoRewardText:SetTextColor(1, 1, 1);
			-- reward frame text
			QuestInfoItemChooseText:SetTextColor(1, 1, 1);
			QuestInfoItemReceiveText:SetTextColor(1, 1, 1);
			QuestInfoSpellLearnText:SetTextColor(1, 1, 1);		
			QuestInfoXPFrameReceiveText:SetTextColor(1, 1, 1);

			local numObjectives = GetNumQuestLeaderBoards();
			local objective;
			local text, type, finished;
			local numVisibleObjectives = 0;
			for i = 1, numObjectives do
				text, type, finished = GetQuestLogLeaderBoard(i);
				if (type ~= "spell") then
					numVisibleObjectives = numVisibleObjectives+1;
					objective = _G["QuestInfoObjective"..numVisibleObjectives];
					objective:SetTextColor(1, 1, 1);
				end
			end
		end

		local newgossipcolor = function()
			GossipGreetingText:SetTextColor(1, 1, 1)
		end
		function QuestFrame_SetTitleTextColor(fontString)
			fontString:SetTextColor(1, 1, 1)
		end

		function QuestFrame_SetTextColor(fontString)
			fontString:SetTextColor(1, 1, 1);
		end

		function GossipFrameOptionsUpdate(...)
			local titleButton;
			local titleIndex = 1;
			local titleButtonIcon;
			for i=1, select("#", ...), 2 do
				if ( GossipFrame.buttonIndex > NUMGOSSIPBUTTONS ) then
					message("This NPC has too many quests and/or gossip options.");
				end
				titleButton = _G["GossipTitleButton" .. GossipFrame.buttonIndex];
				titleButton:SetFormattedText("|cffffffff%s|r", select(i, ...));
				GossipResize(titleButton);
				titleButton:SetID(titleIndex);
				titleButton.type="Gossip";
				titleButtonIcon = _G[titleButton:GetName() .. "GossipIcon"];
				titleButtonIcon:SetTexture("Interface\\GossipFrame\\" .. select(i+1, ...) .. "GossipIcon");
				titleButtonIcon:SetVertexColor(1, 1, 1, 1);
				GossipFrame.buttonIndex = GossipFrame.buttonIndex + 1;
				titleIndex = titleIndex + 1;
				titleButton:Show();
			end
		end

		local newspellbookcolor = function(self)
			local slot, slotType = SpellBook_GetSpellBookSlot(self);
			local name = self:GetName();
			-- local spellString = _G[name.."SpellName"];
			local subSpellString = _G[name.."SubSpellName"]

			-- spellString:SetTextColor(1, 1, 1)
			subSpellString:SetTextColor(1, 1, 1)
			if slotType == "FUTURESPELL" then
				local level = GetSpellAvailableLevel(slot, SpellBookFrame.bookType)
				if (level and level > UnitLevel("player")) then
					self.RequiredLevelString:SetTextColor(.7, .7, .7)
					self.SpellName:SetTextColor(.7, .7, .7)
					subSpellString:SetTextColor(.7, .7, .7)
				end
			end
		end

		local newprofcolor = function(frame, index)
			if index then
				local rank = GetProfessionInfo(index)
				-- frame.rank:SetTextColor(1, 1, 1)
				frame.professionName:SetTextColor(1, 1, 1)
			else
				frame.missingText:SetTextColor(1, 1, 1)
				frame.missingHeader:SetTextColor(1, 1, 1)
			end
		end

		local newprofbuttoncolor = function(self)
			self.spellString:SetTextColor(1, 1, 1);	
			self.subSpellString:SetTextColor(1, 1, 1)
		end	
	
		ItemTextFrame:HookScript("OnEvent", function(self, event, ...)
			if event == "ITEM_TEXT_BEGIN" then
				ItemTextTitleText:SetText(ItemTextGetItem())
				ItemTextScrollFrame:Hide()
				ItemTextCurrentPage:Hide()
				ItemTextStatusBar:Hide()
				ItemTextPrevPageButton:Hide()
				ItemTextNextPageButton:Hide()
				ItemTextPageText:SetTextColor(1, 1, 1)
				return
			end
		end)

		function PaperDollFrame_SetLevel()
			local primaryTalentTree = GetPrimaryTalentTree()
			local classDisplayName, class = UnitClass("player")
			local classColor = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or classcolors[class]
			local classColorString = format("ff%.2x%.2x%.2x", classColor.r * 255, classColor.g * 255, classColor.b * 255)
			local specName

			if (primaryTalentTree) then
				_, specName = GetTalentTabInfo(primaryTalentTree);
			end

			if (specName and specName ~= "") then
				CharacterLevelText:SetFormattedText(PLAYER_LEVEL, UnitLevel("player"), classColorString, specName, classDisplayName);
			else
				CharacterLevelText:SetFormattedText(PLAYER_LEVEL_NO_SPEC, UnitLevel("player"), classColorString, classDisplayName);
			end
		end

		hooksecurefunc("QuestInfo_Display", newquestcolor)
		hooksecurefunc("GossipFrameUpdate", newgossipcolor)
		hooksecurefunc("SpellButton_UpdateButton", newspellbookcolor)
		hooksecurefunc("FormatProfession", newprofcolor)
		hooksecurefunc("UpdateProfessionButton", newprofbuttoncolor)

		-- [[ Change positions ]]

		ChatConfigFrameDefaultButton:SetWidth(125)
		ChatConfigFrameDefaultButton:ClearAllPoints()
		ChatConfigFrameDefaultButton:SetPoint("TOP", ChatConfigCategoryFrame, "BOTTOM", 0, -4)
		ChatConfigFrameOkayButton:ClearAllPoints()
		ChatConfigFrameOkayButton:SetPoint("TOPRIGHT", ChatConfigBackgroundFrame, "BOTTOMRIGHT", 0, -4)

		_G["VideoOptionsFrameCancel"]:ClearAllPoints()
		_G["VideoOptionsFrameCancel"]:SetPoint("RIGHT",_G["VideoOptionsFrameApply"],"LEFT",-4,0)		 
		_G["VideoOptionsFrameOkay"]:ClearAllPoints()
		_G["VideoOptionsFrameOkay"]:SetPoint("RIGHT",_G["VideoOptionsFrameCancel"],"LEFT",-4,0)	
		_G["AudioOptionsFrameOkay"]:ClearAllPoints()
		_G["AudioOptionsFrameOkay"]:SetPoint("RIGHT",_G["AudioOptionsFrameCancel"],"LEFT",-4,0)		 	 
		_G["InterfaceOptionsFrameOkay"]:ClearAllPoints()
		_G["InterfaceOptionsFrameOkay"]:SetPoint("RIGHT",_G["InterfaceOptionsFrameCancel"],"LEFT", -4,0)

		QuestLogFrameShowMapButton:Hide()
		QuestLogFrameShowMapButton.Show = Aurora.dummy

		local questlogcontrolpanel = function()
			local parent
			if QuestLogFrame:IsShown() then
				parent = QuestLogFrame
				QuestLogControlPanel:SetPoint("BOTTOMLEFT", parent, "BOTTOMLEFT", 9, 6)
			elseif QuestLogDetailFrame:IsShown() then
				parent = QuestLogDetailFrame
				QuestLogControlPanel:SetPoint("BOTTOMLEFT", parent, "BOTTOMLEFT", 9, 0)
			end
		end

		hooksecurefunc("QuestLogControlPanel_UpdatePosition", questlogcontrolpanel)

		QuestLogFramePushQuestButton:ClearAllPoints()
		QuestLogFramePushQuestButton:SetPoint("LEFT", QuestLogFrameAbandonButton, "RIGHT", 1, 0)
		QuestLogFramePushQuestButton:SetWidth(100)
		QuestLogFrameTrackButton:ClearAllPoints()
		QuestLogFrameTrackButton:SetPoint("LEFT", QuestLogFramePushQuestButton, "RIGHT", 1, 0)

		FriendsFrameStatusDropDown:ClearAllPoints()
		FriendsFrameStatusDropDown:SetPoint("TOPLEFT", FriendsFrame, "TOPLEFT", 10, -40)

		RaidFrameConvertToRaidButton:ClearAllPoints()
		RaidFrameConvertToRaidButton:SetPoint("TOPLEFT", FriendsFrame, "TOPLEFT", 30, -44)
		RaidFrameRaidInfoButton:ClearAllPoints()
		RaidFrameRaidInfoButton:SetPoint("TOPRIGHT", FriendsFrame, "TOPRIGHT", -70, -44)

		local a1, p, a2, x, y = ReputationDetailFrame:GetPoint()
		ReputationDetailFrame:SetPoint(a1, p, a2, x + 10, y)

		hooksecurefunc("QuestFrame_ShowQuestPortrait", function(parentFrame, portrait, text, name, x, y)
			QuestNPCModel:SetPoint("TOPLEFT", parentFrame, "TOPRIGHT", x+8, y)
		end)

		PaperDollEquipmentManagerPaneEquipSet:SetWidth(PaperDollEquipmentManagerPaneEquipSet:GetWidth()-1)

		local a3, p2, a4, x2, y2 = PaperDollEquipmentManagerPaneSaveSet:GetPoint()
		PaperDollEquipmentManagerPaneSaveSet:SetPoint(a3, p2, a4, x2 + 1, y2)

		local a5, p3, a6, x3, y3 = GearManagerDialogPopup:GetPoint()
		GearManagerDialogPopup:SetPoint(a5, p3, a6, x3+1, y3)

		DressUpFrameResetButton:ClearAllPoints()
		DressUpFrameResetButton:SetPoint("RIGHT", DressUpFrameCancelButton, "LEFT", -1, 0)

		SendMailMailButton:ClearAllPoints()
		SendMailMailButton:SetPoint("RIGHT", SendMailCancelButton, "LEFT", -1, 0)

		OpenMailDeleteButton:ClearAllPoints()
		OpenMailDeleteButton:SetPoint("RIGHT", OpenMailCancelButton, "LEFT", -1, 0)

		OpenMailReplyButton:ClearAllPoints()
		OpenMailReplyButton:SetPoint("RIGHT", OpenMailDeleteButton, "LEFT", -1, 0)

		HelpFrameTicketScrollFrameScrollBar:SetPoint("TOPLEFT", HelpFrameTicketScrollFrame, "TOPRIGHT", 1, -16)

		RaidInfoFrame:ClearAllPoints()
		RaidInfoFrame:SetPoint("TOPLEFT", FriendsFrame, "TOPRIGHT", -23, -30)
		RaidInfoFrame.SetPoint = Aurora.dummy

		-- [[ Tabs ]]

		for i = 1, 5 do
			Aurora.CreateTab(_G["SpellBookFrameTabButton"..i])
		end

		for i = 1, 4 do
			Aurora.CreateTab(_G["FriendsFrameTab"..i])
			if _G["CharacterFrameTab"..i] then
				Aurora.CreateTab(_G["CharacterFrameTab"..i])
			end
		end

		for i = 1, 3 do
			Aurora.CreateTab(_G["PVPFrameTab"..i])
			Aurora.CreateTab(_G["WorldStateScoreFrameTab"..i])
		end

		for i = 1, 2 do
			Aurora.CreateTab(_G["LFRParentFrameTab"..i])
			Aurora.CreateTab(_G["MerchantFrameTab"..i])
			Aurora.CreateTab(_G["MailFrameTab"..i])
		end

		-- [[ Buttons ]]

		for i = 1, 2 do
			for j = 1, 2 do
				Aurora.Reskin(_G["StaticPopup"..i.."Button"..j])
			end
		end

		local buttons = {"VideoOptionsFrameOkay", "VideoOptionsFrameCancel", "VideoOptionsFrameDefaults", "VideoOptionsFrameApply", "AudioOptionsFrameOkay", "AudioOptionsFrameCancel", "AudioOptionsFrameDefaults", "InterfaceOptionsFrameDefaults", "InterfaceOptionsFrameOkay", "InterfaceOptionsFrameCancel", "ChatConfigFrameOkayButton", "ChatConfigFrameDefaultButton", "DressUpFrameCancelButton", "DressUpFrameResetButton", "WhoFrameWhoButton", "WhoFrameAddFriendButton", "WhoFrameGroupInviteButton", "SendMailMailButton", "SendMailCancelButton", "OpenMailReplyButton", "OpenMailDeleteButton", "OpenMailCancelButton", "OpenMailReportSpamButton", "QuestLogFrameAbandonButton", "QuestLogFramePushQuestButton", "QuestLogFrameTrackButton", "QuestLogFrameCancelButton", "QuestFrameAcceptButton", "QuestFrameDeclineButton", "QuestFrameCompleteQuestButton", "QuestFrameCompleteButton", "QuestFrameGoodbyeButton", "GossipFrameGreetingGoodbyeButton", "QuestFrameGreetingGoodbyeButton", "ChannelFrameNewButton", "RaidFrameRaidInfoButton", "RaidFrameConvertToRaidButton", "TradeFrameTradeButton", "TradeFrameCancelButton", "GearManagerDialogPopupOkay", "GearManagerDialogPopupCancel", "StackSplitOkayButton", "StackSplitCancelButton", "TabardFrameAcceptButton", "TabardFrameCancelButton", "GameMenuButtonHelp", "GameMenuButtonOptions", "GameMenuButtonUIOptions", "GameMenuButtonKeybindings", "GameMenuButtonMacros", "GameMenuButtonLogout", "GameMenuButtonQuit", "GameMenuButtonContinue", "GameMenuButtonMacOptions", "FriendsFrameAddFriendButton", "FriendsFrameSendMessageButton", "LFDQueueFrameFindGroupButton", "LFDQueueFrameCancelButton", "LFRQueueFrameFindGroupButton", "LFRQueueFrameAcceptCommentButton", "PVPFrameLeftButton", "PVPHonorFrameWarGameButton", "PVPFrameRightButton", "RaidFrameNotInRaidRaidBrowserButton", "WorldStateScoreFrameLeaveButton", "SpellBookCompanionSummonButton", "AddFriendEntryFrameAcceptButton", "AddFriendEntryFrameCancelButton", "FriendsFriendsSendRequestButton", "FriendsFriendsCloseButton", "ColorPickerOkayButton", "ColorPickerCancelButton", "FriendsFrameIgnorePlayerButton", "FriendsFrameUnsquelchButton", "LFDDungeonReadyDialogEnterDungeonButton", "LFDDungeonReadyDialogLeaveQueueButton", "LFRBrowseFrameSendMessageButton", "LFRBrowseFrameInviteButton", "LFRBrowseFrameRefreshButton", "LFDRoleCheckPopupAcceptButton", "LFDRoleCheckPopupDeclineButton", "GuildInviteFrameJoinButton", "GuildInviteFrameDeclineButton", "FriendsFramePendingButton1AcceptButton", "FriendsFramePendingButton1DeclineButton", "RaidInfoExtendButton", "RaidInfoCancelButton", "PaperDollEquipmentManagerPaneEquipSet", "PaperDollEquipmentManagerPaneSaveSet", "PVPBannerFrameAcceptButton", "PVPColorPickerButton1", "PVPColorPickerButton2", "PVPColorPickerButton3", "HelpFrameButton1", "HelpFrameButton2", "HelpFrameButton3", "HelpFrameButton4", "HelpFrameButton5", "HelpFrameButton6", "HelpFrameAccountSecurityOpenTicket", "HelpFrameCharacterStuckStuck", "HelpFrameReportLagLoot", "HelpFrameReportLagAuctionHouse", "HelpFrameReportLagMail", "HelpFrameReportLagChat", "HelpFrameReportLagMovement", "HelpFrameReportLagSpell", "HelpFrameReportAbuseOpenTicket", "HelpFrameOpenTicketHelpTopIssues", "HelpFrameOpenTicketHelpOpenTicket", "ReadyCheckFrameYesButton", "ReadyCheckFrameNoButton", "RolePollPopupAcceptButton", "HelpFrameTicketSubmit", "HelpFrameTicketCancel", "HelpFrameKnowledgebaseSearchButton", "GhostFrame", "HelpFrameGM_ResponseNeedMoreHelp", "HelpFrameGM_ResponseCancel", "GMChatOpenLog"}
		for i = 1, getn(buttons) do
		local reskinbutton = _G[buttons[i]]
			if reskinbutton then
				Aurora.Reskin(reskinbutton)
			else
				print("Button "..i.." was not found.")
			end
		end

		Aurora.Reskin(select(6, PVPBannerFrame:GetChildren()))

		local closebuttons = {"LFDParentFrameCloseButton", "CharacterFrameCloseButton", "PVPFrameCloseButton", "SpellBookFrameCloseButton", "HelpFrameCloseButton", "PVPBannerFrameCloseButton", "RaidInfoCloseButton", "ContainerFrame1CloseButton", "ContainerFrame2CloseButton", "ContainerFrame3CloseButton", "ContainerFrame4CloseButton", "ContainerFrame5CloseButton"}
		for i = 1, getn(closebuttons) do
			local closebutton = _G[closebuttons[i]]
			ReskinClose(closebutton)
		end

		ReskinClose(FriendsFrameCloseButton, "LEFT", FriendsFrameBroadcastInput, "RIGHT", 20, 0)
		ReskinClose(QuestLogFrameCloseButton, "TOPRIGHT", QuestLogFrame, "TOPRIGHT", -5, -12)
		ReskinClose(QuestLogDetailFrameCloseButton, "TOPRIGHT", QuestLogDetailFrame, "TOPRIGHT", -5, -11)
		ReskinClose(TaxiFrameCloseButton, "TOPRIGHT", TaxiRouteMap, "TOPRIGHT", -1, -1)
		ReskinClose(InboxCloseButton, "TOPRIGHT", MailFrame, "TOPRIGHT", -38, -16)
		ReskinClose(OpenMailCloseButton, "TOPRIGHT", OpenMailFrame, "TOPRIGHT", -38, -16)
		ReskinClose(GossipFrameCloseButton, "TOPRIGHT", GossipFrame, "TOPRIGHT", -30, -20)
		ReskinClose(MerchantFrameCloseButton, "TOPRIGHT", MerchantFrame, "TOPRIGHT", -38, -14)

		local LFRClose = LFRParentFrame:GetChildren()
		ReskinClose(LFRClose, "TOPRIGHT", LFRParentFrame, "TOPRIGHT", -4, -14)

	-- [[ Load on Demand Addons ]]

	elseif addon == "Blizzard_ArchaeologyUI" then
		Aurora.CreateBD(ArchaeologyFrame)
		Aurora.CreateSD(ArchaeologyFrame)
		Aurora.Reskin(ArchaeologyFrameArtifactPageSolveFrameSolveButton)
		Aurora.Reskin(ArchaeologyFrameArtifactPageBackButton)
		select(3, ArchaeologyFrame:GetRegions()):Hide()
		ArchaeologyFrameSummaryPage:GetRegions():SetTextColor(1, 1, 1)
		ArchaeologyFrameArtifactPage:GetRegions():SetTextColor(1, 1, 1)
		ArchaeologyFrameArtifactPageHistoryScrollChild:GetRegions():SetTextColor(1, 1, 1)
		ArchaeologyFrameHelpPage:GetRegions():SetTextColor(1, 1, 1)
		select(5, ArchaeologyFrameHelpPage:GetRegions()):SetTextColor(1, 1, 1)
		ArchaeologyFrameHelpPageHelpScrollHelpText:SetTextColor(1, 1, 1)
		ArchaeologyFrameCompletedPage:GetRegions():SetTextColor(1, 1, 1)
		select(2, ArchaeologyFrameCompletedPage:GetRegions()):SetTextColor(1, 1, 1)
		select(5, ArchaeologyFrameCompletedPage:GetRegions()):SetTextColor(1, 1, 1)
		select(8, ArchaeologyFrameCompletedPage:GetRegions()):SetTextColor(1, 1, 1)
		select(11, ArchaeologyFrameCompletedPage:GetRegions()):SetTextColor(1, 1, 1)

		for i = 1, 10 do
			_G["ArchaeologyFrameSummaryPageRace"..i]:GetRegions():SetTextColor(1, 1, 1)
		end
		for i = 1, ARCHAEOLOGY_MAX_COMPLETED_SHOWN do
			local bu = _G["ArchaeologyFrameCompletedPageArtifact"..i]
			bu:GetRegions():Hide()
			select(2, bu:GetRegions()):Hide()
			select(3, bu:GetRegions()):SetTexCoord(.08, .92, .08, .92)
			select(4, bu:GetRegions()):SetTextColor(1, 1, 1)
			select(5, bu:GetRegions()):SetTextColor(1, 1, 1)
			local bg = CreateFrame("Frame", nil, bu)
			bg:SetPoint("TOPLEFT", -1, 1)
			bg:SetPoint("BOTTOMRIGHT", 1, -1)
			bg:SetFrameLevel(bu:GetFrameLevel()-1)
			Aurora.CreateBD(bg, .25)
			local vline = CreateFrame("Frame", nil, bu)
			vline:SetPoint("LEFT", 44, 0)
			vline:SetSize(1, 44)
			Aurora.CreateBD(vline)
		end

		ReskinDropDown(ArchaeologyFrameRaceFilter)
		ReskinClose(ArchaeologyFrameCloseButton)

		ArchaeologyFrameRankBarBorder:Hide()
		ArchaeologyFrameRankBarBackground:Hide()
		ArchaeologyFrameRankBarBar:SetTexture(C.media.texture)
		ArchaeologyFrameRankBar:SetHeight(14)
		Aurora.CreateBD(ArchaeologyFrameRankBar, .25)

		ArchaeologyFrameArtifactPageSolveFrameStatusBarBarBG:Hide()
		local bar = select(3, ArchaeologyFrameArtifactPageSolveFrameStatusBar:GetRegions())
		bar:SetTexture(texture)
		bar:SetVertexColor(.65, .25, 0)

		local bg = CreateFrame("Frame", nil, ArchaeologyFrameArtifactPageSolveFrameStatusBar)
		bg:SetPoint("TOPLEFT", -1, 1)
		bg:SetPoint("BOTTOMRIGHT", 1, -1)
		bg:SetFrameLevel(0)
		Aurora.CreateBD(bg, .25)
	elseif addon == "Blizzard_AuctionUI" then
		local AuctionBD = CreateFrame("Frame", nil, AuctionFrame)
		AuctionBD:SetPoint("TOPLEFT", 2, -10)
		AuctionBD:SetPoint("BOTTOMRIGHT", 0, 10)
		AuctionBD:SetFrameStrata("MEDIUM")
		Aurora.CreateBD(AuctionBD)
		Aurora.CreateSD(AuctionBD)
		Aurora.CreateBD(AuctionProgressFrame)
		Aurora.CreateSD(AuctionProgressFrame)
		AuctionDressUpFrame:ClearAllPoints()
		AuctionDressUpFrame:SetPoint("LEFT", AuctionFrame, "RIGHT", -3, 0)
		Aurora.CreateBD(AuctionDressUpModel)
		Aurora.CreateBD(BrowseName, .25)

		local ABBD = CreateFrame("Frame", nil, AuctionProgressBar)
		ABBD:SetPoint("TOPLEFT", -1, 1)
		ABBD:SetPoint("BOTTOMRIGHT", 1, -1)
		ABBD:SetFrameLevel(AuctionProgressBar:GetFrameLevel()-1)
		Aurora.CreateBD(ABBD, .25)

		AuctionFrame:GetRegions():Hide()
		for i = 1, 4 do
			select(i, AuctionProgressFrame:GetRegions()):Hide()
		end
		select(2, AuctionProgressBar:GetRegions()):Hide()
		for i = 1, 4 do
			select(i, AuctionDressUpFrame:GetRegions()):Hide()
		end
		for i = 4, 8 do
			select(i, BrowseName:GetRegions()):Hide()
		end

		for i = 1, 3 do
			Aurora.CreateTab(_G["AuctionFrameTab"..i])
		end

		local abuttons = {"BrowseBidButton", "BrowseBuyoutButton", "BrowseCloseButton", "BrowseSearchButton", "BrowseResetButton", "BidBidButton", "BidBuyoutButton", "BidCloseButton", "AuctionsCloseButton", "AuctionDressUpFrameResetButton", "AuctionsCancelAuctionButton", "AuctionsCreateAuctionButton", "AuctionsNumStacksMaxButton", "AuctionsStackSizeMaxButton"}
		for i = 1, getn(abuttons) do
			local reskinbutton = _G[abuttons[i]]
			if reskinbutton then
				Aurora.Reskin(reskinbutton)
			end
		end

		BrowseCloseButton:ClearAllPoints()
		BrowseCloseButton:SetPoint("BOTTOMRIGHT", AuctionFrameBrowse, "BOTTOMRIGHT", 66, 13)
		BrowseBuyoutButton:ClearAllPoints()
		BrowseBuyoutButton:SetPoint("RIGHT", BrowseCloseButton, "LEFT", -1, 0)
		BrowseBidButton:ClearAllPoints()
		BrowseBidButton:SetPoint("RIGHT", BrowseBuyoutButton, "LEFT", -1, 0)
		BidBuyoutButton:ClearAllPoints()
		BidBuyoutButton:SetPoint("RIGHT", BidCloseButton, "LEFT", -1, 0)
		BidBidButton:ClearAllPoints()
		BidBidButton:SetPoint("RIGHT", BidBuyoutButton, "LEFT", -1, 0)
		AuctionsCancelAuctionButton:ClearAllPoints()
		AuctionsCancelAuctionButton:SetPoint("RIGHT", AuctionsCloseButton, "LEFT", -1, 0)

		for i = 1, 8 do
			local bu = _G["BrowseButton"..i]
			local it = _G["BrowseButton"..i.."Item"]
			local ic = _G["BrowseButton"..i.."ItemIconTexture"]

			it:SetNormalTexture("")
			ic:SetTexCoord(.08, .92, .08, .92)

			local bg = CreateFrame("Frame", nil, it)
			bg:SetPoint("TOPLEFT", -1, 1)
			bg:SetPoint("BOTTOMRIGHT", 1, -1)
			bg:SetFrameLevel(it:GetFrameLevel()-1)
			Aurora.CreateBD(bg, 0)

			_G["BrowseButton"..i.."Left"]:Hide()
			select(6, _G["BrowseButton"..i]:GetRegions()):Hide()
			_G["BrowseButton"..i.."Right"]:Hide()

			local bd = CreateFrame("Frame", nil, bu)
			bd:SetPoint("TOPLEFT")
			bd:SetPoint("BOTTOMRIGHT", 0, 5)
			bd:SetFrameLevel(bu:GetFrameLevel()-1)
			Aurora.CreateBD(bd, .25)

			bu:SetHighlightTexture(texture)
			local hl = bu:GetHighlightTexture()
			hl:SetVertexColor(c.r, c.g, c.b, .2)
			hl:ClearAllPoints()
			hl:SetPoint("TOPLEFT", 0, -1)
			hl:SetPoint("BOTTOMRIGHT", -1, 6)
		end

		ReskinClose(AuctionFrameCloseButton, "TOPRIGHT", AuctionFrame, "TOPRIGHT", -4, -14)
		ReskinClose(AuctionDressUpFrameCloseButton, "TOPRIGHT", AuctionDressUpModel, "TOPRIGHT", -4, -4)
		ReskinScroll(BrowseScrollFrameScrollBar)
		ReskinScroll(AuctionsScrollFrameScrollBar)
		ReskinScroll(BrowseFilterScrollFrameScrollBar)
		ReskinDropDown(PriceDropDown)
		ReskinDropDown(DurationDropDown)
	elseif addon == "Blizzard_AchievementUI" then
		Aurora.CreateBD(AchievementFrame)
		Aurora.CreateSD(AchievementFrame)
		AchievementFrameCategories:SetBackdrop(nil)
		AchievementFrameSummary:SetBackdrop(nil)
		for i = 1, 13 do
			select(i, AchievementFrame:GetRegions()):Hide()
		end
		AchievementFrameSummaryBackground:Hide()
		AchievementFrameSummary:GetChildren():Hide()
		for i = 1, 4 do
			select(i, AchievementFrameHeader:GetRegions()):Hide()
		end
		AchievementFrameHeader:ClearAllPoints()
		AchievementFrameHeader:SetPoint("TOP", AchievementFrame, "TOP", 0, 40)
		AchievementFrameFilterDropDown:ClearAllPoints()
		AchievementFrameFilterDropDown:SetPoint("RIGHT", AchievementFrameHeader, "RIGHT", -120, -1)

		for i = 1, 3 do
			if _G["AchievementFrameTab"..i] then
				for j = 1, 9 do
					select(j, _G["AchievementFrameTab"..i]:GetRegions()):Hide()
					select(j, _G["AchievementFrameTab"..i]:GetRegions()).Show = Aurora.dummy
				end
				local sd = CreateFrame("Frame", nil, _G["AchievementFrameTab"..i])
				sd:SetPoint("TOPLEFT", 6, -4)
				sd:SetPoint("BOTTOMRIGHT", -6, -2)
				sd:SetFrameStrata("LOW")
				sd:SetBackdrop({
					bgFile = Aurora.backdrop,
					edgeFile = Aurora.glow,
					edgeSize = 5,
					insets = { left = 5, right = 5, top = 5, bottom = 5 },
				})
				sd:SetBackdropColor(0, 0, 0, .5)
				sd:SetBackdropBorderColor(0, 0, 0)
			end
		end

		ReskinClose(AchievementFrameCloseButton)
		ReskinScroll(AchievementFrameAchievementsContainerScrollBar)
		ReskinScroll(AchievementFrameStatsContainerScrollBar)
	elseif addon == "Blizzard_BindingUI" then
		local BindingBD = CreateFrame("Frame", nil, KeyBindingFrame)
		BindingBD:SetPoint("TOPLEFT", 2, 0)
		BindingBD:SetPoint("BOTTOMRIGHT", -38, 10)
		BindingBD:SetFrameLevel(KeyBindingFrame:GetFrameLevel()-1)
		Aurora.CreateBD(BindingBD)
		Aurora.CreateSD(BindingBD)
		KeyBindingFrameHeader:SetTexture("")
		Aurora.Reskin(KeyBindingFrameDefaultButton)
		Aurora.Reskin(KeyBindingFrameUnbindButton)
		Aurora.Reskin(KeyBindingFrameOkayButton)
		Aurora.Reskin(KeyBindingFrameCancelButton)
		KeyBindingFrameOkayButton:ClearAllPoints()
		KeyBindingFrameOkayButton:SetPoint("RIGHT", KeyBindingFrameCancelButton, "LEFT", -1, 0)
		KeyBindingFrameUnbindButton:ClearAllPoints()
		KeyBindingFrameUnbindButton:SetPoint("RIGHT", KeyBindingFrameOkayButton, "LEFT", -1, 0)
		ReskinScroll(KeyBindingFrameScrollFrameScrollBar)
	elseif addon == "Blizzard_Calendar" then
		for i = 1, 15 do
			if i ~= 10 and i ~= 11 and i ~= 12 and i ~= 13 and i ~= 14 then select(i, CalendarViewEventFrame:GetRegions()):Hide() end
		end
		for i = 1, 9 do
			select(i, CalendarViewHolidayFrame:GetRegions()):Hide()
			select(i, CalendarViewRaidFrame:GetRegions()):Hide()
		end
		for i = 1, 3 do
			select(i, CalendarViewEventTitleFrame:GetRegions()):Hide()
			select(i, CalendarViewHolidayTitleFrame:GetRegions()):Hide()
			select(i, CalendarViewRaidTitleFrame:GetRegions()):Hide()
		end
		CalendarViewEventInviteListSection:GetRegions():Hide()
		CalendarViewEventInviteList:GetRegions():Hide()
		CalendarViewEventDescriptionContainer:GetRegions():Hide()
		select(5, CalendarViewEventCloseButton:GetRegions()):Hide()
		select(5, CalendarViewHolidayCloseButton:GetRegions()):Hide()
		select(5, CalendarViewRaidCloseButton:GetRegions()):Hide()
		local CalBD = CreateFrame("Frame", nil, CalendarFrame)
		CalBD:SetPoint("TOPLEFT", 11, 0)
		CalBD:SetPoint("BOTTOMRIGHT", -9, 3)
		CalBD:SetFrameStrata("MEDIUM")
		Aurora.CreateBD(CalBD)
		Aurora.CreateSD(CalBD)
		Aurora.CreateBD(CalendarViewEventFrame)
		Aurora.CreateSD(CalendarViewEventFrame)
		Aurora.CreateBD(CalendarViewHolidayFrame)
		Aurora.CreateSD(CalendarViewHolidayFrame)
		Aurora.CreateBD(CalendarViewRaidFrame)
		Aurora.CreateSD(CalendarViewRaidFrame)
		Aurora.CreateBD(CalendarViewEventInviteList, .25)
		Aurora.CreateBD(CalendarViewEventDescriptionContainer, .25)
		-- No, I don't have a better way to do this
		for i = 1, 6 do
			local vline = CreateFrame("Frame", nil, _G["CalendarDayButton"..i])
			vline:SetHeight(546)
			vline:SetWidth(1)
			vline:SetPoint("TOP", _G["CalendarDayButton"..i], "TOPRIGHT")
			Aurora.CreateBD(vline)
		end
		for i = 1, 36, 7 do
			local hline = CreateFrame("Frame", nil, _G["CalendarDayButton"..i])
			hline:SetWidth(637)
			hline:SetHeight(1)
			hline:SetPoint("LEFT", _G["CalendarDayButton"..i], "TOPLEFT")
			Aurora.CreateBD(hline)
		end
		local cbuttons = { "CalendarViewEventAcceptButton", "CalendarViewEventTentativeButton", "CalendarViewEventDeclineButton", "CalendarViewEventRemoveButton" }
		for i = 1, getn(cbuttons) do
		local cbutton = _G[cbuttons[i]]
			if cbutton then
				Aurora.Reskin(cbutton)
			end
		end

		ReskinClose(CalendarCloseButton, "TOPRIGHT", CalBD, "TOPRIGHT", -4, -4)
	elseif addon == "Blizzard_DebugTools" then
		ScriptErrorsFrame:SetScale(UIParent:GetScale())
		ScriptErrorsFrame:SetSize(386, 274)
		Aurora.CreateBD(ScriptErrorsFrame)
		Aurora.CreateSD(ScriptErrorsFrame)
		ReskinClose(ScriptErrorsFrameClose)
		ReskinScroll(ScriptErrorsFrameScrollFrameScrollBar)
		Aurora.Reskin(select(4, ScriptErrorsFrame:GetChildren()))
		Aurora.Reskin(select(5, ScriptErrorsFrame:GetChildren()))
		Aurora.Reskin(select(6, ScriptErrorsFrame:GetChildren()))
	elseif addon == "Blizzard_GlyphUI" then
		Aurora.CreateBD(GlyphFrameSearchBox, .25)
		GlyphFrameBackground:Hide()
		GlyphFrameSideInsetBackground:Hide()
		for i = 4, 8 do
			select(i, GlyphFrameSearchBox:GetRegions()):Hide()
		end

		ReskinScroll(GlyphFrameScrollFrameScrollBar)
		ReskinDropDown(GlyphFrameFilterDropDown)
	elseif addon == "Blizzard_GMSurveyUI" then
		local f = CreateFrame("Frame", nil, GMSurveyFrame)
		f:SetPoint("TOPLEFT")
		f:SetPoint("BOTTOMRIGHT", -32, 4)
		f:SetFrameLevel(GMSurveyFrame:GetFrameLevel()-1)
		Aurora.CreateBD(f)
		Aurora.CreateSD(f)

		Aurora.CreateBD(GMSurveyCommentFrame, .25)

		for i = 1, 11 do
			select(i, GMSurveyFrame:GetRegions()):Hide()
		end
		for i = 1, 11 do
			Aurora.CreateBD(_G["GMSurveyQuestion"..i], .25)
		end
		for i = 1, 3 do
			select(i, GMSurveyHeader:GetRegions()):Hide()
		end

		Aurora.Reskin(GMSurveySubmitButton)
		Aurora.Reskin(GMSurveyCancelButton)
	elseif addon == "Blizzard_GuildBankUI" then
		local f = CreateFrame("Frame", nil, GuildBankFrame)
		f:SetPoint("TOPLEFT", 10, -8)
		f:SetPoint("BOTTOMRIGHT", 0, 6)
		f:SetFrameLevel(GuildBankFrame:GetFrameLevel()-1)
		Aurora.CreateBD(f)
		Aurora.CreateSD(f)

		GuildBankEmblemFrame:Hide()
		for i = 1, 4 do
			Aurora.CreateTab(_G["GuildBankFrameTab"..i])
		end
		Aurora.Reskin(GuildBankFrameWithdrawButton)
		Aurora.Reskin(GuildBankFrameDepositButton)

		GuildBankFrameWithdrawButton:ClearAllPoints()
		GuildBankFrameWithdrawButton:SetPoint("RIGHT", GuildBankFrameDepositButton, "LEFT", -1, 0)

		for i = 1, 7 do
			for j = 1, 14 do
				local co = _G["GuildBankColumn"..i]
				local bu = _G["GuildBankColumn"..i.."Button"..j]
				local ic = _G["GuildBankColumn"..i.."Button"..j.."IconTexture"]
				local nt = _G["GuildBankColumn"..i.."Button"..j.."NormalTexture"]

				co:GetRegions():Hide()
				ic:SetTexCoord(.08, .92, .08, .92)
				nt:SetAlpha(0)

				local bg = CreateFrame("Frame", nil, bu)
				bg:SetPoint("TOPLEFT", -1, 1)
				bg:SetPoint("BOTTOMRIGHT", 1, -1)
				bg:SetFrameLevel(bu:GetFrameLevel()-1)
				Aurora.CreateBD(bg, 0)
			end
		end

		for i = 1, 8 do
			local tb = _G["GuildBankTab"..i]
			local bu = _G["GuildBankTab"..i.."Button"]
			local ic = _G["GuildBankTab"..i.."ButtonIconTexture"]
			local nt = _G["GuildBankTab"..i.."ButtonNormalTexture"]

			local bg = CreateFrame("Frame", nil, bu)
			bg:SetPoint("TOPLEFT", -1, 1)
			bg:SetPoint("BOTTOMRIGHT", 1, -1)
			bg:SetFrameLevel(bu:GetFrameLevel()-1)
			Aurora.CreateBD(bg, 1)
			Aurora.CreateSD(bu, 5, 0, 0, 0, 1, 1)

			local a1, p, a2, x, y = bu:GetPoint()
			bu:SetPoint(a1, p, a2, x + 11, y)

			ic:SetTexCoord(.08, .92, .08, .92)
			tb:GetRegions():Hide()
			nt:SetAlpha(0)
		end

		local GuildBankClose = select(14, GuildBankFrame:GetChildren())
		ReskinClose(GuildBankClose, "TOPRIGHT", GuildBankFrame, "TOPRIGHT", -4, -12)
	elseif addon == "Blizzard_GuildUI" then
		Aurora.CreateBD(GuildFrame)
		Aurora.CreateSD(GuildFrame)
		Aurora.CreateBD(GuildMemberDetailFrame)
		Aurora.CreateSD(GuildMemberDetailFrame)
		Aurora.CreateBD(GuildMemberNoteBackground, .25)
		Aurora.CreateBD(GuildMemberOfficerNoteBackground, .25)
		Aurora.CreateBD(GuildLogFrame)
		Aurora.CreateSD(GuildLogFrame)
		Aurora.CreateBD(GuildLogContainer, .25)
		Aurora.CreateBD(GuildNewsFiltersFrame)
		Aurora.CreateSD(GuildNewsFiltersFrame)
		Aurora.CreateBD(GuildTextEditFrame)
		Aurora.CreateSD(GuildTextEditFrame)
		Aurora.CreateBD(GuildTextEditContainer, .25)
		for i = 1, 5 do
			Aurora.CreateTab(_G["GuildFrameTab"..i])
		end
		select(18, GuildFrame:GetRegions()):Hide()
		select(21, GuildFrame:GetRegions()):Hide()
		select(22, GuildFrame:GetRegions()):Hide()
		select(5, GuildInfoFrameInfo:GetRegions()):Hide()
		select(11, GuildMemberDetailFrame:GetRegions()):Hide()
		select(12, GuildMemberDetailFrame:GetRegions()):Hide()
		for i = 1, 9 do
			select(i, GuildLogFrame:GetRegions()):Hide()
			select(i, GuildNewsFiltersFrame:GetRegions()):Hide()
			select(i, GuildTextEditFrame:GetRegions()):Hide()
		end
		select(2, GuildNewPerksFrame:GetRegions()):Hide()
		select(3, GuildNewPerksFrame:GetRegions()):Hide()
		GuildAllPerksFrame:GetRegions():Hide()
		GuildNewsFrame:GetRegions():Hide()
		GuildRewardsFrame:GetRegions():Hide()
		select(2, GuildNewsBossModel:GetRegions()):Hide()
		GuildPerksToggleButtonLeft:Hide()
		GuildPerksToggleButtonMiddle:Hide()
		GuildPerksToggleButtonRight:Hide()
		GuildPerksToggleButtonHighlightLeft:Hide()
		GuildPerksToggleButtonHighlightMiddle:Hide()
		GuildPerksToggleButtonHighlightRight:Hide()
		GuildPerksContainerScrollBarTrack:Hide()
		GuildNewPerksFrameHeader1:Hide()
		GuildNewsContainerScrollBarTrack:Hide()
		GuildInfoDetailsFrameScrollBarTrack:Hide()
		GuildInfoFrameInfoHeader1:SetAlpha(0)
		GuildInfoFrameInfoHeader2:SetAlpha(0)
		GuildInfoFrameInfoHeader3:SetAlpha(0)
		GuildInfoChallengesDungeonTexture:SetAlpha(0)
		GuildInfoChallengesRaidTexture:SetAlpha(0)
		GuildInfoChallengesRatedBGTexture:SetAlpha(0)


		GuildMemberRankDropdown:HookScript("OnShow", function()
			GuildMemberDetailRankText:Hide()
		end)
		GuildMemberRankDropdown:HookScript("OnHide", function()
			GuildMemberDetailRankText:Show()
		end)

		ReskinClose(GuildFrameCloseButton)
		ReskinClose(GuildNewsFiltersFrameCloseButton)
		ReskinClose(GuildLogFrameCloseButton)
		ReskinScroll(GuildPerksContainerScrollBar)
		ReskinScroll(GuildRosterContainerScrollBar)
		ReskinScroll(GuildNewsContainerScrollBar)
		ReskinScroll(GuildRewardsContainerScrollBar)
		ReskinScroll(GuildInfoDetailsFrameScrollBar)
		ReskinScroll(GuildLogScrollFrameScrollBar)
		ReskinDropDown(GuildRosterViewDropdown)
		ReskinDropDown(GuildMemberRankDropdown)

		local a1, p, a2, x, y = GuildNewsBossModel:GetPoint()
		GuildNewsBossModel:ClearAllPoints()
		GuildNewsBossModel:SetPoint(a1, p, a2, x+5, y)

		local f = CreateFrame("Frame", nil, GuildNewsBossModel)
		f:SetPoint("TOPLEFT")
		f:SetPoint("BOTTOMRIGHT", 0, -52)
		f:SetFrameLevel(GuildNewsBossModel:GetFrameLevel()-1)
		Aurora.CreateBD(f)

		local line = CreateFrame("Frame", nil, GuildNewsBossModel)
		line:SetPoint("BOTTOMLEFT", 0, -1)
		line:SetPoint("BOTTOMRIGHT", 0, -1)
		line:SetHeight(1)
		line:SetFrameLevel(GuildNewsBossModel:GetFrameLevel()-1)
		Aurora.CreateBD(line, 0)

		GuildNewsFiltersFrame:ClearAllPoints()
		GuildNewsFiltersFrame:SetPoint("TOPLEFT", GuildFrame, "TOPRIGHT", 10, -10)
		GuildMemberDetailFrame:ClearAllPoints()
		GuildMemberDetailFrame:SetPoint("TOPLEFT", GuildFrame, "TOPRIGHT", 10, -10)

		for i = 1, 5 do
			local bu = _G["GuildInfoFrameApplicantsContainerButton"..i]
			Aurora.CreateBD(bu, .25)
			bu:SetHighlightTexture("")
			bu:GetRegions():SetTexture(texture)
			bu:GetRegions():SetVertexColor(c.r, c.g, c.b, .2)
		end

		GuildFactionBarProgress:SetTexture(texture)
		GuildFactionBarLeft:Hide()
		GuildFactionBarMiddle:Hide()
		GuildFactionBarRight:Hide()
		GuildFactionBarShadow:Hide()
		GuildFactionBarBG:Hide()
		GuildFactionBarCap:SetAlpha(0)
		GuildFactionBar.bg = CreateFrame("Frame", nil, GuildFactionFrame)
		GuildFactionBar.bg:SetPoint("TOPLEFT", GuildFactionFrame, -1, -1)
		GuildFactionBar.bg:SetPoint("BOTTOMRIGHT", GuildFactionFrame, -3, 0)
		GuildFactionBar.bg:SetFrameLevel(0)
		Aurora.CreateBD(GuildFactionBar.bg, .25)

		GuildXPFrame:ClearAllPoints()
		GuildXPFrame:SetPoint("TOP", GuildFrame, "TOP", 0, -40)
		GuildXPBarProgress:SetTexture(texture)
		GuildXPBarLeft:Hide()
		GuildXPBarRight:Hide()
		GuildXPBarMiddle:Hide()
		GuildXPBarBG:Hide()
		GuildXPBarShadow:SetAlpha(0)
		GuildXPBarCap:SetAlpha(0)
		for i = 1, 4 do
			_G["GuildXPBarDivider"..i]:Hide()
		end
		GuildXPBar.bg = CreateFrame("Frame", nil, GuildXPBar)
		GuildXPBar.bg:SetPoint("TOPLEFT", GuildXPFrame)
		GuildXPBar.bg:SetPoint("BOTTOMRIGHT", GuildXPFrame, 0, 4)
		GuildXPBar.bg:SetFrameLevel(0)
		Aurora.CreateBD(GuildXPBar.bg, .25)

		local perkbuttons = {"GuildLatestPerkButton", "GuildNextPerkButton"}
		for _, button in pairs(perkbuttons) do
			local bu = _G[button]
			local ic = _G[button.."IconTexture"]
			local na = _G[button.."NameFrame"]

			na:Hide()
			ic:SetTexCoord(.08, .92, .08, .92)

			ic.bg = CreateFrame("Frame", nil, bu)
			ic.bg:SetPoint("TOPLEFT", ic, -1, 1)
			ic.bg:SetPoint("BOTTOMRIGHT", ic, 1, -1)
			ic.bg:SetFrameLevel(0)
			Aurora.CreateBD(ic.bg, .25)

			bu.bg = CreateFrame("Frame", nil, bu)
			bu.bg:SetPoint("TOPLEFT", na, 14, -24)
			bu.bg:SetPoint("BOTTOMRIGHT", na, -60, 24)
			bu.bg:SetFrameLevel(0)
			Aurora.CreateBD(bu.bg, .25)
		end

		select(5, GuildLatestPerkButton:GetRegions()):Hide()
		select(6, GuildLatestPerkButton:GetRegions()):Hide()

		local reskinnedperks = false
		GuildPerksToggleButton:HookScript("OnClick", function()
			if not reskinnedperks == true then
				for i = 1, 8 do
					local button = "GuildPerksContainerButton"..i
					local bu = _G[button]
					local ic = _G[button.."IconTexture"]

					bu:DisableDrawLayer("BACKGROUND")
					bu:DisableDrawLayer("BORDER")
					bu.EnableDrawLayer = Aurora.dummy
					ic:SetTexCoord(.08, .92, .08, .92)

					ic.bg = CreateFrame("Frame", nil, bu)
					ic.bg:SetPoint("TOPLEFT", ic, -1, 1)
					ic.bg:SetPoint("BOTTOMRIGHT", ic, 1, -1)
					Aurora.CreateBD(ic.bg, 0)
				end
				reskinnedperks = true
			end
		end)

		local reskinnedrewards = false
		GuildFrameTab4:HookScript("OnClick", function()
			if not reskinnedrewards == true then
				for i = 1, 8 do
					local button = "GuildRewardsContainerButton"..i
					local bu = _G[button]
					local ic = _G[button.."Icon"]

					ic:SetTexCoord(.08, .92, .08, .92)

					select(6, bu:GetRegions()):SetAlpha(0)
					select(7, bu:GetRegions()):SetTexture(texture)
					select(7, bu:GetRegions()):SetVertexColor(0, 0, 0, .25)
					select(7, bu:GetRegions()):SetPoint("TOPLEFT", 0, -1)
					select(7, bu:GetRegions()):SetPoint("BOTTOMRIGHT", 0, 1)

					ic.bg = CreateFrame("Frame", nil, bu)
					ic.bg:SetPoint("TOPLEFT", ic, -1, 1)
					ic.bg:SetPoint("BOTTOMRIGHT", ic, 1, -1)
					Aurora.CreateBD(ic.bg, 0)
				end
				reskinnedrewards = true
			end
		end)

		GuildLevelFrame:SetAlpha(0)
		local closebutton = select(4, GuildTextEditFrame:GetChildren())
		Aurora.Reskin(closebutton)
		local logbutton = select(3, GuildLogFrame:GetChildren())
		Aurora.Reskin(logbutton)
		local gbuttons = {"GuildAddMemberButton", "GuildViewLogButton", "GuildControlButton", "GuildTextEditFrameAcceptButton", "GuildMemberGroupInviteButton", "GuildMemberRemoveButton", "GuildRecruitmentInviteButton", "GuildRecruitmentMessageButton", "GuildRecruitmentDeclineButton", "GuildPerksToggleButton"}
		for i = 1, getn(gbuttons) do
		local gbutton = _G[gbuttons[i]]
			if gbutton then
				Aurora.Reskin(gbutton)
			end
		end

		for i = 1, 3 do
			for j = 1, 6 do
				select(j, _G["GuildInfoFrameTab"..i]:GetRegions()):Hide()
				select(j, _G["GuildInfoFrameTab"..i]:GetRegions()).Show = Aurora.dummy
			end
		end
	elseif addon == "Blizzard_InspectUI" then
		Aurora.CreateBD(InspectFrame)
		Aurora.CreateSD(InspectFrame)

		local slots = {
			"Head", "Neck", "Shoulder", "Shirt", "Chest", "Waist", "Legs", "Feet", "Wrist",
			"Hands", "Finger0", "Finger1", "Trinket0", "Trinket1", "Back", "MainHand",
			"SecondaryHand", "Ranged", "Tabard",
		}

		for i = 1, getn(slots) do
			local bd = CreateFrame("Frame", nil, _G["Inspect"..slots[i].."Slot"])
			bd:SetPoint("TOPLEFT", -1, 1)
			bd:SetPoint("BOTTOMRIGHT", 1, -1)
			Aurora.CreateBD(bd)
			bd:SetBackdropColor(0, 0, 0, 0)
			_G["Inspect"..slots[i].."Slot"]:SetNormalTexture("")
			_G["Inspect"..slots[i].."Slot"]:GetRegions():SetTexCoord(.08, .92, .08, .92)
		end

		for i = 1, 4 do
			Aurora.CreateTab(_G["InspectFrameTab"..i])
		end
		InspectFramePortrait:Hide()
		InspectGuildFrameBG:Hide()
		for i = 1, 5 do
			select(i, InspectModelFrame:GetRegions()):Hide()
		end
		for i = 1, 4 do
			select(i, InspectTalentFrame:GetRegions()):Hide()
		end
		for i = 1, 3 do
			for j = 1, 6 do
				select(j, _G["InspectTalentFrameTab"..i]:GetRegions()):Hide()
				select(j, _G["InspectTalentFrameTab"..i]:GetRegions()).Show = Aurora.dummy
			end
		end

		ReskinClose(InspectFrameCloseButton)
	elseif addon == "Blizzard_ItemSocketingUI" then
		local SocketBD = CreateFrame("Frame", nil, ItemSocketingFrame)
		SocketBD:SetPoint("TOPLEFT", 12, -8)
		SocketBD:SetPoint("BOTTOMRIGHT", -2, 24)
		SocketBD:SetFrameLevel(ItemSocketingFrame:GetFrameLevel()-1)
		Aurora.CreateBD(SocketBD)
		Aurora.CreateSD(SocketBD)
		ItemSocketingFramePortrait:Hide()
		ItemSocketingScrollFrameTop:SetAlpha(0)
		ItemSocketingScrollFrameBottom:SetAlpha(0)
		ItemSocketingSocket1Left:SetAlpha(0)
		ItemSocketingSocket1Right:SetAlpha(0)
		ItemSocketingSocket2Left:SetAlpha(0)
		ItemSocketingSocket2Right:SetAlpha(0)
		Aurora.Reskin(ItemSocketingSocketButton)
		ItemSocketingSocketButton:ClearAllPoints()
		ItemSocketingSocketButton:SetPoint("BOTTOMRIGHT", ItemSocketingFrame, "BOTTOMRIGHT", -10, 28)
		ReskinClose(ItemSocketingCloseButton, "TOPRIGHT", ItemSocketingFrame, "TOPRIGHT", -6, -12)
		ReskinScroll(ItemSocketingScrollFrameScrollBar)
	elseif addon == "Blizzard_LookingForGuildUI" then
		Aurora.CreateBD(LookingForGuildFrame)
		Aurora.CreateSD(LookingForGuildFrame)
		Aurora.CreateBD(LookingForGuildInterestFrame, .25)
		LookingForGuildInterestFrame:GetRegions():Hide()
		Aurora.CreateBD(LookingForGuildAvailabilityFrame, .25)
		LookingForGuildAvailabilityFrame:GetRegions():Hide()
		Aurora.CreateBD(LookingForGuildRolesFrame, .25)
		LookingForGuildRolesFrame:GetRegions():Hide()
		Aurora.CreateBD(LookingForGuildCommentFrame, .25)
		LookingForGuildCommentFrame:GetRegions():Hide()
		Aurora.CreateBD(LookingForGuildCommentInputFrame, .12)
		for i = 1, 5 do
			local bu = _G["LookingForGuildBrowseFrameContainerButton"..i]
			Aurora.CreateBD(bu, .25)
			bu:SetHighlightTexture("")
			bu:GetRegions():SetTexture(texture)
			bu:GetRegions():SetVertexColor(c.r, c.g, c.b, .2)
		end
		for i = 1, 9 do
			select(i, LookingForGuildCommentInputFrame:GetRegions()):Hide()
		end
		for i = 1, 3 do
			for j = 1, 6 do
				select(j, _G["LookingForGuildFrameTab"..i]:GetRegions()):Hide()
				select(j, _G["LookingForGuildFrameTab"..i]:GetRegions()).Show = Aurora.dummy
			end
		end
		for i = 18, 20 do
			select(i, LookingForGuildFrame:GetRegions()):Hide()
		end
		Aurora.Reskin(LookingForGuildBrowseButton)
		Aurora.Reskin(LookingForGuildRequestButton)

		ReskinClose(LookingForGuildFrameCloseButton)
	elseif addon == "Blizzard_MacroUI" then
		local MacroBD = CreateFrame("Frame", nil, MacroFrame)
		MacroBD:SetPoint("TOPLEFT", 12, -10)
		MacroBD:SetPoint("BOTTOMRIGHT", -33, 68)
		MacroBD:SetFrameLevel(MacroFrame:GetFrameLevel()-1)
		Aurora.CreateBD(MacroBD)
		Aurora.CreateSD(MacroBD)
		Aurora.CreateBD(MacroFrameTextBackground, .25)
		Aurora.CreateBD(MacroPopupFrame)
		Aurora.CreateSD(MacroPopupFrame)
		for i = 1, 6 do
			select(i, MacroFrameTab1:GetRegions()):Hide()
			select(i, MacroFrameTab2:GetRegions()):Hide()
			select(i, MacroFrameTab1:GetRegions()).Show = Aurora.dummy
			select(i, MacroFrameTab2:GetRegions()).Show = Aurora.dummy
		end
		for i = 1, 8 do
			if i ~= 6 then select(i, MacroFrame:GetRegions()):Hide() end
		end
		for i = 1, 5 do
			select(i, MacroPopupFrame:GetRegions()):Hide()
		end
		MacroPopupScrollFrame:GetRegions():Hide()
		select(2, MacroPopupScrollFrame:GetRegions()):Hide()

		Aurora.Reskin(MacroDeleteButton)
		Aurora.Reskin(MacroNewButton)
		Aurora.Reskin(MacroExitButton)
		Aurora.Reskin(MacroEditButton)
		Aurora.Reskin(MacroPopupOkayButton)
		Aurora.Reskin(MacroPopupCancelButton)
		MacroPopupFrame:ClearAllPoints()
		MacroPopupFrame:SetPoint("LEFT", MacroFrame, "RIGHT", -14, 16)

		ReskinClose(MacroFrameCloseButton, "TOPRIGHT", MacroFrame, "TOPRIGHT", -38, -14)
		ReskinScroll(MacroButtonScrollFrameScrollBar)
		ReskinScroll(MacroFrameScrollFrameScrollBar)
		ReskinScroll(MacroPopupScrollFrameScrollBar)
	elseif addon == "Blizzard_ReforgingUI" then
		Aurora.CreateBD(ReforgingFrame)
		Aurora.CreateSD(ReforgingFrame)
		ReforgingFramePortrait:Hide()
		Aurora.Reskin(ReforgingFrameRestoreButton)
		Aurora.Reskin(ReforgingFrameReforgeButton)
		ReskinDropDown(ReforgingFrameFilterOldStat)
		ReskinDropDown(ReforgingFrameFilterNewStat)
		ReskinClose(ReforgingFrameCloseButton)
	elseif addon == "Blizzard_TalentUI" then
		Aurora.CreateBD(PlayerTalentFrame)
		Aurora.CreateSD(PlayerTalentFrame)
		local talentbuttons = {"PlayerTalentFrameToggleSummariesButton", "PlayerTalentFrameLearnButton", "PlayerTalentFrameResetButton", "PlayerTalentFrameActivateButton"}
		for i = 1, getn(talentbuttons) do
		local reskinbutton = _G[talentbuttons[i]]
			if reskinbutton then
				Aurora.Reskin(reskinbutton)
			end
		end	
		PlayerTalentFramePortrait:Hide()
		PlayerTalentFrameTitleGlowLeft:SetAlpha(0)
		PlayerTalentFrameTitleGlowRight:SetAlpha(0)
		PlayerTalentFrameTitleGlowCenter:SetAlpha(0)
		for i = 1, 3 do
			if _G["PlayerTalentFrameTab"..i] then
				Aurora.CreateTab(_G["PlayerTalentFrameTab"..i])
			end
		end
		for i = 1, 2 do
			local tab = _G["PlayerSpecTab"..i]
			local a1, p, a2, x, y = PlayerSpecTab1:GetPoint()
			local bg = CreateFrame("Frame", nil, tab)
			bg:SetPoint("TOPLEFT", -1, 1)
			bg:SetPoint("BOTTOMRIGHT", 1, -1)
			bg:SetFrameLevel(tab:GetFrameLevel()-1)
			hooksecurefunc("PlayerTalentFrame_UpdateTabs", function()
				PlayerSpecTab1:SetPoint(a1, p, a2, x + 11, y + 10)
				PlayerSpecTab2:SetPoint("TOP", PlayerSpecTab1, "BOTTOM")
			end)
			Aurora.CreateSD(tab, 5, 0, 0, 0, 1, 1)
			Aurora.CreateBD(bg, 1)
			select(2, tab:GetRegions()):SetTexCoord(.08, .92, .08, .92)
		end

		ReskinClose(PlayerTalentFrameCloseButton)
	elseif addon == "Blizzard_TradeSkillUI" then
		Aurora.CreateBD(TradeSkillFrame)
		Aurora.CreateSD(TradeSkillFrame)
		Aurora.CreateBD(TradeSkillGuildFrame)
		Aurora.CreateSD(TradeSkillGuildFrame)
		Aurora.CreateBD(TradeSkillFrameSearchBox, .25)
		Aurora.CreateBD(TradeSkillGuildFrameContainer, .25)

		TradeSkillFramePortrait:Hide()
		TradeSkillFramePortrait.Show = Aurora.dummy
		for i = 18, 20 do
			select(i, TradeSkillFrame:GetRegions()):Hide()
			select(i, TradeSkillFrame:GetRegions()).Show = Aurora.dummy
		end
		TradeSkillHorizontalBarLeft:Hide()
		select(22, TradeSkillFrame:GetRegions()):Hide()
		for i = 1, 3 do
			select(i, TradeSkillExpandButtonFrame:GetRegions()):Hide()
			select(i, TradeSkillFilterButton:GetRegions()):Hide()
		end
		for i = 1, 9 do
			select(i, TradeSkillGuildFrame:GetRegions()):Hide()
		end
		for i = 4, 8 do
			select(i, TradeSkillFrameSearchBox:GetRegions()):Hide()
		end
		TradeSkillListScrollFrame:GetRegions():Hide()
		select(2, TradeSkillListScrollFrame:GetRegions()):Hide()
		TradeSkillDetailHeaderLeft:Hide()
		TradeSkillDetailScrollFrameTop:SetAlpha(0)
		TradeSkillDetailScrollFrameBottom:SetAlpha(0)

		TradeSkillDetailScrollFrame:SetHeight(176)

		local a1, p, a2, x, y = TradeSkillGuildFrame:GetPoint()
		TradeSkillGuildFrame:ClearAllPoints()
		TradeSkillGuildFrame:SetPoint(a1, p, a2, x + 16, y)

		local tradeskillbuttons = {"TradeSkillCreateButton", "TradeSkillCreateAllButton", "TradeSkillCancelButton", "TradeSkillViewGuildCraftersButton", "TradeSkillFilterButton"}
		for i = 1, getn(tradeskillbuttons) do
		local button = _G[tradeskillbuttons[i]]
			if button then
				Aurora.Reskin(button)
			end
		end

		for i = 1, MAX_TRADE_SKILL_REAGENTS do
			local bu = _G["TradeSkillReagent"..i]
			local na = _G["TradeSkillReagent"..i.."NameFrame"]
			local ic = _G["TradeSkillReagent"..i.."IconTexture"]

			na:Hide()

			ic:SetTexCoord(.08, .92, .08, .92)

			local bg = CreateFrame("Frame", nil, bu)
			bg:SetPoint("TOPLEFT", ic, -1, 1)
			bg:SetPoint("BOTTOMRIGHT", ic, 1, -1)
			Aurora.CreateBD(bg, 0)

			local bd = CreateFrame("Frame", nil, bu)
			bd:SetPoint("TOPLEFT", na, 14, -24)
			bd:SetPoint("BOTTOMRIGHT", na, -53, 25)
			bd:SetFrameLevel(0)
			Aurora.CreateBD(bd, .25)

			_G["TradeSkillReagent"..i.."Name"]:SetParent(bd)
		end

		local reskinned = false
		hooksecurefunc("TradeSkillFrame_SetSelection", function()
			if not reskinned == true then
				local ic = select(2, TradeSkillSkillIcon:GetRegions())
				ic:SetTexCoord(.08, .92, .08, .92)
				ic:SetPoint("TOPLEFT", 1, -1)
				ic:SetPoint("BOTTOMRIGHT", -1, 1)
				Aurora.CreateBD(TradeSkillSkillIcon)
				reskinned = true
			end
		end)

		ReskinClose(TradeSkillFrameCloseButton)
		ReskinClose(TradeSkillGuildFrameCloseButton)
		ReskinScroll(TradeSkillDetailScrollFrameScrollBar)
		ReskinScroll(TradeSkillListScrollFrameScrollBar)
	elseif addon == "Blizzard_TrainerUI" then
		Aurora.CreateBD(ClassTrainerFrame)
		Aurora.CreateSD(ClassTrainerFrame)
		ClassTrainerFramePortrait:Hide()
		select(19, ClassTrainerFrame:GetRegions()):Hide()

		ClassTrainerStatusBarSkillRank:ClearAllPoints()
		ClassTrainerStatusBarSkillRank:SetPoint("CENTER", ClassTrainerStatusBar, "CENTER", 0, 0)

		Aurora.Reskin(ClassTrainerTrainButton)

		ReskinClose(ClassTrainerFrameCloseButton)
		ReskinDropDown(ClassTrainerFrameFilterDropDown)
	end

	-- [[ Mac Options ]]

	if IsMacClient() then
		Aurora.CreateBD(MacOptionsFrame)
		MacOptionsFrameHeader:SetTexture("")
		MacOptionsFrameHeader:ClearAllPoints()
		MacOptionsFrameHeader:SetPoint("TOP", MacOptionsFrame, 0, 0)
 
		Aurora.CreateBD(MacOptionsFrameMovieRecording, .25)
		Aurora.CreateBD(MacOptionsITunesRemote, .25)

		local macbuttons = {"MacOptionsButtonKeybindings", "MacOptionsButtonCompress", "MacOptionsFrameCancel", "MacOptionsFrameOkay", "MacOptionsFrameDefaults"}
		for i = 1, getn(macbuttons) do
		local button = _G[macbuttons[i]]
			if button then
				Aurora.Reskin(button)
			end
		end

		ReskinDropDown(MacOptionsFrameResolutionDropDown)
		ReskinDropDown(MacOptionsFrameFramerateDropDown)
		ReskinDropDown(MacOptionsFrameCodecDropDown)
 
		_G["MacOptionsButtonCompress"]:SetWidth(136)
 
		_G["MacOptionsFrameCancel"]:SetWidth(96)
		_G["MacOptionsFrameCancel"]:SetHeight(22)
		_G["MacOptionsFrameCancel"]:ClearAllPoints()
		_G["MacOptionsFrameCancel"]:SetPoint("LEFT", _G["MacOptionsButtonKeybindings"], "RIGHT", 107, 0)
 
		_G["MacOptionsFrameOkay"]:SetWidth(96)
		_G["MacOptionsFrameOkay"]:SetHeight(22)
		_G["MacOptionsFrameOkay"]:ClearAllPoints()
		_G["MacOptionsFrameOkay"]:SetPoint("LEFT", _G["MacOptionsButtonKeybindings"], "RIGHT", 5, 0)
 
		_G["MacOptionsButtonKeybindings"]:SetWidth(96)
		_G["MacOptionsButtonKeybindings"]:SetHeight(22)
		_G["MacOptionsButtonKeybindings"]:ClearAllPoints()
		_G["MacOptionsButtonKeybindings"]:SetPoint("LEFT", _G["MacOptionsFrameDefaults"], "RIGHT", 5, 0)
 
		_G["MacOptionsFrameDefaults"]:SetWidth(96)
		_G["MacOptionsFrameDefaults"]:SetHeight(22)
 
	end
end)