local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales

C["general"] = {
	["autoscale"] = true,                               -- mainly enabled for users that don't want to mess with the config file
	["uiscale"] = 0.71,                                 -- set your value (between 0.64 and 1) of your uiscale if autoscale is off
	["overridelowtohigh"] = false,                      -- EXPERIMENTAL ONLY! override lower version to higher version on a lower reso.
	["multisampleprotect"] = true,                      -- i don't recommend this because of shitty border but, voila!
	--["bordercolor"] = { .1, .1, .1, 1 },				-- default border color of panels > currently not working
	--["backdropcolor"] = { 0, 0, 0, 1 },					-- default backdrop color of panels > currently not working
}

C["unitframes"] = {
	-- Gen.
	["enable"] = true,                                  -- do i really need to explain this?
	
	-- Colors
	["enemyhcolor"] = true,                            -- enemy target (players) color by hostility, very useful for healer.
	["unicolor"] = true,                              	-- enable unicolor theme
		-- if unicolor == true then it uses these colors
		["healthColor"] = { .07, .07, .07 },	
		["healthBgColor"] = { 0.80, 0.02, 0.02 },			-- { .6, .02, .02 },
	--["altbordercolor"] = { .4, .4, .4 },              -- unit frames panel border color > currently not working
	
	-- Castbar
	["unitcastbar"] = true,                             -- enable tukui castbar
	["cblatency"] = true,                              	-- enable castbar latency
	["cbicons"] = true,                                 -- enable icons on castbar
	["cbclasscolor"] = false,
		-- if cbclasscolor == false then it uses this color
		["cbcustomcolor"] = { .2, .4, .7 },				-- 0,0.7,1 -- .2, .4, .7
		
	-- Auras
	["auratimer"] = true,                               -- enable timers on buffs/debuffs
	["auratextscale"] = 11,                             -- the font size of buffs/debuffs timers on unitframes
	["playerauras"] = false,                            -- enable auras
	["targetauras"] = true,                             -- enable auras on target unit frame
	["totdebuffs"] = false,                             -- enable tot debuffs (high reso only)
	["focusdebuffs"] = false,                             -- enable focus debuffs
	["focusbuffs"] = false,                             -- enable focus buffs
	["onlyselfdebuffs"] = false,                        -- display only our own debuffs applied on target
	["onlyselfbuffs"] = false,                        -- display only our own buffs applied on target
	["buffrows"] = 1,                       			-- change how many buff rows are displayed
	["debuffrows"] = 2,                        			-- change how many debuff rows are displayed
	
	-- Misc.
	["charportrait"] = false,                           -- do i really need to explain this?
	["showtotalhpmp"] = false,                          -- change the display of info text on player and target with XXXX/Total.
	["targetpowerpvponly"] = false,                      -- enable power text on pvp target only
	["showsmooth"] = true,                              -- enable smooth bar
	["lowThreshold"] = 20,                              -- global low threshold, for low mana warning.
	["combatfeedback"] = false,                          -- enable combattext on player and target.
	["playeraggro"] = false,                             -- color player border to red if you have aggro on current target.

	-- Party / Raid
		-- Gen.
		["showrange"] = true,                               -- show range opacity on raidframes
		["raidalphaoor"] = 1,                             -- alpha of unitframes when unit is out of range
		["showplayerinparty"] = false,                      -- show my player frame in party
		["showsymbols"] = true,	                            -- show symbol.
		["aggro"] = false,                                   -- show aggro on all raids layouts
		["raidunitdebuffwatch"] = true,                     -- track important spell to watch in pve for grid mode.
		["healcomm"] = true,                               -- enable healprediction support.
		["debuffHighlightFilter"] = true,					-- filter debuff border coloring
			-- enable player / target debuff highlight
			["playerHighlight"] = true,				
		
		-- Heal
		["healthvertical"] = true,						-- change orientation of health bars in heal mode
		["healthdeficit"] = true,						-- show health deficit values in heal mode
		
		-- Dps
		["hidepower"] = true,							-- hide power bar in dps party/raid15 mode
	

	-- Extra Frames
	["maintank"] = true,                               	-- enable maintank
	["mainassist"] = false,                             -- enable mainassist
	["showboss"] = true,                                -- enable boss unit frames for PVELOL encounters.
	["showfocustarget"] = true,							-- show focus target
	
	-- priest only plugin
	["weakenedsoulbar"] = false,                         -- show weakened soul bar
	
	-- class bar
	["classbar"] = true,                                -- enable tukui classbar over player unit
		-- individual class bar set up
		["deathknight"] = true,
		["warlock"] = true,
		["shaman"] = true,
		["druid"] = true,
		["paladin"] = true,
		
	-- layout
	["style"] = "Cohesion",                                -- unitframe style, ("Cohesion" or "Eclipse" for default)
	
	-- health deficit gradient and mouseover-highlight, credits to Hydra
	["gradienthealth"] = true,                          -- change raid health color based on health percent. (heal layout only)
	["mouseoverhighlight"] = true						-- enable mouseover highlight on raid frames (heal layout only)
}

C["arena"] = {
	["unitframes"] = true,                              -- enable tukz arena unitframes (requirement : tukui unitframes enabled)
}

C["auras"] = {
	["player"] = true,                                  -- enable tukui buffs/debuffs
}

C["actionbar"] = {
	["enable"] = true,                                  -- enable tukui action bars
	["hotkey"] = true,                                 -- enable hotkey display because it was a lot requested
	["hideshapeshift"] = true,                         -- hide shapeshift or totembar because it was a lot requested.
	["showgrid"] = true,                                -- show grid on empty button
	["buttonsize"] = 27,                                -- normal buttons size
	["petbuttonsize"] = 27,                             -- pet & stance buttons size
	["stancebuttonsize"] = 27,                             -- pet & stance buttons size
	["buttonspacing"] = 4,                              -- buttons spacing
	["vertical_rightbars"] = false,						-- vertical or horizontal right bars
	["vertical_shapeshift"] = true,						-- (NOT FOR SHAMANS/TOTEMS) vertical or horizontal shapeshift bar
}

C["bags"] = {
	["enable"] = true,                                  -- enable an all in one bag mod that fit tukui perfectly
}

C["map"] = {
	["enable"] = true,                                  -- reskin the map to fit tukui
}

C["loot"] = {
	["lootframe"] = true,                               -- reskin the loot frame to fit tukui
	["rolllootframe"] = true,                           -- reskin the roll frame to fit tukui
	["autogreed"] = true,                               -- auto-dez or auto-greed item at max level, auto-greed Frozen orb
}

C["cooldown"] = {
	["enable"] = true,                                  -- do i really need to explain this?
	["treshold"] = 8,                                   -- show decimal under X seconds and text turn red
}

C["datatext"] = {
	["mmenu"] = 5,
	["armor"] = 0,                                      -- show your armor value against the level mob you are currently targeting
	["avd"] = 0,                                        -- show your current avoidance against the level of the mob your targeting
	["bags"] = 0,                                       -- show space used in bags on panels
	["crit"] = 0,                                       -- show your crit rating on panels.
	["currency"] = 0,                                   -- show your tracked currency on panels
	["dps_text"] = 0,                                   -- show a dps meter on panels
	["dur"] = 3,                                        -- show your equipment durability on panels.
	["fps_ms"] = 0,                                     -- show fps and ms on panels
	["friends"] = 1,                                    -- show number of friends connected.
	["gold"] = 6,                                       -- show your current gold on panels
	["guild"] = 2,                                      -- show number on guildmate connected on panels
	["haste"] = 0,                                      -- show your haste rating on panels.
	["hit"] = 0,										-- show your hit on panels
	["hps_text"] = 0,                                   -- show a heal meter on panels
	["mastery"] = 0,									-- show mastery on panels
	["micromenu"] = 0,									-- game menu attached to panels
	["power"] = 4,                                      -- show your attackpower/spellpower/healpower/rangedattackpower whatever stat is higher gets displayed
	["system"] = 0,                                     -- show total memory and others systems infos on panels
	["wowtime"] = 0,                                    -- show time on panels
	["regen"] = 0,										-- show mana regeneration
	["location"] = true,								-- enable location panel
		-- coordinates display only if location == true
		["location_coords"] = true,						-- display location coordinates
	["exprepbars"] = true,								-- enable experience and reputation bar
		["expreptext"] = true,							-- enable text on experience and reputation bars

	-- ["battleground"] = true,                            -- enable 3 stats in battleground only that replace stat1,stat2,stat3.
	["time24"] = true,                                  -- set time to 24h format.
	["localtime"] = true,                              	-- set time to local time instead of server time.
	
	["classcolor"] = false,
		["color"] = { .2, .4, .7 },						-- 0,0.7,1 -- .2, .4, .7
		
	["statblock"] = true,								-- display statblock in topleft corner
	["maptime"] = true,									-- show display clock below minimap
}

C["chat"] = {
	["enable"] = true,                                  -- blah
	["whispersound"] = true,                            -- play a sound when receiving whisper
	["height"] = 165,									-- adjust the chatframe height
	["background"] = true,								-- chat frame backgrounds
	["justifyRight"] = false,							-- set right chat frame text to the right
}

C["nameplate"] = {
	["enable"] = true,                                  -- enable nice skinned nameplates that fit into tukui
	["showhealth"] = true,				                -- show health text on nameplate
	["enhancethreat"] = true,			                -- threat features based on if your a tank or not
	["combat"] = false,					                -- only show enemy nameplates in-combat.
	["goodcolor"] = {160/255, 235/255,  0/255},	        -- good threat color (tank shows this with threat, everyone else without)
	["badcolor"] = {180/255, 30/255,  0/255},			        -- bad threat color (opposite of above)
	["transitioncolor"] = {218/255, 197/255, 92/255},	-- threat color when gaining threat
}

C["tooltip"] = {
	["enable"] = true,                                  -- true to enable this mod, false to disable
	["hidecombat"] = false,                             -- hide bottom-right tooltip when in combat
	["hidebuttons"] = false,                            -- always hide action bar buttons tooltip.
	["hideuf"] = true,                                 	-- hide tooltip on unitframes
	["cursor"] = true,                                 	-- tooltip via cursor only
}

C["merchant"] = {
	["sellgrays"] = true,                               -- automaticly sell grays?
	["autorepair"] = true,                              -- automaticly repair?
		-- guild repair only if autorepair == true
		["guildrepair"] = false,							-- automatically use guild funds to repair (if available)
	["sellmisc"] = true,                                -- sell defined items automatically
}

C["error"] = {
	["enable"] = true,                                  -- true to enable this mod, false to disable
	filter = {                                          -- what messages to not hide
		[INVENTORY_FULL] = true,                        -- inventory is full will not be hidden by default
	},
}

C["invite"] = { 
	["autoaccept"] = false,                              -- auto-accept invite from guildmate and friends.
}

C["buffreminder"] = {
	["enable"] = true,                                  -- this is now the new innerfire warning script for all armor/aspect class.
	["sound"] = false,                                   -- enable warning sound notification for reminder.
	["raidbuffreminder"] = false,						-- enable panel with missing raid buffs below the minimap
}

C["combo"] = {											-- credit to Dajova
	["display"] = true,									-- enable numeric combo display
	-- combo setup
		["dknight"] = false,                   			-- enable death knight combo module (odd behaviour and not updating correctly, disabled until further notice)
		["druid"] = false,                    			-- enable druid combo module (odd behaviour and not updating correctly, disabled until further notice)
		["hunter"] = true,                   			-- enable hunter combo module
		["mage"] = false,                     			-- enable mage combo module
		["paladin"] = true,                  			-- enable paladin combo module (will turn into bar above the playerframe if false)
		["priest"] = true,                   			-- enable priest combo module
		["shaman"] = true,                   			-- enable shaman combo module
		["warlock"] = true,                  			-- enable warlock combo module (will turn into bar above the playerframe if false)
		["warrior"] = true,                  			-- enable warrior combo module
} 

C["others"] = {
	["autoquest"] = true,								-- enable autoquest feature (credit to Dajova)
}

C["skin"] = {
	["ArkInventory"] = false,							-- skin ArkInventory
	["DBM"] = false,									-- skin DBM
	["DXE"] = false,									-- skin DXE
	["KLE"] = false,									-- skin KLE
	["Omen"] = false,									-- skin Omen
	["QBar"] = false,									-- skin QBar
	["Quartz"] = false,									-- skin Quartz
	["Recount"] = true,									-- skin Recount
	["SexyCooldown"] = false,							-- skin SexyCooldown
	["Skada"] = false,									-- skin Skada
}