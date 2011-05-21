﻿--[[
	Recount Skin by Darth Android / Telroth - The Venture Co.
	
	Skins Recount to look like TelUI.
	
	Todo:
	 + Skin "Reset Data" windows
	 
	Available SKIN methods:
	 
	:SkinRecountBar(bar) -- Retextures and skins a damage bar
	
	:SkinRecountWindow(window) -- Skins a recount window, including the titlebar and buttons
	
	Available LAYOUT methods:
	
	:PositionRecountWindow(window) -- positions a recount window on screen
	 
	(C)2010 Darth Android / Telroth - The Venture Co.
	File version v91.110
]]

if not IsAddOnLoaded("Recount") or not Mod_AddonSkins then return end
local Recount = _G.Recount

Mod_AddonSkins:RegisterSkin("Recount",function(Skin, skin, Layout, layout, config)
	
	function Skin:SkinRecountBar(bar)
		bar.StatusBar:SetStatusBarTexture(config.barTexture)
		bar.StatusBar:GetStatusBarTexture():SetHorizTile(false)
		bar.StatusBar:GetStatusBarTexture():SetVertTile(false)
	end
	
	function Skin:SkinRecountWindow(window)
		window.bgMain = CreateFrame("Frame",nil,window)
	    skin:SkinBackgroundFrame(window.bgMain)
	    window.bgMain:SetPoint("BOTTOMLEFT",window,"BOTTOMLEFT")
	    window.bgMain:SetPoint("BOTTOMRIGHT",window,"BOTTOMRIGHT")
	    window.bgMain:SetPoint("TOP",window,"TOP",0,-30)
	    window.bgMain:SetFrameStrata("LOW")
	    window.bgMain:SetFrameLevel(31)
	    window.bgTitle = CreateFrame("Frame",nil,window)
	    skin:SkinBackgroundFrame(window.bgTitle)
	    window.bgTitle:SetPoint("TOPRIGHT",window,"TOPRIGHT",0,-10)
	    window.bgTitle:SetPoint("TOPLEFT",window,"TOPLEFT",0,-9)
	    window.bgTitle:SetPoint("BOTTOM",window,"TOP",0,-29)
	    window.bgTitle:SetFrameStrata("LOW")
	    window.bgTitle:SetFrameLevel(31)
	    window.CloseButton:SetPoint("TOPRIGHT",window,"TOPRIGHT",-1,-9)
	    window.Title:SetPoint("TOPLEFT",window,"TOPLEFT",2,-12)
		window:SetBackdrop(nil)
		layout:PositionRecountWindow(window)
	end
	
	-- Let's not move user's windows around. They usually don't like it.
	Layout.PositionRecountWindow = dummy
	
	-- Override bar textures
	function Recount:UpdateBarTextures()
		for _, bar in pairs(Recount.MainWindow.Rows) do
			skin:SkinRecountBar(bar)
		end
		--Recount:SetFont("uffont")
	end
	Recount.SetBarTextures = Recount.UpdateBarTextures
	
	-- Fix bar textures as they're created
	Recount.SetupBar_ = Recount.SetupBar
	function Recount:SetupBar(bar)
		self:SetupBar_(bar)
		skin:SkinRecountBar(bar)
	end
	
	-- Skin frames when they're created
	Recount.CreateFrame_ = Recount.CreateFrame
	function Recount:CreateFrame(Name, Title, Height, Width, ShowFunc, HideFunc)
	    local frame = self:CreateFrame_(Name, Title, Height, Width, ShowFunc, HideFunc)
	    skin:SkinRecountWindow(frame)
	    return frame
	end

	-- Skin existing frames
	if Recount.MainWindow then skin:SkinRecountWindow(Recount.MainWindow) end
	if Recount.ConfigWindow then skin:SkinRecountWindow(Recount.ConfigWindow) end
	if Recount.GraphWindow then skin:SkinRecountWindow(Recount.GraphWindow) end
	if Recount.DetailWindow then skin:SkinRecountWindow(Recount.DetailWindow) end
	if Recount.ResetFrame then skin:SkinRecountWindow(Recount.ResetFrame) end
	if _G["Recount_Realtime_!RAID_DAMAGE"] then skin:SkinRecountWindow(_G["Recount_Realtime_!RAID_DAMAGE"].Window) end
	if _G["Recount_Realtime_!RAID_HEALING"] then skin:SkinRecountWindow(_G["Recount_Realtime_!RAID_HEALING"].Window) end
	if _G["Recount_Realtime_!RAID_HEALINGTAKEN"] then skin:SkinRecountWindow(_G["Recount_Realtime_!RAID_HEALINGTAKEN"].Window) end
	if _G["Recount_Realtime_!RAID_DAMAGETAKEN"] then skin:SkinRecountWindow(_G["Recount_Realtime_!RAID_DAMAGETAKEN"].Window) end
	if _G["Recount_Realtime_Bandwidth Available_AVAILABLE_BANDWIDTH"] then skin:SkinRecountWindow(_G["Recount_Realtime_Bandwidth Available_AVAILABLE_BANDWIDTH"].Window) end
	if _G["Recount_Realtime_FPS_FPS"] then skin:SkinRecountWindow(_G["Recount_Realtime_FPS_FPS"].Window) end
	if _G["Recount_Realtime_Latency_LAG"] then skin:SkinRecountWindow(_G["Recount_Realtime_Latency_LAG"].Window) end
	if _G["Recount_Realtime_Downstream Traffic_DOWN_TRAFFIC"] then skin:SkinRecountWindow(_G["Recount_Realtime_Downstream Traffic_DOWN_TRAFFIC"].Window) end
	if _G["Recount_Realtime_Upstream Traffic_UP_TRAFFIC"] then skin:SkinRecountWindow(_G["Recount_Realtime_Upstream Traffic_UP_TRAFFIC"].Window) end
	-- Let's update me some textures!
	Recount:UpdateBarTextures()
end)
