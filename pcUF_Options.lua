local pcUF = LibStub("AceAddon-3.0"):GetAddon("pcUF")
local L = LibStub("AceLocale-3.0"):GetLocale("pcUF", true)

local anchorPoints = {
	[1] = L["Bottom Left"],
	[2] = L["Bottom Right"],
	[3] = L["Left"],
	[4] = L["Right"],
	[5] = L["Top Left"],
	[6] = L["Top Right"],
}

local function getOption(info)
	if (info.arg[2]) then
		return pcUF.db.profile[info.arg[1]][info.arg[2]][info.arg[3]]
	else
		return pcUF.db.profile[info.arg[1]][info.arg[3]]
	end
end

local function setOption(info, value)
	if (info.arg[2]) then
		pcUF.db.profile[info.arg[1]][info.arg[2]][info.arg[3]] = value
	else
		pcUF.db.profile[info.arg[1]][info.arg[3]] = value
	end
	if (info.arg[4]) then
		local func = info.arg[4]
		func()
	end
end

local function getColor(info)
	return pcUF.db.profile[info.arg[1]][info.arg[2]].r, pcUF.db.profile[info.arg[1]][info.arg[2]].g, pcUF.db.profile[info.arg[1]][info.arg[2]].b, pcUF.db.profile[info.arg[1]][info.arg[2]].a
end

local function setColor(info, r, g, b, a)
	pcUF.db.profile[info.arg[1]][info.arg[2]].r = r
	pcUF.db.profile[info.arg[1]][info.arg[2]].g = g
	pcUF.db.profile[info.arg[1]][info.arg[2]].b = b
	pcUF.db.profile[info.arg[1]][info.arg[2]].a = a
	if (info.arg[3]) then
		local func = info.arg[3]
		func()
	end
end

-- Return all registered SML textures
local textures = {}
local function GetTextures()
	for k in pairs(textures) do textures[k] = nil end

	for _, name in pairs(pcUF.LSM:List(pcUF.LSM.MediaType.STATUSBAR)) do
		textures[name] = name
	end

	return textures
end

--local function getBuffDebuffPosition(info)
----	if (info.arg[2]) then
----		return position[ pcUF.db.profile[info.arg[1]][info.arg[2]][info.arg[3]] ]
----	else
----		return position[ pcUF.db.profile[info.arg[1]][info.arg[3]] ]
----	end
----	for i=1,6 do
----		if (position[i] == pcUF.db.profile[info.arg[1]][info.arg[2]][info.arg[3]]) then
----			return i
----		end
----	end
--	if (info.arg[2]) then
--		return pcUF.db.profile[info.arg[1]][info.arg[2]][info.arg[3]]
--	else
--		return pcUF.db.profile[info.arg[1]][info.arg[3]]
--	end
--end
--
--local function setBuffDebuffPosition(info, value)
--	if (info.arg[2]) then
--		pcUF.db.profile[info.arg[1]][info.arg[2]][info.arg[3]] = value
--	else
--		pcUF.db.profile[info.arg[1]][info.arg[3]] = value
--	end
--	if (info.arg[4]) then
--		local func = info.arg[4]
--		func()
--	end
--end

pcUF.options = {
	name = "pcUF",
	desc = "desc",
	type="group",
	childGroups = "tree",
	args={
		ConfigMode = {
			name = L["Config Mode"],
			desc = L["Easily position normally hidden frames and options."].."  Also doesn't work yet.",
			type = "toggle",
			order = 1,
			get = getOption,
			set = setOption,
			arg = {"global", nil, L["Config Mode"], nil},		-- db location, db variable name, function call (if any) (inline functions ok)
		},
		Locked = {
			name = L["Lock Frames"],
			desc = L["Locks the unit frames."],
			type = "toggle",
			order = 2,
			get = getOption,
			set = setOption,
			arg = {"global", nil, L["Lock Frames"], nil},
		},


		global = {
			name = L["Global Options"],
			type="group",
			order = 1,
--			childGroups = "tab",
			args = {
				FrameColors = {
					name = L["Frame Colors"],
					type= "group",
					order = 1,
					inline = true,
					args = {
						BackgroundColor = {
							name = L["Background Color"],
							desc = "desc",
							type = "color",
							order = 1,
							hasAlpha = true,
							get = getColor,
							set = setColor,
							arg = {"global", L["Background Color"], function() pcUF:SetupAllBorderBackground() end},
						},
						BorderColor = {
							name = L["Border Color"],
							desc = "desc",
							type = "color",
							order = 2,
							hasAlpha = true,
							get = getColor,
							set = setColor,
							arg = {"global", L["Border Color"], function() pcUF:SetupAllBorderBackground() end},
						},
						Reset = {
							name = L["Reset"],
							desc = "desc",
							type = "toggle",
							order = 3,
							set = function()
								pcUF.db.profile.global[L["Background Color"]].r = pcUF.defaults.profile.global[L["Background Color"]].r
								pcUF.db.profile.global[L["Background Color"]].g = pcUF.defaults.profile.global[L["Background Color"]].g
								pcUF.db.profile.global[L["Background Color"]].b = pcUF.defaults.profile.global[L["Background Color"]].b
								pcUF.db.profile.global[L["Background Color"]].a = pcUF.defaults.profile.global[L["Background Color"]].a
								pcUF.db.profile.global[L["Border Color"]].r = pcUF.defaults.profile.global[L["Border Color"]].r
								pcUF.db.profile.global[L["Border Color"]].g = pcUF.defaults.profile.global[L["Border Color"]].g
								pcUF.db.profile.global[L["Border Color"]].b = pcUF.defaults.profile.global[L["Border Color"]].b
								pcUF.db.profile.global[L["Border Color"]].a = pcUF.defaults.profile.global[L["Border Color"]].a
								pcUF:SetupAllBorderBackground()
							end,
						},
					},
				},
				BarOptions = {
					name = L["Bar Options"],
					type= "group",
					order = 2,
					inline = true,
					args = {
						BarTextures = {
							name = L["Bar Textures"],
							type= "group",
							order = 1,
							inline = true,
							args = {
								statusBarTexture = {
									name = L["Status Bar Texture"],
									desc = "desc",
									type = "select",
									order = 1,
									dialogControl = "LSM30_Statusbar",
									values = GetTextures,
									get = getOption,
									set = setOption,
									arg = {"global", nil, L["Status Bar Texture"], function() pcUF:SetupAllStatusBarTextures() end},
								},
								statusBarBackgroundTexture = {
									name = L["Status Bar Background Texture"],
									desc = "desc",
									type = "select",
									order = 2,
									dialogControl = "LSM30_Statusbar",
									values = GetTextures,
									get = getOption,
									set = setOption,
									arg = {"global", nil, L["Status Bar Background Texture"], function() pcUF:SetupAllStatusBarBackgroundTextures() end},
								},
							},
						},
						BarColors = {
							name = L["Bar Colors"],
							type= "group",
							order = 2,
							inline = true,
							args = {
								healthBarColor = {
									name = L["Health Bar Color"],
									desc = "desc",
									type = "color",
									order = 1,
									hasAlpha = true,
									get = getColor,
									set = setColor,
									arg = {"global", L["Health Bar Color"], function() pcUF:SetupAllBarColors() end},
								},
								manaBarColor = {
									name = L["Mana Bar Color"],
									desc = "desc",
									type = "color",
									order = 2,
									hasAlpha = true,
									get = getColor,
									set = setColor,
									arg = {"global", L["Mana Bar Color"], function() pcUF:SetupAllBarColors() end},
								},
								rageBarColor = {
									name = L["Rage Bar Color"],
									desc = "desc",
									type = "color",
									order = 3,
									hasAlpha = true,
									get = getColor,
									set = setColor,
									arg = {"global", L["Rage Bar Color"], function() pcUF:SetupAllBarColors() end},
								},
								focusBarColor = {
									name = L["Focus Bar Color"],
									desc = "desc",
									type = "color",
									order = 4,
									hasAlpha = true,
									get = getColor,
									set = setColor,
									arg = {"global", L["Focus Bar Color"], function() pcUF:SetupAllBarColors() end},
								},
								energyBarColor = {
									name = L["Energy Bar Color"],
									desc = "desc",
									type = "color",
									order = 5,
									hasAlpha = true,
									get = getColor,
									set = setColor,
									arg = {"global", L["Energy Bar Color"], function() pcUF:SetupAllBarColors() end},
								},
								chiBarColor = {
									name = L["Chi Bar Color"],
									desc = "desc",
									type = "color",
									order = 6,
									hasAlpha = true,
									get = getColor,
									set = setColor,
									arg = {"global", L["Chi Bar Color"], function() pcUF:SetupAllBarColors() end},
								},
								runesBarColor = {
									name = L["Runes Bar Color"],
									desc = "desc",
									type = "color",
									order = 7,
									hasAlpha = true,
									get = getColor,
									set = setColor,
									arg = {"global", L["Runes Bar Color"], function() pcUF:SetupAllBarColors() end},
								},
								runicPowerBarColor = {
									name = L["Runic Power Bar Color"],
									desc = "desc",
									type = "color",
									order = 8,
									hasAlpha = true,
									get = getColor,
									set = setColor,
									arg = {"global", L["Runic Power Bar Color"], function() pcUF:SetupAllBarColors() end},
								},
								soulShardsBarColor = {
									name = L["Soul Shards Bar Color"],
									desc = "desc",
									type = "color",
									order = 9,
									hasAlpha = true,
									get = getColor,
									set = setColor,
									arg = {"global", L["Soul Shards Bar Color"], function() pcUF:SetupAllBarColors() end},
								},
								lunarPowerBarColor = {
									name = L["Astral Power Bar Color"],
									desc = "desc",
									type = "color",
									order = 10,
									hasAlpha = true,
									get = getColor,
									set = setColor,
									arg = {"global", L["Astral Power Bar Color"], function() pcUF:SetupAllBarColors() end},
								},
								holyPowerBarColor = {
									name = L["Holy Power Bar Color"],
									desc = "desc",
									type = "color",
									order = 11,
									hasAlpha = true,
									get = getColor,
									set = setColor,
									arg = {"global", L["Holy Power Bar Color"], function() pcUF:SetupAllBarColors() end},
								},
								maelstromBarColor = {
									name = L["Maelstrom Bar Color"],
									desc = "desc",
									type = "color",
									order = 12,
									hasAlpha = true,
									get = getColor,
									set = setColor,
									arg = {"global", L["Maelstrom Bar Color"], function() pcUF:SetupAllBarColors() end},
								},
								insanityBarColor = {
									name = L["Insanity Bar Color"],
									desc = "desc",
									type = "color",
									order = 13,
									hasAlpha = true,
									get = getColor,
									set = setColor,
									arg = {"global", L["Insanity Bar Color"], function() pcUF:SetupAllBarColors() end},
								},
								furyBarColor = {
									name = L["Fury Bar Color"],
									desc = "desc",
									type = "color",
									order = 14,
									hasAlpha = true,
									get = getColor,
									set = setColor,
									arg = {"global", L["Fury Bar Color"], function() pcUF:SetupAllBarColors() end},
								},
								painBarColor = {
									name = L["Pain Bar Color"],
									desc = "desc",
									type = "color",
									order = 15,
									hasAlpha = true,
									get = getColor,
									set = setColor,
									arg = {"global", L["Pain Bar Color"], function() pcUF:SetupAllBarColors() end},
								},
								essenceBarColor = {
									name = L["Essence Bar Color"],
									desc = "desc",
									type = "color",
									order = 16,
									hasAlpha = true,
									get = getColor,
									set = setColor,
									arg = {"global", L["Essence Bar Color"], function() pcUF:SetupAllBarColors() end},
								},
								Reset = {
									name = L["Reset"],
									desc = "desc",
									type = "toggle",
									order = 16,
									set = function()
										pcUF.db.profile.global[L["Health Bar Color"]] = pcUF.defaults.profile.global[L["Health Bar Color"]]
										pcUF.db.profile.global[L["Mana Bar Color"]] = pcUF.defaults.profile.global[L["Mana Bar Color"]]
										pcUF.db.profile.global[L["Rage Bar Color"]] = pcUF.defaults.profile.global[L["Rage Bar Color"]]
										pcUF.db.profile.global[L["Focus Bar Color"]] = pcUF.defaults.profile.global[L["Focus Bar Color"]]
										pcUF.db.profile.global[L["Energy Bar Color"]] = pcUF.defaults.profile.global[L["Energy Bar Color"]]
										pcUF.db.profile.global[L["Chi Bar Color"]] = pcUF.defaults.profile.global[L["Chi Bar Color"]]
										pcUF.db.profile.global[L["Runes Bar Color"]] = pcUF.defaults.profile.global[L["Runes Bar Color"]]
										pcUF.db.profile.global[L["Runic Power Bar Color"]] = pcUF.defaults.profile.global[L["Runic Power Bar Color"]]
										pcUF.db.profile.global[L["Soul Shards Bar Color"]] = pcUF.defaults.profile.global[L["Soul Shards Bar Color"]]
										pcUF.db.profile.global[L["Astral Power Bar Color"]] = pcUF.defaults.profile.global[L["Astral Power Bar Color"]]
										pcUF.db.profile.global[L["Holy Power Bar Color"]] = pcUF.defaults.profile.global[L["Holy Power Bar Color"]]
										pcUF.db.profile.global[L["Maelstrom Bar Color"]] = pcUF.defaults.profile.global[L["Maelstrom Bar Color"]]
										pcUF.db.profile.global[L["Insanity Bar Color"]] = pcUF.defaults.profile.global[L["Insanity Bar Color"]]
										pcUF.db.profile.global[L["Fury Bar Color"]] = pcUF.defaults.profile.global[L["Fury Bar Color"]]
										pcUF.db.profile.global[L["Pain Bar Color"]] = pcUF.defaults.profile.global[L["Pain Bar Color"]]
										pcUF.db.profile.global[L["Essence Bar Color"]] = pcUF.defaults.profile.global[L["Essence Bar Color"]]
										pcUF:SetupAllBarColors()
									end,
								},
							},
						},
						BarMisc = {
							name = L["Misc"],
							type= "group",
							order = 3,
							inline = true,
							args = {
								colorFramesByDebuff = {
									name = L["Color Frame By Debuff"],
									desc = "desc",
									type = "toggle",
									order = 1,
									get = getOption,
									set = setOption,
									arg = {"global", nil, L["Color Frame By Debuff"], function() if (UnitExists("target")) then pcUF:UNIT_AURA(nil, "target") end end},
								},
							},
						},
--						BackgroundColor = {
--							name = L["Background Color"],
--							desc = "desc",
--							type = "color",
--							order = 1,
--							hasAlpha = true,
--							get = getColor,
--							set = setColor,
--							arg = {"global", L["Background Color"], function() pcUF:SetupAllBorderBackground() end},
--						},
--						BorderColor = {
--							name = L["Border Color"],
--							desc = "desc",
--							type = "color",
--							order = 2,
--							hasAlpha = true,
--							get = getColor,
--							set = setColor,
--							arg = {"global", L["Border Color"], function() pcUF:SetupAllBorderBackground() end},
--						},
--						Reset = {
--							name = L["Reset"],
--							desc = "desc",
--							type = "toggle",
--							order = 3,
--							set = function()
--								pcUF.db.profile.global[L["Background Color"]].r = pcUF.defaults.profile.global[L["Background Color"]].r
--								pcUF.db.profile.global[L["Background Color"]].g = pcUF.defaults.profile.global[L["Background Color"]].g
--								pcUF.db.profile.global[L["Background Color"]].b = pcUF.defaults.profile.global[L["Background Color"]].b
--								pcUF.db.profile.global[L["Background Color"]].a = pcUF.defaults.profile.global[L["Background Color"]].a
--								pcUF.db.profile.global[L["Border Color"]].r = pcUF.defaults.profile.global[L["Border Color"]].r
--								pcUF.db.profile.global[L["Border Color"]].g = pcUF.defaults.profile.global[L["Border Color"]].g
--								pcUF.db.profile.global[L["Border Color"]].b = pcUF.defaults.profile.global[L["Border Color"]].b
--								pcUF.db.profile.global[L["Border Color"]].a = pcUF.defaults.profile.global[L["Border Color"]].a
--								pcUF:SetupAllBorderBackground()
--							end,
--						},
					},
				},
			},
		},
		modules = {
			name = L["Modules"],
			type = "group",
			order = 2,
			childGroups = "tab",
			args = {
				castbar = {
					name = L["CastBar"],
					type = "group",
					order = 1,
					--childGroups = "tab",
					args = {
						--more options go here
					},
				},
			},
		},
		focus = {
			name = L["Focus"],
			type = "group",
			order = 3,
			childGroups = "tab",
			args = {
				--more options go here
			},
		},
		focustarget = {
			name = L["Focus' Target"],
			type = "group",
			order = 4,
			childGroups = "tab",
			args = {
				--more options go here
			},
		},
		party = {
			name = L["Party"],
			type = "group",
			order = 5,
			childGroups = "tab",
			args = {
				--more options go here
			},
		},
		partypet = {
			name = L["Party Pets"],
			type = "group",
			order = 6,
			childGroups = "tab",
			args = {
				--more options go here
			},
		},
		partytarget = {
			name = L["Party Targets"],
			type = "group",
			order = 7,
			childGroups = "tab",
			args = {
				--more options go here
			},
		},
		player = {
			name = L["Player"],
			type = "group",
			order = 8,
			childGroups = "tab",
			args = {
				FrameAttributes = {
					name = L["Frame Attributes"],
					type = "group",
					order = 1,
					args = {
						enabled = {
							name = L["Enabled"],
							desc = "desc",
							type = "toggle",
							order = 1,
							get = getOption,
							set = setOption,
							arg = {"player", nil, L["Enabled"], function() pcUF:CreateRemoveFrames() end},
						},
						colorNamesByClass = {
							name = L["Color Names By Class"],
							desc = "desc",
							type = "toggle",
							--order = 1,
							get = getOption,
							set = setOption,
							arg = {"player", nil, L["Color Names By Class"], function() if (UnitExists("player")) then pcUF:UNIT_FACTION(nil, "player") end end},
						},
						showPvPStatusIcon = {
							name = L["Show PvP Status Icon"],
							desc = "desc",
							type = "toggle",
							--order = 1,
							get = getOption,
							set = setOption,
							arg = {"player", nil, L["Show PvP Status Icon"], function() if (UnitExists("player")) then pcUF:UNIT_FACTION(nil, "player") end end},
						},
					},
				},
				Buffs = {
					name = L["Buffs"],
					type = "group",
					order = 2,
					args = {
						numberOfBuffs = {
							name = L["Number of Buffs"],
							desc = "desc",
							type = "range",
							order = 1,
							min = 0,
							max = 20,
							step = 1,
							get = getOption,
							set = setOption,
							arg = {"player", "buffs", L["Number of Buffs"], function() pcUF:ResetBuffsAndDebuffs("player") if (UnitExists("player")) then pcUF:UNIT_AURA(nil, "player") end end},
						},
						buffsPerRow = {
							name = L["Buffs Per Row"],
							desc = "desc",
							type = "range",
							order = 2,
							min = 1,
							max = 20,
							step = 1,
							get = getOption,
							set = setOption,
							arg = {"player", "buffs", L["Buffs Per Row"], function() pcUF:LayoutBuffs(nil, "player", "buffs") if (UnitExists("player")) then pcUF:UNIT_AURA(nil, "player") end end},
						},
						horizontalSpacing = {
							name = L["Horizontal Spacing"],
							desc = "desc",
							type = "range",
							order = 3,
							min = 0,
							max = 20,
							step = 1,
							get = getOption,
							set = setOption,
							arg = {"player", "buffs", L["Horizontal Spacing"], function() pcUF:LayoutBuffs(nil, "player", "buffs") if (UnitExists("player")) then pcUF:UNIT_AURA(nil, "player") end end},
						},
						verticalSpacing = {
							name = L["Vertical Spacing"],
							desc = "desc",
							type = "range",
							order = 4,
							min = -20,
							max = 0,
							step = 1,
							get = getOption,
							set = setOption,
							arg = {"player", "buffs", L["Vertical Spacing"], function() pcUF:LayoutBuffs(nil, "player", "buffs") if (UnitExists("player")) then pcUF:UNIT_AURA(nil, "player") end end},
						},
						xOffset = {
							name = L["X Offset"],
							desc = "desc",
							type = "range",
							order = 5,
							min = -50,
							max = 50,
							step = 1,
							get = getOption,
							set = setOption,
							arg = {"player", "buffs", L["X Offset"], function() pcUF:LayoutBuffs(nil, "player", "buffs") if (UnitExists("player")) then pcUF:UNIT_AURA(nil, "player") end end},
						},
						yOffset = {
							name = L["Y Offset"],
							desc = "desc",
							type = "range",
							order = 6,
							min = -50,
							max = 50,
							step = 1,
							get = getOption,
							set = setOption,
							arg = {"player", "buffs", L["Y Offset"], function() pcUF:LayoutBuffs(nil, "player", "buffs") if (UnitExists("player")) then pcUF:UNIT_AURA(nil, "player") end end},
						},
						position = {
							name = L["Position"],
							desc = "desc",
							type = "select",
							style = "dropdown",
							order = 7,
							get = getOption,
							set = setOption,
							values = anchorPoints,
							arg = {"player", "buffs", L["Position"], function() pcUF:LayoutBuffs(nil, "player", "buffs") if (UnitExists("player")) then pcUF:UNIT_AURA(nil, "player") end end},
						},
						growUpwards = {
							name = L["Grow Upwards"],
							desc = "desc",
							type = "toggle",
							order = 8,
							get = getOption,
							set = setOption,
							arg = {"player", "buffs", L["Grow Upwards"], function() pcUF:LayoutBuffs(nil, "player", "buffs") if (UnitExists("player")) then pcUF:UNIT_AURA(nil, "player") end end},
						},
						expandLeft = {
							name = L["Expand Left"],
							desc = "desc",
							type = "toggle",
							order = 9,
							get = getOption,
							set = setOption,
							arg = {"player", "buffs", L["Expand Left"], function() pcUF:LayoutBuffs(nil, "player", "buffs") if (UnitExists("player")) then pcUF:UNIT_AURA(nil, "player") end end},
						},
						showCooldownModels = {
							name = L["Show Cooldown Models"],
							desc = "desc",
							type = "toggle",
							order = 10,
							get = getOption,
							set = setOption,
							arg = {"player", "buffs", L["Show Cooldown Models"], function() pcUF:ResetBuffsAndDebuffs("player") if (UnitExists("player")) then pcUF:UNIT_AURA(nil, "player") end end},
						},
						classicBuffDebuffMode = {
							name = L["Classic Buff & Debuff Mode"],
							desc = "desc",
							type = "toggle",
							order = 11,
							get = getOption,
							set = setOption,
							arg = {"player", nil, L["Classic Buff & Debuff Mode"], function() pcUF:LayoutBuffs(nil, "player", "buffs") pcUF:LayoutBuffs(nil, "player", "debuffs") if (UnitExists("player")) then pcUF:UNIT_AURA(nil, "player") end end},
						},
					},
				},
				Debuffs = {
					name = L["Debuffs"],
					type = "group",
					order = 3,
					args = {
						numberOfDebuffs = {
							name = L["Number of Debuffs"],
							desc = "desc",
							type = "range",
							order = 1,
							min = 0,
							max = 20,
							step = 1,
							get = getOption,
							set = setOption,
							arg = {"player", "debuffs", L["Number of Debuffs"], function() pcUF:ResetBuffsAndDebuffs("player") if (UnitExists("player")) then pcUF:UNIT_AURA(nil, "player") end end},
						},
						buffsPerRow = {
							name = L["Debuffs Per Row"],
							desc = "desc",
							type = "range",
							order = 2,
							min = 1,
							max = 20,
							step = 1,
							get = getOption,
							set = setOption,
							arg = {"player", "debuffs", L["Buffs Per Row"], function() pcUF:LayoutBuffs(nil, "player", "debuffs") if (UnitExists("player")) then pcUF:UNIT_AURA(nil, "player") end end},
						},
						horizontalSpacing = {
							name = L["Horizontal Spacing"],
							desc = "desc",
							type = "range",
							order = 3,
							min = 0,
							max = 20,
							step = 1,
							get = getOption,
							set = setOption,
							arg = {"player", "debuffs", L["Horizontal Spacing"], function() pcUF:LayoutBuffs(nil, "player", "debuffs") if (UnitExists("player")) then pcUF:UNIT_AURA(nil, "player") end end},
						},
						verticalSpacing = {
							name = L["Vertical Spacing"],
							desc = "desc",
							type = "range",
							order = 4,
							min = -20,
							max = 0,
							step = 1,
							get = getOption,
							set = setOption,
							arg = {"player", "debuffs", L["Vertical Spacing"], function() pcUF:LayoutBuffs(nil, "player", "debuffs") if (UnitExists("player")) then pcUF:UNIT_AURA(nil, "player") end end},
						},
						xOffset = {
							name = L["X Offset"],
							desc = "desc",
							type = "range",
							order = 5,
							min = -50,
							max = 50,
							step = 1,
							get = getOption,
							set = setOption,
							arg = {"player", "debuffs", L["X Offset"], function() pcUF:LayoutBuffs(nil, "player", "debuffs") if (UnitExists("player")) then pcUF:UNIT_AURA(nil, "player") end end},
						},
						yOffset = {
							name = L["Y Offset"],
							desc = "desc",
							type = "range",
							order = 6,
							min = -50,
							max = 50,
							step = 1,
							get = getOption,
							set = setOption,
							arg = {"player", "debuffs", L["Y Offset"], function() pcUF:LayoutBuffs(nil, "player", "debuffs") if (UnitExists("player")) then pcUF:UNIT_AURA(nil, "player") end end},
						},
						position = {
							name = L["Position"],
							desc = "desc",
							type = "select",
							style = "dropdown",
							order = 7,
							get = getOption,
							set = setOption,
							values = anchorPoints,
							arg = {"player", "debuffs", L["Position"], function() pcUF:LayoutBuffs(nil, "player", "debuffs") if (UnitExists("player")) then pcUF:UNIT_AURA(nil, "player") end end},
						},
						growUpwards = {
							name = L["Grow Upwards"],
							desc = "desc",
							type = "toggle",
							order = 8,
							get = getOption,
							set = setOption,
							arg = {"player", "debuffs", L["Grow Upwards"], function() pcUF:LayoutBuffs(nil, "player", "debuffs") if (UnitExists("player")) then pcUF:UNIT_AURA(nil, "player") end end},
						},
						expandLeft = {
							name = L["Expand Left"],
							desc = "desc",
							type = "toggle",
							order = 9,
							get = getOption,
							set = setOption,
							arg = {"player", "debuffs", L["Expand Left"], function() pcUF:LayoutBuffs(nil, "player", "debuffs") if (UnitExists("player")) then pcUF:UNIT_AURA(nil, "player") end end},
						},
						showCooldownModels = {
							name = L["Show Cooldown Models"],
							desc = "desc",
							type = "toggle",
							order = 10,
							get = getOption,
							set = setOption,
							arg = {"player", "debuffs", L["Show Cooldown Models"], function() pcUF:ResetBuffsAndDebuffs("player") if (UnitExists("player")) then pcUF:UNIT_AURA(nil, "player") end end},
						},
						classicBuffDebuffMode = {
							name = L["Classic Buff & Debuff Mode"],
							desc = "desc",
							type = "toggle",
							order = 11,
							get = getOption,
							set = setOption,
							arg = {"player", nil, L["Classic Buff & Debuff Mode"], function() pcUF:LayoutBuffs(nil, "player", "buffs") pcUF:LayoutBuffs(nil, "player", "debuffs") if (UnitExists("player")) then pcUF:UNIT_AURA(nil, "player") end end},
						},
					},
				},
				Text = {
					name = L["Text"],
					type = "group",
					order = 4,
					args = {

					},
				},
			},
		},
		pet = {
			name = L["Player's Pet"],
			type = "group",
			order = 9,
			childGroups = "tab",
			args = {
				--more options go here
			},
		},
		pettarget = {
			--name = L["Target of Player's Pet"],
			name = "Player's Pet Target",
			type = "group",
			order = 10,
			childGroups = "tab",
			args = {
				--more options go here
			},
		},
		target = {
			name = L["Target"],
			type = "group",
			order = 11,
			childGroups = "tab",
			args = {
				FrameAttributes = {
					name = L["Frame Attributes"],
					type = "group",
					order = 1,
					args = {
						enabled = {
							name = L["Enabled"],
							desc = "desc",
							type = "toggle",
							order = 1,
							get = getOption,
							set = setOption,
							arg = {"target", nil, L["Enabled"], function() pcUF:CreateRemoveFrames() end},
						},
						colorNamesByClass = {
							name = L["Color Names By Class"],
							desc = "desc",
							type = "toggle",
							--order = 1,
							get = getOption,
							set = setOption,
							arg = {"target", nil, L["Color Names By Class"], function() if (UnitExists("target")) then pcUF:UNIT_FACTION(nil, "target") end end},
						},
						showPvPStatusIcon = {
							name = L["Show PvP Status Icon"],
							desc = "desc",
							type = "toggle",
							--order = 1,
							get = getOption,
							set = setOption,
							arg = {"target", nil, L["Show PvP Status Icon"], function() if (UnitExists("target")) then pcUF:UNIT_FACTION(nil, "target") end end},
						},
					},
				},
				Buffs = {
					name = L["Buffs"],
					type = "group",
					order = 2,
					args = {
						numberOfBuffs = {
							name = L["Number of Buffs"],
							desc = "desc",
							type = "range",
							order = 1,
							min = 0,
							max = 20,
							step = 1,
							get = getOption,
							set = setOption,
							arg = {"target", "buffs", L["Number of Buffs"], function() pcUF:ResetBuffsAndDebuffs("target") if (UnitExists("target")) then pcUF:UNIT_AURA(nil, "target") end end},
						},
						buffsPerRow = {
							name = L["Buffs Per Row"],
							desc = "desc",
							type = "range",
							order = 2,
							min = 1,
							max = 20,
							step = 1,
							get = getOption,
							set = setOption,
							arg = {"target", "buffs", L["Buffs Per Row"], function() pcUF:LayoutBuffs(nil, "target", "buffs") if (UnitExists("target")) then pcUF:UNIT_AURA(nil, "target") end end},
						},
						horizontalSpacing = {
							name = L["Horizontal Spacing"],
							desc = "desc",
							type = "range",
							order = 3,
							min = 0,
							max = 20,
							step = 1,
							get = getOption,
							set = setOption,
							arg = {"target", "buffs", L["Horizontal Spacing"], function() pcUF:LayoutBuffs(nil, "target", "buffs") if (UnitExists("target")) then pcUF:UNIT_AURA(nil, "target") end end},
						},
						verticalSpacing = {
							name = L["Vertical Spacing"],
							desc = "desc",
							type = "range",
							order = 4,
							min = -20,
							max = 0,
							step = 1,
							get = getOption,
							set = setOption,
							arg = {"target", "buffs", L["Vertical Spacing"], function() pcUF:LayoutBuffs(nil, "target", "buffs") if (UnitExists("target")) then pcUF:UNIT_AURA(nil, "target") end end},
						},
						xOffset = {
							name = L["X Offset"],
							desc = "desc",
							type = "range",
							order = 5,
							min = -50,
							max = 50,
							step = 1,
							get = getOption,
							set = setOption,
							arg = {"target", "buffs", L["X Offset"], function() pcUF:LayoutBuffs(nil, "target", "buffs") if (UnitExists("target")) then pcUF:UNIT_AURA(nil, "target") end end},
						},
						yOffset = {
							name = L["Y Offset"],
							desc = "desc",
							type = "range",
							order = 6,
							min = -50,
							max = 50,
							step = 1,
							get = getOption,
							set = setOption,
							arg = {"target", "buffs", L["Y Offset"], function() pcUF:LayoutBuffs(nil, "target", "buffs") if (UnitExists("target")) then pcUF:UNIT_AURA(nil, "target") end end},
						},
						position = {
							name = L["Position"],
							desc = "desc",
							type = "select",
							style = "dropdown",
							order = 7,
							get = getOption,
							set = setOption,
							values = anchorPoints,
							arg = {"target", "buffs", L["Position"], function() pcUF:LayoutBuffs(nil, "target", "buffs") if (UnitExists("target")) then pcUF:UNIT_AURA(nil, "target") end end},
						},
						growUpwards = {
							name = L["Grow Upwards"],
							desc = "desc",
							type = "toggle",
							order = 8,
							get = getOption,
							set = setOption,
							arg = {"target", "buffs", L["Grow Upwards"], function() pcUF:LayoutBuffs(nil, "target", "buffs") if (UnitExists("target")) then pcUF:UNIT_AURA(nil, "player") end end},
						},
						expandLeft = {
							name = L["Expand Left"],
							desc = "desc",
							type = "toggle",
							order = 9,
							get = getOption,
							set = setOption,
							arg = {"target", "buffs", L["Expand Left"], function() pcUF:LayoutBuffs(nil, "target", "buffs") if (UnitExists("target")) then pcUF:UNIT_AURA(nil, "target") end end},
						},
						showCooldownModels = {
							name = L["Show Cooldown Models"],
							desc = "desc",
							type = "toggle",
							order = 10,
							get = getOption,
							set = setOption,
							arg = {"target", "buffs", L["Show Cooldown Models"], function() pcUF:ResetBuffsAndDebuffs("target") if (UnitExists("target")) then pcUF:UNIT_AURA(nil, "target") end end},
						},
						classicBuffDebuffMode = {
							name = L["Classic Buff & Debuff Mode"],
							desc = "desc",
							type = "toggle",
							order = 11,
							get = getOption,
							set = setOption,
							arg = {"target", nil, L["Classic Buff & Debuff Mode"], function() pcUF:LayoutBuffs(nil, "target", "buffs") if (UnitExists("target")) then pcUF:UNIT_AURA(nil, "target") end end},
						},
					},
				},
				Debuffs = {
					name = L["Debuffs"],
					type= "group",
					order = 3,
					args = {
						numberOfDebuffs = {
							name = L["Number of Debuffs"],
							desc = "desc",
							type = "range",
							order = 1,
							min = 0,
							max = 40,
							step = 1,
							get = getOption,
							set = setOption,
							arg = {"target", "debuffs", L["Number of Debuffs"], function() pcUF:ResetBuffsAndDebuffs("target") if (UnitExists("target")) then pcUF:UNIT_AURA(nil, "target") end end},
						},
						buffsPerRow = {
							name = L["Debuffs Per Row"],
							desc = "desc",
							type = "range",
							order = 2,
							min = 1,
							max = 20,
							step = 1,
							get = getOption,
							set = setOption,
							arg = {"target", "debuffs", L["Buffs Per Row"], function() pcUF:LayoutBuffs(nil, "target", "debuffs") if (UnitExists("target")) then pcUF:UNIT_AURA(nil, "target") end end},
						},
						horizontalSpacing = {
							name = L["Horizontal Spacing"],
							desc = "desc",
							type = "range",
							order = 3,
							min = 0,
							max = 20,
							step = 1,
							get = getOption,
							set = setOption,
							arg = {"target", "debuffs", L["Horizontal Spacing"], function() pcUF:LayoutBuffs(nil, "target", "debuffs") if (UnitExists("target")) then pcUF:UNIT_AURA(nil, "target") end end},
						},
						verticalSpacing = {
							name = L["Vertical Spacing"],
							desc = "desc",
							type = "range",
							order = 4,
							min = -20,
							max = 0,
							step = 1,
							get = getOption,
							set = setOption,
							arg = {"target", "debuffs", L["Vertical Spacing"], function() pcUF:LayoutBuffs(nil, "target", "debuffs") if (UnitExists("target")) then pcUF:UNIT_AURA(nil, "target") end end},
						},
						xOffset = {
							name = L["X Offset"],
							desc = "desc",
							type = "range",
							order = 5,
							min = -50,
							max = 50,
							step = 1,
							get = getOption,
							set = setOption,
							arg = {"target", "debuffs", L["X Offset"], function() pcUF:LayoutBuffs(nil, "target", "debuffs") if (UnitExists("target")) then pcUF:UNIT_AURA(nil, "target") end end},
						},
						yOffset = {
							name = L["Y Offset"],
							desc = "desc",
							type = "range",
							order = 6,
							min = -50,
							max = 50,
							step = 1,
							get = getOption,
							set = setOption,
							arg = {"target", "debuffs", L["Y Offset"], function() pcUF:LayoutBuffs(nil, "target", "debuffs") if (UnitExists("target")) then pcUF:UNIT_AURA(nil, "target") end end},
						},
						position = {
							name = L["Position"],
							desc = "desc",
							type = "select",
							style = "dropdown",
							order = 7,
							get = getOption,
							set = setOption,
							values = anchorPoints,
							arg = {"target", "debuffs", L["Position"], function() pcUF:LayoutBuffs(nil, "target", "debuffs") if (UnitExists("target")) then pcUF:UNIT_AURA(nil, "target") end end},
						},
						growUpwards = {
							name = L["Grow Upwards"],
							desc = "desc",
							type = "toggle",
							order = 8,
							get = getOption,
							set = setOption,
							arg = {"target", "debuffs", L["Grow Upwards"], function() pcUF:LayoutBuffs(nil, "target", "debuffs") if (UnitExists("target")) then pcUF:UNIT_AURA(nil, "target") end end},
						},
						expandLeft = {
							name = L["Expand Left"],
							desc = "desc",
							type = "toggle",
							order = 9,
							get = getOption,
							set = setOption,
							arg = {"target", "debuffs", L["Expand Left"], function() pcUF:LayoutBuffs(nil, "target", "debuffs") if (UnitExists("target")) then pcUF:UNIT_AURA(nil, "target") end end},
						},
						showCooldownModels = {
							name = L["Show Cooldown Models"],
							desc = "desc",
							type = "toggle",
							order = 10,
							get = getOption,
							set = setOption,
							arg = {"target", "debuffs", L["Show Cooldown Models"], function() pcUF:ResetBuffsAndDebuffs("target") if (UnitExists("target")) then pcUF:UNIT_AURA(nil, "target") end end},
						},
						classicBuffDebuffMode = {
							name = L["Classic Buff & Debuff Mode"],
							desc = "desc",
							type = "toggle",
							order = 11,
							get = getOption,
							set = setOption,
							arg = {"target", nil, L["Classic Buff & Debuff Mode"], function() pcUF:LayoutBuffs(nil, "target", "buffs") pcUF:LayoutBuffs(nil, "target", "debuffs") if (UnitExists("target")) then pcUF:UNIT_AURA(nil, "target") end end},
						},
					},
				},
				Text = {
					name = L["Text"],
					type = "group",
					order = 4,
					args = {

					},
				},
			},
		},
		targettarget = {
			name = L["Target's Target"],
			type = "group",
			order = 12,
			childGroups = "tab",
			args = {
				--more options go here
			},
		},
		targettargettarget = {
			--name = L["Target of Target's Target"],
			name = "Target's Target Target",
			type = "group",
			order = 13,
			childGroups = "tab",
			args = {
				--more options go here
			},
		},

	},
}

--pcUF.options = options
