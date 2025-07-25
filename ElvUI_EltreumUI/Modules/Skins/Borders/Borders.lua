local E = unpack(ElvUI)
local _G = _G
local A = E:GetModule('Auras')
local UF = E:GetModule('UnitFrames')
local CreateFrame = _G.CreateFrame
local hooksecurefunc = _G.hooksecurefunc
local BackdropTemplateMixin = _G.BackdropTemplateMixin
local table = _G.table
local pairs = _G.pairs
local UnitExists = _G.UnitExists
local UnitReaction = _G.UnitReaction
local IsAddOnLoaded = _G.C_AddOns and _G.C_AddOns.IsAddOnLoaded or _G.IsAddOnLoaded
local GetItemQualityColor = _G.C_Item and _G.C_Item.GetItemQualityColor or _G.GetItemQualityColor
local GetItemInfo = _G.C_Item and _G.C_Item.GetItemInfo or _G.GetItemInfo
local tostring = _G.tostring
local UnitIsPlayer = _G.UnitIsPlayer
local UnitClass = _G.UnitClass
local UnitInPartyIsAI = _G.UnitInPartyIsAI
local UnitPowerType = _G.UnitPowerType
local classcolor = E:ClassColor(E.myclass, true)
local classcolor2 = {}
local classcolor2check = false
local targetborder,targettargetborder,targetcastbarborder,petborder,playerborder,stanceborder,focuscastbarborder,arenaborder
local bordertexture,focusborder,bossborder,powerbarborder, playercastbarborder,petactionborder, experienceborder, threatborder
local playerclassbarborder1, playerclassbarborder2, comboborder, playerpowerborder, targetpowerborder, reputationborder
local barborder1,barborder2,barborder3,barborder4,barborder5,barborder6,partyborder,totemborderaction, altpowerborder, tooltipborder
local MinimapBorder,LeftChatBorder,RightChatBorder,totemborderfly,focustargetborder,targettargetpowerborder, focuspowerborder
local raid1borderholder,raid2borderholder,raid3borderholder,partyborderholder, comboborderholder, tankborderholder, assistborderholder = {},{},{},{},{},{},{}
local rectangleminimapdetect = CreateFrame("FRAME")
local updatelocationpos = CreateFrame("Frame")
local classcolorreaction = {
	["WARRIOR"] = {r1 = 0.77646887302399, g1 = 0.60784178972244, b1 = 0.4274500310421},
	["PALADIN"] = {r1 = 0.95686066150665, g1 = 0.54901838302612, b1 = 0.72941017150879},
	["HUNTER"] = {r1 = 0.66666519641876, g1 = 0.82744914293289, b1 = 0.44705784320831},
	["ROGUE"] = {r1 = 0.99999779462814, g1 = 0.95686066150665, b1 = 0.40784224867821},
	["PRIEST"] = {r1 = 0.99999779462814, g1 = 0.99999779462814, b1 = 0.99999779462814},
	["DEATHKNIGHT"] = {r1 = 0.76862573623657, g1 = 0.11764679849148, b1 = 0.2274504750967},
	["SHAMAN"] = {r1 = 0, g1 = 0.4392147064209, b1 = 0.86666476726532},
	["MAGE"] = {r1 = 0.24705828726292, g1 = 0.78039044141769, b1 = 0.92156660556793},
	["WARLOCK"] = {r1 = 0.52941060066223, g1 = 0.53333216905594, b1 = 0.93333131074905},
	["MONK"] = {r1 = 0, g1 = 0.99999779462814, b1 = 0.59607714414597},
	["DRUID"] = {r1 = 0.99999779462814, g1 = 0.48627343773842, b1 = 0.039215601980686},
	["DEMONHUNTER"] = {r1 = 0.63921427726746, g1 = 0.1882348805666, b1 = 0.78823357820511},
	["EVOKER"] = {r1 = 0.19607843137255, g1 = 0.46666666666667, b1 = 0.53725490196078},
	["NPCFRIENDLY"] = {r1 = 0.2, g1 = 1, b1 = 0.2},
	["NPCNEUTRAL"] = {r1 = 0.89, g1 = 0.89, b1 = 0},
	["NPCUNFRIENDLY"] = {r1 = 0.94, g1 = 0.37, b1 = 0},
	["NPCHOSTILE"] = {r1 = 0.8, g1 = 0, b1 = 0},
}
function ElvUI_EltreumUI:GetClassColorsRGB(unitclass)
	return {r = classcolorreaction[unitclass]["r1"], g= classcolorreaction[unitclass]["g1"],b = classcolorreaction[unitclass]["b1"]}
end

local PowerReadjust = {
	["offset"] = true,
	["spaced"] = true,
}

function ElvUI_EltreumUI:GetBorderClassColors()
	if E.db.ElvUI_EltreumUI.borders.classcolor then
		classcolor = E:ClassColor(E.myclass, true)
	elseif not E.db.ElvUI_EltreumUI.borders.classcolor then
		classcolor = {
			r = E.db.ElvUI_EltreumUI.borders.bordercolors.r,
			g = E.db.ElvUI_EltreumUI.borders.bordercolors.g,
			b = E.db.ElvUI_EltreumUI.borders.bordercolors.b
		}
	end
end

function ElvUI_EltreumUI:GetButtonCasterForBorderColor(button)
	if E.db.ElvUI_EltreumUI.borders.classcolor then
		if button.caster then
			if UnitIsPlayer(button.caster) or (E.Retail and UnitInPartyIsAI(button.caster)) then
				local _, classunit = UnitClass(button.caster)
				classcolor2 = E:ClassColor(classunit, true)
				classcolor2check = true
			else
				local reactiontarget = UnitReaction(button.caster, "player")
				if reactiontarget then
					if reactiontarget >= 5 then
						classcolor2 = ElvUI_EltreumUI:GetClassColorsRGB("NPCFRIENDLY")
					elseif reactiontarget == 4 then
						classcolor2 = ElvUI_EltreumUI:GetClassColorsRGB("NPCNEUTRAL")
					elseif reactiontarget == 3 then
						classcolor2 = ElvUI_EltreumUI:GetClassColorsRGB("NPCUNFRIENDLY")
					elseif reactiontarget == 2 or reactiontarget == 1 then
						classcolor2 = ElvUI_EltreumUI:GetClassColorsRGB("NPCHOSTILE")
					end
				else
					classcolor2 = ElvUI_EltreumUI:GetClassColorsRGB("SHAMAN")
				end
			end
		else
			classcolor2 = {}
			classcolor2check = false
		end
	else
		classcolor2check = false
	end
end

local function BordersPart1()
	--elvui unitframes
	if E.private.unitframe.enable then

		--player
		if E.db.ElvUI_EltreumUI.borders.playerborder and E.db.unitframe.units.player.enable then
			if not _G["EltruismPlayerBorder"] then
				playerborder = CreateFrame("Frame", "EltruismPlayerBorder", _G.ElvUF_Player_HealthBar, BackdropTemplateMixin and "BackdropTemplate")
			else
				playerborder = _G["EltruismPlayerBorder"]
			end
			playerborder:SetSize(E.db.ElvUI_EltreumUI.borders.xplayer, E.db.ElvUI_EltreumUI.borders.yplayer)
			if PowerReadjust[E.db.unitframe.units.player.power.width] then
				playerborder:SetPoint("CENTER", _G.ElvUF_Player_HealthBar, "CENTER", 0, 0)
			else
				playerborder:SetPoint("CENTER", _G.ElvUF_Player, "CENTER", 0, 0)
			end
			playerborder:SetBackdrop({
				edgeFile = bordertexture,
				edgeSize = E.db.ElvUI_EltreumUI.borders.playertargetsize,
			})
			playerborder:SetBackdropBorderColor(classcolor.r, classcolor.g, classcolor.b, 1)
			playerborder:SetFrameStrata(E.db.ElvUI_EltreumUI.borders.playerstrata)
			playerborder:SetFrameLevel(E.db.ElvUI_EltreumUI.borders.playerlevel)
			if E.db.ElvUI_EltreumUI.unitframes.infopanelontop and E.db.unitframe.units.player.infoPanel.enable then
				playerborder:SetPoint("CENTER", _G.ElvUF_Player, "CENTER", 0, E.db.unitframe.units.player.infoPanel.height)
			end
		end

		--player classbar
		if E.db.unitframe.units.player.classbar.enable then
			if _G["ElvUF_Player_AdditionalPowerBar"] and E.db.ElvUI_EltreumUI.borders.alternativeclassbar then
				if not _G["EltruismClassBarBorder1"] then
					playerclassbarborder1 = CreateFrame("Frame", "EltruismClassBarBorder1", _G.ElvUF_Player_HealthBar, BackdropTemplateMixin and "BackdropTemplate")
				else
					playerclassbarborder1 = _G["EltruismClassBarBorder1"]
				end
				playerclassbarborder1:SetSize(E.db.ElvUI_EltreumUI.borders.alternativeclassbarxborder, E.db.ElvUI_EltreumUI.borders.alternativeclassbaryborder)
				playerclassbarborder1:SetPoint("CENTER", _G.ElvUF_Player_AdditionalPowerBar, "CENTER", 0, 0)
				playerclassbarborder1:SetParent(_G.ElvUF_Player_AdditionalPowerBar)
				playerclassbarborder1:SetBackdrop({
					edgeFile = bordertexture,
					edgeSize = E.db.ElvUI_EltreumUI.borders.playertargetsize,
				})
				playerclassbarborder1:SetBackdropBorderColor(classcolor.r, classcolor.g, classcolor.b, 1)
				playerclassbarborder1:SetFrameStrata(E.db.ElvUI_EltreumUI.borders.alternativeclassbarstrata)
				playerclassbarborder1:SetFrameLevel(E.db.ElvUI_EltreumUI.borders.alternativeclassbarlevel)
			end

			if _G["ElvUF_Player_Stagger"] and E.db.ElvUI_EltreumUI.borders.staggerclassbar then
				if not _G["EltruismClassBarBorder2"] then
					playerclassbarborder2 = CreateFrame("Frame", "EltruismClassBarBorder2", _G.ElvUF_Player_HealthBar, BackdropTemplateMixin and "BackdropTemplate")
				else
					playerclassbarborder2 = _G["EltruismClassBarBorder2"]
				end
				playerclassbarborder2:SetSize(E.db.ElvUI_EltreumUI.borders.staggerclassbarxborder, E.db.ElvUI_EltreumUI.borders.staggerclassbaryborder)
				playerclassbarborder2:SetPoint("CENTER", _G.ElvUF_Player_Stagger, "CENTER", 0, 0)
				playerclassbarborder2:SetParent(_G.ElvUF_Player_Stagger)
				playerclassbarborder2:SetBackdrop({
					edgeFile = bordertexture,
					edgeSize = E.db.ElvUI_EltreumUI.borders.playertargetsize,
				})
				playerclassbarborder2:SetBackdropBorderColor(classcolor.r, classcolor.g, classcolor.b, 1)
				playerclassbarborder2:SetFrameStrata(E.db.ElvUI_EltreumUI.borders.staggerclassbarstrata)
				playerclassbarborder2:SetFrameLevel(E.db.ElvUI_EltreumUI.borders.staggerclassbarlevel)
			end

			if E.db.ElvUI_EltreumUI.borders.comboclassbar then
				if E.db.unitframe.units.player.classbar.fill == "spaced" then
					if _G["ElvUF_Player_ClassBar"] then
						for i = 1, _G["ElvUF_Player_ClassBar"].__max do
							if _G["ElvUF_PlayerClassIconButton"..i] and _G["ElvUF_PlayerClassIconButton"..i].backdrop then
								if not _G["EltruismComboClassBarBorder"..i] then
									comboborder = CreateFrame("Frame", "EltruismComboClassBarBorder"..i, _G["ElvUF_PlayerClassIconButton"..i].backdrop, BackdropTemplateMixin and "BackdropTemplate")
								else
									comboborder = _G["EltruismComboClassBarBorder"..i]
								end
								comboborder:SetSize(E.db.ElvUI_EltreumUI.borders.combosizex, E.db.ElvUI_EltreumUI.borders.combosizey)
								comboborder:SetPoint("CENTER", _G["ElvUF_PlayerClassIconButton"..i].backdrop, "CENTER")
								comboborder:SetParent(_G["ElvUF_PlayerClassIconButton"..i].backdrop)
								table.insert(comboborderholder, comboborder)
								comboborder:SetBackdrop({
									edgeFile = bordertexture,
									edgeSize = E.db.ElvUI_EltreumUI.borders.playertargetsize,
								})
								comboborder:SetBackdropBorderColor(classcolor.r, classcolor.g, classcolor.b, 1)
								comboborder:SetFrameStrata(E.db.ElvUI_EltreumUI.borders.combostrata)
								comboborder:SetFrameLevel(E.db.ElvUI_EltreumUI.borders.combolevel)
							end
						end
					end

					if _G["ElvUF_Player_Runes"] then
						for i = 1, 6 do
							if _G["ElvUF_PlayerRuneButton"..i] and _G["ElvUF_PlayerRuneButton"..i].backdrop then
								if not _G["EltruismRuneClassBarBorder"..i] then
									comboborder = CreateFrame("Frame", "EltruismRuneClassBarBorder"..i, _G["ElvUF_PlayerRuneButton"..i].backdrop, BackdropTemplateMixin and "BackdropTemplate")
								else
									comboborder = _G["EltruismRuneClassBarBorder"..i]
								end
								comboborder:SetSize(E.db.ElvUI_EltreumUI.borders.combosizex, E.db.ElvUI_EltreumUI.borders.combosizey)
								comboborder:SetPoint("CENTER", _G["ElvUF_PlayerRuneButton"..i].backdrop, "CENTER")
								comboborder:SetParent(_G["ElvUF_PlayerRuneButton"..i].backdrop)
								table.insert(comboborderholder, comboborder)
								comboborder:SetBackdrop({
									edgeFile = bordertexture,
									edgeSize = E.db.ElvUI_EltreumUI.borders.playertargetsize,
								})
								comboborder:SetBackdropBorderColor(classcolor.r, classcolor.g, classcolor.b, 1)
								comboborder:SetFrameStrata(E.db.ElvUI_EltreumUI.borders.combostrata)
								comboborder:SetFrameLevel(E.db.ElvUI_EltreumUI.borders.combolevel)
							end
						end
					end

					if _G["ElvUF_Player"] and _G["ElvUF_Player"].Totems then
						for i = 1, 4 do
							if _G["ElvUF_PlayerTotem"..i] and _G["ElvUF_PlayerTotem"..i].backdrop then
								if not _G["EltruismTotemBorder"..i] then
									comboborder = CreateFrame("Frame", "EltruismTotemBorder"..i, _G["ElvUF_PlayerTotem"..i].backdrop, BackdropTemplateMixin and "BackdropTemplate")
								else
									comboborder = _G["EltruismTotemBorder"..i]
								end
								comboborder:SetSize(E.db.ElvUI_EltreumUI.borders.combosizex, E.db.ElvUI_EltreumUI.borders.combosizey)
								comboborder:SetPoint("CENTER", _G["ElvUF_PlayerTotem"..i].backdrop, "CENTER")
								comboborder:SetParent(_G["ElvUF_PlayerTotem"..i].backdrop)
								table.insert(comboborderholder, comboborder)
								comboborder:SetBackdrop({
									edgeFile = bordertexture,
									edgeSize = E.db.ElvUI_EltreumUI.borders.playertargetsize,
								})
								comboborder:SetBackdropBorderColor(classcolor.r, classcolor.g, classcolor.b, 1)
								comboborder:SetFrameStrata(E.db.ElvUI_EltreumUI.borders.combostrata)
								comboborder:SetFrameLevel(E.db.ElvUI_EltreumUI.borders.combolevel)
							end
						end
					end
				else
					if E.db.unitframe.units.player.classbar.detachFromFrame then
						if _G["ElvUF_Player_ClassBar"] and _G["ElvUF_Player_ClassBar"].backdrop then
							if not _G["EltruismComboClassBarBorder"] then
								comboborder = CreateFrame("Frame", "EltruismComboClassBarBorder", _G["ElvUF_Player_ClassBar"].backdrop, BackdropTemplateMixin and "BackdropTemplate")
							else
								comboborder = _G["EltruismComboClassBarBorder"]
							end
							comboborder:SetSize(E.db.ElvUI_EltreumUI.borders.combosizex, E.db.ElvUI_EltreumUI.borders.combosizey)
							comboborder:SetPoint("CENTER", _G["ElvUF_Player_ClassBar"].backdrop, "CENTER")
							comboborder:SetParent(_G["ElvUF_Player_ClassBar"].backdrop)
							table.insert(comboborderholder, comboborder)
							comboborder:SetBackdrop({
								edgeFile = bordertexture,
								edgeSize = E.db.ElvUI_EltreumUI.borders.playertargetsize,
							})
							comboborder:SetBackdropBorderColor(classcolor.r, classcolor.g, classcolor.b, 1)
							comboborder:SetFrameStrata(E.db.ElvUI_EltreumUI.borders.combostrata)
							comboborder:SetFrameLevel(E.db.ElvUI_EltreumUI.borders.combolevel)
						end

						if _G["ElvUF_Player_Runes"] and _G["ElvUF_Player_Runes"].backdrop then
							if not _G["EltruismRuneClassBarBorder"] then
								comboborder = CreateFrame("Frame", "EltruismRuneClassBarBorder", _G["ElvUF_Player_Runes"].backdrop, BackdropTemplateMixin and "BackdropTemplate")
							else
								comboborder = _G["EltruismRuneClassBarBorder"]
							end
							comboborder:SetSize(E.db.ElvUI_EltreumUI.borders.combosizex, E.db.ElvUI_EltreumUI.borders.combosizey)
							comboborder:SetPoint("CENTER", _G["ElvUF_Player_Runes"].backdrop, "CENTER")
							comboborder:SetParent(_G["ElvUF_Player_Runes"].backdrop)
							table.insert(comboborderholder, comboborder)
							comboborder:SetBackdrop({
								edgeFile = bordertexture,
								edgeSize = E.db.ElvUI_EltreumUI.borders.playertargetsize,
							})
							comboborder:SetBackdropBorderColor(classcolor.r, classcolor.g, classcolor.b, 1)
							comboborder:SetFrameStrata(E.db.ElvUI_EltreumUI.borders.combostrata)
							comboborder:SetFrameLevel(E.db.ElvUI_EltreumUI.borders.combolevel)
						end

						if _G["ElvUF_Player"] and _G["ElvUF_Player"].Totems and _G["ElvUF_Player"].Totems.backdrop then
							if not _G["EltruismTotemBorder"] then
								comboborder = CreateFrame("Frame", "EltruismTotemBorder", _G["ElvUF_Player"].Totems.backdrop, BackdropTemplateMixin and "BackdropTemplate")
							else
								comboborder = _G["EltruismTotemBorder"]
							end
							comboborder:SetSize(E.db.ElvUI_EltreumUI.borders.combosizex, E.db.ElvUI_EltreumUI.borders.combosizey)
							comboborder:SetPoint("CENTER", _G["ElvUF_Player"].Totems.backdrop, "CENTER")
							comboborder:SetParent(_G["ElvUF_Player"].Totems.backdrop)
							table.insert(comboborderholder, comboborder)
							comboborder:SetBackdrop({
								edgeFile = bordertexture,
								edgeSize = E.db.ElvUI_EltreumUI.borders.playertargetsize,
							})
							comboborder:SetBackdropBorderColor(classcolor.r, classcolor.g, classcolor.b, 1)
							comboborder:SetFrameStrata(E.db.ElvUI_EltreumUI.borders.combostrata)
							comboborder:SetFrameLevel(E.db.ElvUI_EltreumUI.borders.combolevel)
						end
					end
				end
			end
		end

		--player power
		if E.db.unitframe.units.player.power.enable and (E.db.unitframe.units.player.power.width == "spaced" or E.db.unitframe.units.player.power.detachFromFrame) then
			if _G["ElvUF_Player_PowerBar"] and E.db.ElvUI_EltreumUI.borders.playerpower then
				if not _G["EltruismPlayerPowerBorder"] then
					playerpowerborder = CreateFrame("Frame", "EltruismPlayerPowerBorder", _G.ElvUF_Player_PowerBar, BackdropTemplateMixin and "BackdropTemplate")
				else
					playerpowerborder = _G["EltruismPlayerPowerBorder"]
				end
				playerpowerborder:SetSize(E.db.ElvUI_EltreumUI.borders.playerpowersizex, E.db.ElvUI_EltreumUI.borders.playerpowersizey)
				playerpowerborder:SetPoint("CENTER", _G.ElvUF_Player_PowerBar, "CENTER", 0, 0)
				playerpowerborder:SetParent(_G.ElvUF_Player_PowerBar)
				playerpowerborder:SetBackdrop({
					edgeFile = bordertexture,
					edgeSize = E.db.ElvUI_EltreumUI.borders.playertargetsize,
				})
				if E.db.ElvUI_EltreumUI.borders.classcolor then
					local _, powertype = UnitPowerType("player")
					if E.db.unitframe.colors.power[powertype] then
						playerpowerborder:SetBackdropBorderColor(E.db.unitframe.colors.power[powertype].r, E.db.unitframe.colors.power[powertype].g, E.db.unitframe.colors.power[powertype].b, 1)
					else
						playerpowerborder:SetBackdropBorderColor(classcolor.r, classcolor.g, classcolor.b, 1)
					end
				else
					playerpowerborder:SetBackdropBorderColor(classcolor.r, classcolor.g, classcolor.b, 1)
				end
				playerpowerborder:SetFrameStrata(E.db.ElvUI_EltreumUI.borders.playerpowerstrata)
				playerpowerborder:SetFrameLevel(E.db.ElvUI_EltreumUI.borders.playerpowerlevel)
			end
		end

		--player castbar
		if E.db.ElvUI_EltreumUI.borders.playercastborder and E.db.unitframe.units.player.castbar.enable and E.db.unitframe.units.player.castbar.overlayOnFrame == "None" then
			if not _G["EltruismPlayerCastBarBorder"] then
				playercastbarborder = CreateFrame("Frame", "EltruismPlayerCastBarBorder", _G.ElvUF_Player_CastBar, BackdropTemplateMixin and "BackdropTemplate")
			else
				playercastbarborder = _G["EltruismPlayerCastBarBorder"]
			end
			if E.db.unitframe.units.player.castbar.icon then
				if not E.db.unitframe.units.player.castbar.iconAttached then
					playercastbarborder:SetSize(E.db.ElvUI_EltreumUI.borders.xplayercast + E.db.unitframe.units.player.castbar.iconSize, E.db.ElvUI_EltreumUI.borders.yplayercast)
					if E.db.unitframe.units.player.castbar.iconXOffset == 0 then
						if E.db.unitframe.units.player.castbar.iconPosition == "RIGHT" then
							playercastbarborder:SetPoint("CENTER", _G["ElvUF_Player_CastBar"], "CENTER", E.db.unitframe.units.player.castbar.iconSize/2, 0)
						elseif E.db.unitframe.units.player.castbar.iconPosition == "LEFT" then
							playercastbarborder:SetPoint("CENTER", _G["ElvUF_Player_CastBar"], "CENTER", -E.db.unitframe.units.player.castbar.iconSize/2, 0)
						end
					else
						playercastbarborder:SetPoint("CENTER", _G["ElvUF_Player_CastBar"], "CENTER", 0, 0)
					end
				elseif E.db.unitframe.units.player.castbar.iconAttached ~= false then
					playercastbarborder:SetSize(E.db.ElvUI_EltreumUI.borders.xplayercast, E.db.ElvUI_EltreumUI.borders.yplayercast)
					--playercastbarborder:SetPoint("CENTER", _G["ElvUF_Player_CastBar"], "CENTER", -E.db.unitframe.units.player.castbar.iconSize/2, 0)
					playercastbarborder:SetPoint("CENTER", _G["ElvUF_Player_CastBar"].Holder, "CENTER", 0, 0)
				end
			else
				playercastbarborder:SetSize(E.db.ElvUI_EltreumUI.borders.xplayercast, E.db.ElvUI_EltreumUI.borders.yplayercast)
				playercastbarborder:SetPoint("CENTER", _G["ElvUF_Player_CastBar"], "CENTER", 0, 0)
			end
			playercastbarborder:SetBackdrop({
				edgeFile = bordertexture,
				edgeSize = E.db.ElvUI_EltreumUI.borders.playertargetcastsize,
			})
			playercastbarborder:SetBackdropBorderColor(classcolor.r, classcolor.g, classcolor.b, 1)
			playercastbarborder:SetFrameStrata(E.db.ElvUI_EltreumUI.borders.playercaststrata)
			playercastbarborder:SetFrameLevel(E.db.ElvUI_EltreumUI.borders.playercastlevel)
		end

		--target
		if E.db.ElvUI_EltreumUI.borders.targetborder and E.db.unitframe.units.target.enable then
			if not _G["EltruismTargetBorder"] then
				targetborder = CreateFrame("Frame", "EltruismTargetBorder", _G.ElvUF_Target_HealthBar, BackdropTemplateMixin and "BackdropTemplate")
			else
				targetborder = _G["EltruismTargetBorder"]
			end
			targetborder:SetSize(E.db.ElvUI_EltreumUI.borders.xtarget, E.db.ElvUI_EltreumUI.borders.ytarget)
			if PowerReadjust[E.db.unitframe.units.target.power.width] then
				targetborder:SetPoint("CENTER", _G.ElvUF_Target_HealthBar, "CENTER", 0 ,0)
			else
				targetborder:SetPoint("CENTER", _G.ElvUF_Target, "CENTER", 0 ,0)
			end
			targetborder:SetBackdrop({
				edgeFile = bordertexture,
				edgeSize = E.db.ElvUI_EltreumUI.borders.playertargetsize,
			})
			targetborder:SetBackdropBorderColor(classcolor.r, classcolor.g, classcolor.b, 1)
			targetborder:SetFrameStrata(E.db.ElvUI_EltreumUI.borders.targetstrata)
			targetborder:SetFrameLevel(E.db.ElvUI_EltreumUI.borders.targetlevel)

			if E.db.ElvUI_EltreumUI.unitframes.infopanelontop and E.db.unitframe.units.target.infoPanel.enable then
				targetborder:SetPoint("CENTER", _G.ElvUF_Target, "CENTER", 0, E.db.unitframe.units.target.infoPanel.height)
			end
		end

		--target castbar
		if E.db.ElvUI_EltreumUI.borders.targetcastborder and E.db.unitframe.units.target.castbar.enable and E.db.unitframe.units.target.castbar.overlayOnFrame == "None" then
			if not _G["EltruismTargetCastBarBorder"] then
				targetcastbarborder = CreateFrame("Frame", "EltruismTargetCastBarBorder", _G.ElvUF_Target_CastBar, BackdropTemplateMixin and "BackdropTemplate")
			else
				targetcastbarborder = _G["EltruismTargetCastBarBorder"]
			end
			if E.db.unitframe.units.target.castbar.icon then
				if not E.db.unitframe.units.target.castbar.iconAttached then
					targetcastbarborder:SetSize(E.db.ElvUI_EltreumUI.borders.xcasttarget + E.db.unitframe.units.target.castbar.iconSize, E.db.ElvUI_EltreumUI.borders.ycasttarget)
					if E.db.unitframe.units.target.castbar.iconXOffset == 0 then
						if E.db.unitframe.units.target.castbar.iconPosition == "RIGHT" then
							targetcastbarborder:SetPoint("CENTER", _G["ElvUF_Target_CastBar"], "CENTER", E.db.unitframe.units.target.castbar.iconSize/2, 0)
						elseif E.db.unitframe.units.target.castbar.iconPosition == "LEFT" then
							targetcastbarborder:SetPoint("CENTER", _G["ElvUF_Target_CastBar"], "CENTER", -E.db.unitframe.units.target.castbar.iconSize/2, 0)
						end
					else
						targetcastbarborder:SetPoint("CENTER", _G["ElvUF_Target_CastBar"], "CENTER", 0, 0)
					end
				elseif E.db.unitframe.units.target.castbar.iconAttached ~= false then
					targetcastbarborder:SetSize(E.db.ElvUI_EltreumUI.borders.xcasttarget, E.db.ElvUI_EltreumUI.borders.ycasttarget)
					--targetcastbarborder:SetPoint("CENTER", _G["ElvUF_Target_CastBar"], "CENTER", -E.db.unitframe.units.target.castbar.iconSize/2, 0)
					targetcastbarborder:SetPoint("CENTER", _G["ElvUF_Target_CastBar"].Holder, "CENTER", 0, 0)
				end
			else
				targetcastbarborder:SetSize(E.db.ElvUI_EltreumUI.borders.xcasttarget, E.db.ElvUI_EltreumUI.borders.ycasttarget)
				targetcastbarborder:SetPoint("CENTER", _G["ElvUF_Target_CastBar"].Holder, "CENTER", 0, 0)
			end
			targetcastbarborder:SetBackdrop({
				edgeFile = bordertexture,
				edgeSize = E.db.ElvUI_EltreumUI.borders.playertargetcastsize,
			})
			targetcastbarborder:SetBackdropBorderColor(classcolor.r, classcolor.g, classcolor.b, 1)
			targetcastbarborder:SetFrameStrata(E.db.ElvUI_EltreumUI.borders.targetcaststrata)
			targetcastbarborder:SetFrameLevel(E.db.ElvUI_EltreumUI.borders.targetcastlevel)
		end

		--target power
		if E.db.unitframe.units.target.power.enable and (E.db.unitframe.units.target.power.width == "spaced" or E.db.unitframe.units.target.power.detachFromFrame) then
			if _G["ElvUF_Target_PowerBar"] and E.db.ElvUI_EltreumUI.borders.targetpower then
				if not _G["EltruismTargetPowerBorder"] then
					targetpowerborder = CreateFrame("Frame", "EltruismTargetPowerBorder", _G.ElvUF_Target_PowerBar, BackdropTemplateMixin and "BackdropTemplate")
				else
					targetpowerborder = _G["EltruismTargetPowerBorder"]
				end
				targetpowerborder:SetSize(E.db.ElvUI_EltreumUI.borders.targetpowersizex, E.db.ElvUI_EltreumUI.borders.targetpowersizey)
				targetpowerborder:SetPoint("CENTER", _G.ElvUF_Target_PowerBar, "CENTER", 0, 0)
				targetpowerborder:SetParent(_G.ElvUF_Target_PowerBar)
				targetpowerborder:SetBackdrop({
					edgeFile = bordertexture,
					edgeSize = E.db.ElvUI_EltreumUI.borders.playertargetsize,
				})
				targetpowerborder:SetBackdropBorderColor(classcolor.r, classcolor.g, classcolor.b, 1)
				targetpowerborder:SetFrameStrata(E.db.ElvUI_EltreumUI.borders.targetpowerstrata)
				targetpowerborder:SetFrameLevel(E.db.ElvUI_EltreumUI.borders.targetpowerlevel)
			end
		end

		--target of target
		if E.db.ElvUI_EltreumUI.borders.targettargetborder and E.db.unitframe.units.targettarget.enable then
			if not _G["EltruismTargetTargetBorder"] then
				targettargetborder = CreateFrame("Frame", "EltruismTargetTargetBorder", _G.ElvUF_TargetTarget_HealthBar, BackdropTemplateMixin and "BackdropTemplate")
			else
				targettargetborder = _G["EltruismTargetTargetBorder"]
			end
			targettargetborder:SetSize(E.db.ElvUI_EltreumUI.borders.xtargettarget, E.db.ElvUI_EltreumUI.borders.ytargettarget)
			if PowerReadjust[E.db.unitframe.units.targettarget.power.width] then
				targettargetborder:SetPoint("CENTER", _G.ElvUF_TargetTarget_HealthBar, "CENTER", 0 ,0)
			else
				targettargetborder:SetPoint("CENTER", _G.ElvUF_TargetTarget, "CENTER", 0 ,0)
			end
			targettargetborder:SetBackdrop({
				edgeFile = bordertexture,
				edgeSize = E.db.ElvUI_EltreumUI.borders.playertargetsize,
			})
			targettargetborder:SetBackdropBorderColor(classcolor.r, classcolor.g, classcolor.b, 1)
			targettargetborder:SetFrameStrata(E.db.ElvUI_EltreumUI.borders.targettargetstrata)
			targettargetborder:SetFrameLevel(E.db.ElvUI_EltreumUI.borders.targettargetlevel)
			if E.db.ElvUI_EltreumUI.unitframes.infopanelontop and E.db.unitframe.units.targettarget.infoPanel.enable then
				targettargetborder:SetPoint("CENTER", _G.ElvUF_TargetTarget, "CENTER", 0, E.db.unitframe.units.targettarget.infoPanel.height)
			end
		end

		--target of target power
		if E.db.unitframe.units.targettarget.power.enable and (E.db.unitframe.units.targettarget.power.width == "spaced" or E.db.unitframe.units.targettarget.power.detachFromFrame) then
			if _G["ElvUF_TargetTarget_PowerBar"] and E.db.ElvUI_EltreumUI.borders.targettargetpower then
				if not _G["EltruismTargetTargetPowerBorder"] then
					targettargetpowerborder = CreateFrame("Frame", "EltruismTargetTargetPowerBorder", _G.ElvUF_TargetTarget_PowerBar, BackdropTemplateMixin and "BackdropTemplate")
				else
					targettargetpowerborder = _G["EltruismTargetTargetPowerBorder"]
				end
				targettargetpowerborder:SetSize(E.db.ElvUI_EltreumUI.borders.targettargetpowersizex, E.db.ElvUI_EltreumUI.borders.targettargetpowersizey)
				targettargetpowerborder:SetPoint("CENTER", _G.ElvUF_TargetTarget_PowerBar, "CENTER", 0, 0)
				targettargetpowerborder:SetParent(_G.ElvUF_TargetTarget_PowerBar)
				targettargetpowerborder:SetBackdrop({
					edgeFile = bordertexture,
					edgeSize = E.db.ElvUI_EltreumUI.borders.playertargetsize,
				})
				targettargetpowerborder:SetBackdropBorderColor(classcolor.r, classcolor.g, classcolor.b, 1)
				targettargetpowerborder:SetFrameStrata(E.db.ElvUI_EltreumUI.borders.targettargetpowerstrata)
				targettargetpowerborder:SetFrameLevel(E.db.ElvUI_EltreumUI.borders.targettargetpowerlevel)
			end
		end

		--pet
		if E.db.ElvUI_EltreumUI.borders.petborder and E.db.unitframe.units.pet.enable then
			if not _G["EltruismPetBorder"] then
				petborder = CreateFrame("Frame", "EltruismPetBorder", _G.ElvUF_Pet_HealthBar, BackdropTemplateMixin and "BackdropTemplate")
			else
				petborder = _G["EltruismPetBorder"]
			end
			petborder:SetSize(E.db.ElvUI_EltreumUI.borders.petsizex, E.db.ElvUI_EltreumUI.borders.petsizey)
			if PowerReadjust[E.db.unitframe.units.pet.power.width] then
				petborder:SetPoint("CENTER", _G.ElvUF_Pet_HealthBar,"CENTER", 0, 0)
			else
				petborder:SetPoint("CENTER", _G.ElvUF_Pet,"CENTER", 0, 0)
			end
			petborder:SetBackdrop({
				edgeFile = bordertexture,
				edgeSize = E.db.ElvUI_EltreumUI.borders.petsize,
			})
			petborder:SetBackdropBorderColor(classcolor.r, classcolor.g, classcolor.b, 1)
			petborder:SetFrameStrata(E.db.ElvUI_EltreumUI.borders.petstrata)
			petborder:SetFrameLevel(E.db.ElvUI_EltreumUI.borders.petlevel)
			if E.db.ElvUI_EltreumUI.unitframes.infopanelontop and E.db.unitframe.units.pet.infoPanel.enable then
				petborder:SetPoint("CENTER", _G.ElvUF_Pet, "CENTER", 0, E.db.unitframe.units.pet.infoPanel.height)
			end
		end

		--party
		if E.db.ElvUI_EltreumUI.borders.partyborders and E.db.unitframe.units.party.enable then
			for i = 1,5 do
				if _G["ElvUF_PartyGroup1UnitButton"..i] then
					if not _G["EltruismPartyBorder"..i] then
						partyborder = CreateFrame("Frame", "EltruismPartyBorder"..i, _G["ElvUF_PartyGroup1UnitButton"..i], BackdropTemplateMixin and "BackdropTemplate")
					else
						partyborder = _G["EltruismPartyBorder"..i]
					end
					partyborder:SetSize(E.db.ElvUI_EltreumUI.borders.partysizex, E.db.ElvUI_EltreumUI.borders.partysizey)
					if PowerReadjust[E.db.unitframe.units.party.power.width] then
						partyborder:SetPoint("CENTER", _G["ElvUF_PartyGroup1UnitButton"..i.."_HealthBar"], "CENTER")
					else
						partyborder:SetPoint("CENTER", _G["ElvUF_PartyGroup1UnitButton"..i], "CENTER")
					end
					partyborder:SetParent(_G["ElvUF_PartyGroup1UnitButton"..i])
					table.insert(partyborderholder, partyborder)
					partyborder:SetBackdrop({
						edgeFile = bordertexture,
						edgeSize = E.db.ElvUI_EltreumUI.borders.groupsize,
					})
					if E.db.ElvUI_EltreumUI.borders.classcolor then
						partyborder:SetBackdropBorderColor(1, 1, 1, 1)
					else
						partyborder:SetBackdropBorderColor(classcolor.r, classcolor.g, classcolor.b, 1)
					end
					partyborder:SetFrameStrata(E.db.ElvUI_EltreumUI.borders.partystrata)
					partyborder:SetFrameLevel(E.db.ElvUI_EltreumUI.borders.partylevel)
					if E.db.ElvUI_EltreumUI.unitframes.infopanelontop and E.db.unitframe.units.party.infoPanel.enable then
						partyborder:SetPoint("CENTER", _G["ElvUF_PartyGroup1UnitButton"..i], "CENTER", 0, E.db.unitframe.units.party.infoPanel.height)
					end
				end
			end
		end

		--raid1
		if E.db.ElvUI_EltreumUI.borders.raidborders then --and not (self.raid1borderscreated) then
			if E.private.unitframe.disabledBlizzardFrames.raid then
				for l = 1,8 do
					for k = 1,5 do
						if _G['ElvUF_Raid1Group'..l..'UnitButton'..k] then
							local raid1border
							if not _G["EltruismRaid1Group"..l.."Border"..k] then
								raid1border = CreateFrame("Frame", "EltruismRaid1Group"..l.."Border"..k, _G['ElvUF_Raid1Group'..l..'UnitButton'..k], BackdropTemplateMixin and "BackdropTemplate")
							else
								raid1border = _G["EltruismRaid1Group"..l.."Border"..k]
							end
							table.insert(raid1borderholder, raid1border)
							raid1border:SetSize(E.db.ElvUI_EltreumUI.borders.raidsizex, E.db.ElvUI_EltreumUI.borders.raidsizey)
							if PowerReadjust[E.db.unitframe.units.raid1.power.width] then
								raid1border:SetPoint("CENTER", _G['ElvUF_Raid1Group'..l..'UnitButton'..k.."_HealthBar"], "CENTER")
							else
								raid1border:SetPoint("CENTER", _G['ElvUF_Raid1Group'..l..'UnitButton'..k], "CENTER")
							end
							raid1border:SetParent(_G['ElvUF_Raid1Group'..l..'UnitButton'..k])
							raid1border:SetBackdrop({
								edgeFile = bordertexture,
								edgeSize = E.db.ElvUI_EltreumUI.borders.groupsize,
							})
							if E.db.ElvUI_EltreumUI.borders.classcolor then
								raid1border:SetBackdropBorderColor(1, 1, 1, 1)
							else
								raid1border:SetBackdropBorderColor(classcolor.r, classcolor.g, classcolor.b, 1)
							end
							raid1border:SetFrameStrata(E.db.ElvUI_EltreumUI.borders.raidstrata)
							raid1border:SetFrameLevel(E.db.ElvUI_EltreumUI.borders.raidlevel)
							if E.db.ElvUI_EltreumUI.unitframes.infopanelontop and E.db.unitframe.units.raid1.infoPanel.enable then
								raid1border:SetPoint("CENTER", _G["ElvUF_PartyGroup1UnitButton"..i], "CENTER", 0, E.db.unitframe.units.raid1.infoPanel.height)
							end
						end
					end
				end
			else
				if _G["CompactRaidFrameContainer"] then
					if _G["CompactRaidGroup1Member1"] and _G["CompactRaidGroup1Member1"]:IsVisible() then
						for l = 1, 8 do
							for k = 1, 5 do
								if _G["CompactRaidGroup"..l.."Member"..k] then
									local raid1border
									if not _G["EltruismRaid1Group"..l.."Border"..k] then
										raid1border = CreateFrame("Frame", "EltruismRaid1Group"..l.."Border"..k, _G["CompactRaidGroup"..k.."Member"..l], BackdropTemplateMixin and "BackdropTemplate")
									else
										raid1border = _G["EltruismRaid1Group"..l.."Border"..k]
									end
									table.insert(raid1borderholder, raid1border)
									raid1border:SetSize(E.db.ElvUI_EltreumUI.borders.raidsizex, E.db.ElvUI_EltreumUI.borders.raidsizey)
									raid1border:SetPoint("CENTER", _G["CompactRaidGroup"..l.."Member"..k], "CENTER")
									raid1border:SetParent(_G["CompactRaidGroup"..l.."Member"..k])
									raid1border:SetBackdrop({
										edgeFile = bordertexture,
										edgeSize = E.db.ElvUI_EltreumUI.borders.groupsize,
									})
									if E.db.ElvUI_EltreumUI.borders.classcolor then
										raid1border:SetBackdropBorderColor(1, 1, 1, 1)
									else
										raid1border:SetBackdropBorderColor(classcolor.r, classcolor.g, classcolor.b, 1)
									end
									raid1border:SetFrameStrata(E.db.ElvUI_EltreumUI.borders.raidstrata)
									raid1border:SetFrameLevel(E.db.ElvUI_EltreumUI.borders.raidlevel)
								end
							end
						end
					elseif _G["CompactRaidFrame1"] and _G["CompactRaidFrame1"]:IsVisible() then
						for i = 1, 40 do
							if _G["CompactRaidFrame"..i] then
								local raid1border
								if not _G["EltruismRaid1GroupBorder"..i] then
									raid1border = CreateFrame("Frame", "EltruismRaid1GroupBorder"..i, _G["CompactRaidFrame"..i], BackdropTemplateMixin and "BackdropTemplate")
								else
									raid1border = _G["EltruismRaid1GroupBorder"..i]
								end
								table.insert(raid1borderholder, raid1border)
								raid1border:SetSize(E.db.ElvUI_EltreumUI.borders.raidsizex, E.db.ElvUI_EltreumUI.borders.raidsizey)
								raid1border:SetPoint("CENTER", _G["CompactRaidFrame"..i], "CENTER")
								raid1border:SetParent(_G["CompactRaidFrame"..i])
								raid1border:SetBackdrop({
									edgeFile = bordertexture,
									edgeSize = E.db.ElvUI_EltreumUI.borders.groupsize,
								})
								if E.db.ElvUI_EltreumUI.borders.classcolor then
									raid1border:SetBackdropBorderColor(1, 1, 1, 1)
								else
									raid1border:SetBackdropBorderColor(classcolor.r, classcolor.g, classcolor.b, 1)
								end
								raid1border:SetFrameStrata(E.db.ElvUI_EltreumUI.borders.raidstrata)
								raid1border:SetFrameLevel(E.db.ElvUI_EltreumUI.borders.raidlevel)
							end
						end
					end
				end
			end
		end

		--raid2
		if E.db.ElvUI_EltreumUI.borders.raid2borders then--and not (self.raid2borderscreated) then
			for l = 1,8 do
				for k = 1,5 do
					if _G['ElvUF_Raid2Group'..l..'UnitButton'..k] then
						local raid2border
						if not _G["EltruismRaid2Group"..l.."Border"..k] then
							raid2border = CreateFrame("Frame", "EltruismRaid2Group"..l.."Border"..k, _G['ElvUF_Raid2Group'..l..'UnitButton'..k], BackdropTemplateMixin and "BackdropTemplate")
						else
							raid2border = _G["EltruismRaid2Group"..l.."Border"..k]
						end
						table.insert(raid2borderholder, raid2border)
						raid2border:SetSize(E.db.ElvUI_EltreumUI.borders.raid2sizex, E.db.ElvUI_EltreumUI.borders.raid2sizey)
						if PowerReadjust[E.db.unitframe.units.raid2.power.width] then
							raid2border:SetPoint("CENTER", _G['ElvUF_Raid2Group'..l..'UnitButton'..k.."_HealthBar"], "CENTER")
						else
							raid2border:SetPoint("CENTER", _G['ElvUF_Raid2Group'..l..'UnitButton'..k], "CENTER")
						end
						raid2border:SetParent(_G['ElvUF_Raid2Group'..l..'UnitButton'..k])
						raid2border:SetBackdrop({
							edgeFile = bordertexture,
							edgeSize = E.db.ElvUI_EltreumUI.borders.groupsize,
						})
						if E.db.ElvUI_EltreumUI.borders.classcolor then
							raid2border:SetBackdropBorderColor(1, 1, 1, 1)
						else
							raid2border:SetBackdropBorderColor(classcolor.r, classcolor.g, classcolor.b, 1)
						end
						raid2border:SetFrameStrata(E.db.ElvUI_EltreumUI.borders.raid2strata)
						raid2border:SetFrameLevel(E.db.ElvUI_EltreumUI.borders.raid2level)
						if E.db.ElvUI_EltreumUI.unitframes.infopanelontop and E.db.unitframe.units.raid2.infoPanel.enable then
							raid2border:SetPoint("CENTER", _G['ElvUF_Raid2Group'..l..'UnitButton'..k], "CENTER", 0, E.db.unitframe.units.raid2.infoPanel.height)
						end
					end
				end
			end
		end

		--raid3
		if E.db.ElvUI_EltreumUI.borders.raid40borders then--and not (self.raid3borderscreated) then
			for l = 1,8 do
				for k = 1,5 do
					if _G['ElvUF_Raid3Group'..l..'UnitButton'..k] then
						local raid3border
						if not _G["EltruismRaid3Group"..l.."Border"..k] then
							raid3border = CreateFrame("Frame", "EltruismRaid3Group"..l.."Border"..k, _G['ElvUF_Raid3Group'..l..'UnitButton'..k], BackdropTemplateMixin and "BackdropTemplate")
						else
							raid3border = _G["EltruismRaid3Group"..l.."Border"..k]
						end
						table.insert(raid3borderholder, raid3border)
						raid3border:SetSize(E.db.ElvUI_EltreumUI.borders.raid40sizex, E.db.ElvUI_EltreumUI.borders.raid40sizey)
						if PowerReadjust[E.db.unitframe.units.raid3.power.width] then
							raid3border:SetPoint("CENTER", _G['ElvUF_Raid3Group'..l..'UnitButton'..k.."_HealthBar"], "CENTER")
						else
							raid3border:SetPoint("CENTER", _G['ElvUF_Raid3Group'..l..'UnitButton'..k], "CENTER")
						end
						raid3border:SetParent(_G['ElvUF_Raid3Group'..l..'UnitButton'..k])
						raid3border:SetBackdrop({
							edgeFile = bordertexture,
							edgeSize = E.db.ElvUI_EltreumUI.borders.groupsize,
						})
						if E.db.ElvUI_EltreumUI.borders.classcolor then
							raid3border:SetBackdropBorderColor(1, 1, 1, 1)
						else
							raid3border:SetBackdropBorderColor(classcolor.r, classcolor.g, classcolor.b, 1)
						end
						raid3border:SetFrameStrata("MEDIUM")
						raid3border:SetFrameStrata(E.db.ElvUI_EltreumUI.borders.raid40strata)
						raid3border:SetFrameLevel(E.db.ElvUI_EltreumUI.borders.raid40level)
						if E.db.ElvUI_EltreumUI.unitframes.infopanelontop and E.db.unitframe.units.raid3.infoPanel.enable then
							raid3border:SetPoint("CENTER", _G['ElvUF_Raid3Group'..l..'UnitButton'..k], "CENTER", 0, E.db.unitframe.units.raid3.infoPanel.height)
						end
					end
				end
			end
		end

		--focus
		if E.db.ElvUI_EltreumUI.borders.focusborder and E.db.unitframe.units.focus.enable and not E.Classic then
			if not _G["EltruismFocusBorder"] then
				focusborder = CreateFrame("Frame", "EltruismFocusBorder", _G.ElvUF_Focus_HealthBar, BackdropTemplateMixin and "BackdropTemplate")
			else
				focusborder = _G["EltruismFocusBorder"]
			end
			focusborder:SetSize(E.db.ElvUI_EltreumUI.borders.xfocus, E.db.ElvUI_EltreumUI.borders.yfocus)
			if PowerReadjust[E.db.unitframe.units.focus.power.width] then
				focusborder:SetPoint("CENTER", _G.ElvUF_Focus_HealthBar, "CENTER", 0, 0)
			else
				focusborder:SetPoint("CENTER", _G.ElvUF_Focus, "CENTER", 0, 0)
			end
			focusborder:SetBackdrop({
				edgeFile = bordertexture,
				edgeSize = E.db.ElvUI_EltreumUI.borders.focussize,
			})
			focusborder:SetBackdropBorderColor(classcolor.r, classcolor.g, classcolor.b, 1)
			focusborder:SetFrameStrata(E.db.ElvUI_EltreumUI.borders.focusstrata)
			focusborder:SetFrameLevel(E.db.ElvUI_EltreumUI.borders.focuslevel)

			if E.db.ElvUI_EltreumUI.unitframes.infopanelontop and E.db.unitframe.units.focus.infoPanel.enable then
				focusborder:SetPoint("CENTER", _G.ElvUF_Focus, "CENTER", 0, E.db.unitframe.units.focus.infoPanel.height)
			end
		end

		--focus castbar
		if E.db.ElvUI_EltreumUI.borders.focuscastborder and E.db.unitframe.units.focus.castbar.enable and not E.Classic then
			if not _G["EltruismFocusCastBarBorder"] then
				focuscastbarborder = CreateFrame("Frame", "EltruismFocusCastBarBorder", _G.ElvUF_Focus_CastBar, BackdropTemplateMixin and "BackdropTemplate")
			else
				focuscastbarborder = _G["EltruismFocusCastBarBorder"]
			end
			if E.db.unitframe.units.focus.castbar.icon then
				if not E.db.unitframe.units.focus.castbar.iconAttached then
					focuscastbarborder:SetSize(E.db.ElvUI_EltreumUI.borders.xcastfocus + E.db.unitframe.units.focus.castbar.iconSize, E.db.ElvUI_EltreumUI.borders.ycastfocus)
					if E.db.unitframe.units.focus.castbar.iconXOffset == 0 then
						if E.db.unitframe.units.focus.castbar.iconPosition == "RIGHT" then
							focuscastbarborder:SetPoint("CENTER", _G["ElvUF_Focus_CastBar"], "CENTER", E.db.unitframe.units.focus.castbar.iconSize/2, 0)
						elseif E.db.unitframe.units.focus.castbar.iconPosition == "LEFT" then
							focuscastbarborder:SetPoint("CENTER", _G["ElvUF_Focus_CastBar"], "CENTER", -E.db.unitframe.units.focus.castbar.iconSize/2, 0)
						end
					else
						focuscastbarborder:SetPoint("CENTER", _G["ElvUF_Focus_CastBar"], "CENTER", 0, 0)
					end
				elseif E.db.unitframe.units.focus.castbar.iconAttached ~= false then
					focuscastbarborder:SetSize(E.db.ElvUI_EltreumUI.borders.xcastfocus, E.db.ElvUI_EltreumUI.borders.ycastfocus)
					--focuscastbarborder:SetPoint("CENTER", _G["ElvUF_Focus_CastBar"], "CENTER", -E.db.unitframe.units.focus.castbar.iconSize/2, 0)
					focuscastbarborder:SetPoint("CENTER", _G["ElvUF_Focus_CastBar"].Holder, "CENTER", 0, 0)
				end
			else
				focuscastbarborder:SetSize(E.db.ElvUI_EltreumUI.borders.xcastfocus, E.db.ElvUI_EltreumUI.borders.ycastfocus)
				focuscastbarborder:SetPoint("CENTER", _G["ElvUF_Focus_CastBar"].Holder, "CENTER", 0, 0)
			end
			focuscastbarborder:SetBackdrop({
				edgeFile = bordertexture,
				edgeSize = E.db.ElvUI_EltreumUI.borders.focussize,
			})
			focuscastbarborder:SetBackdropBorderColor(classcolor.r, classcolor.g, classcolor.b, 1)
			focuscastbarborder:SetFrameStrata(E.db.ElvUI_EltreumUI.borders.focuscaststrata)
			focuscastbarborder:SetFrameLevel(E.db.ElvUI_EltreumUI.borders.focuscastlevel)
		end

		--focus power
		if E.db.unitframe.units.focus.power.enable and (E.db.unitframe.units.focus.power.width == "spaced" or E.db.unitframe.units.focus.power.detachFromFrame) then
			if _G["ElvUF_Focus_PowerBar"] and E.db.ElvUI_EltreumUI.borders.focuspowerborder then
				if not _G["EltruismFocusPowerBorder"] then
					focuspowerborder = CreateFrame("Frame", "EltruismFocusPowerBorder", _G.ElvUF_Focus_PowerBar, BackdropTemplateMixin and "BackdropTemplate")
				else
					focuspowerborder = _G["EltruismFocusPowerBorder"]
				end
				focuspowerborder:SetSize(E.db.ElvUI_EltreumUI.borders.xfocuspower, E.db.ElvUI_EltreumUI.borders.yfocuspower)
				focuspowerborder:SetPoint("CENTER", _G.ElvUF_Focus_PowerBar, "CENTER", 0, 0)
				focuspowerborder:SetParent(_G.ElvUF_Focus_PowerBar)
				focuspowerborder:SetBackdrop({
					edgeFile = bordertexture,
					edgeSize = E.db.ElvUI_EltreumUI.borders.focussize,
				})
				focuspowerborder:SetBackdropBorderColor(classcolor.r, classcolor.g, classcolor.b, 1)
				focuspowerborder:SetFrameStrata(E.db.ElvUI_EltreumUI.borders.focuspowerstrata)
				focuspowerborder:SetFrameLevel(E.db.ElvUI_EltreumUI.borders.focuspowerlevel)
			end
		end

		--focustarget
		if E.db.ElvUI_EltreumUI.borders.focustargetborder and E.db.unitframe.units.focustarget.enable and not E.Classic then
			if not _G["EltruismFocusTargetBorder"] then
				focustargetborder = CreateFrame("Frame", "EltruismFocusTargetBorder", _G.ElvUF_FocusTarget_HealthBar, BackdropTemplateMixin and "BackdropTemplate")
			else
				focustargetborder = _G["EltruismFocusTargetBorder"]
			end
			focustargetborder:SetSize(E.db.ElvUI_EltreumUI.borders.xfocustarget, E.db.ElvUI_EltreumUI.borders.yfocustarget)
			if PowerReadjust[E.db.unitframe.units.focustarget.power.width] then
				focustargetborder:SetPoint("CENTER", _G.ElvUF_FocusTarget_HealthBar, "CENTER", 0, 0)
			else
				focustargetborder:SetPoint("CENTER", _G.ElvUF_FocusTarget, "CENTER", 0, 0)
			end
			focustargetborder:SetBackdrop({
				edgeFile = bordertexture,
				edgeSize = E.db.ElvUI_EltreumUI.borders.focussize,
			})
			focustargetborder:SetBackdropBorderColor(classcolor.r, classcolor.g, classcolor.b, 1)
			focustargetborder:SetFrameStrata("LOW")

			if E.db.ElvUI_EltreumUI.unitframes.infopanelontop and E.db.unitframe.units.focustarget.infoPanel.enable then
				focustargetborder:SetPoint("CENTER", _G.ElvUF_FocusTarget, "CENTER", 0, E.db.unitframe.units.focustarget.infoPanel.height)
			end
		end

		--bossborder
		if E.db.ElvUI_EltreumUI.borders.bossborder and E.db.unitframe.units.boss.enable and not E.Classic then
			for i = 1,8 do
				if _G["ElvUF_Boss"..i] then
					if not _G["EltruismBossBorder"..i] then
						bossborder = CreateFrame("Frame", "EltruismBossBorder"..i, _G["ElvUF_Boss"..i], BackdropTemplateMixin and "BackdropTemplate")
					else
						bossborder = _G["EltruismBossBorder"..i]
					end
					bossborder:SetSize(E.db.ElvUI_EltreumUI.borders.xboss, E.db.ElvUI_EltreumUI.borders.yboss)
					if PowerReadjust[E.db.unitframe.units.boss.power.width] then
						bossborder:SetPoint("CENTER", _G["ElvUF_Boss"..i.."_HealthBar"], "CENTER")
					else
						bossborder:SetPoint("CENTER", _G["ElvUF_Boss"..i], "CENTER")
					end
					bossborder:SetBackdrop({
						edgeFile = bordertexture,
						edgeSize = E.db.ElvUI_EltreumUI.borders.bosssize,
					})
					if UnitExists("boss"..i) and E.db.ElvUI_EltreumUI.borders.classcolor then
						local reactionboss= UnitReaction("boss"..i, "player")
						if reactionboss >= 5 then
							bossborder:SetBackdropBorderColor(classcolorreaction["NPCFRIENDLY"]["r1"], classcolorreaction["NPCFRIENDLY"]["g1"], classcolorreaction["NPCFRIENDLY"]["b1"], 1)
						elseif reactionboss == 4 then
							bossborder:SetBackdropBorderColor(classcolorreaction["NPCNEUTRAL"]["r1"], classcolorreaction["NPCNEUTRAL"]["g1"], classcolorreaction["NPCNEUTRAL"]["b1"], 1)
						elseif reactionboss == 3 then
							bossborder:SetBackdropBorderColor(classcolorreaction["NPCUNFRIENDLY"]["r1"], classcolorreaction["NPCUNFRIENDLY"]["g1"], classcolorreaction["NPCUNFRIENDLY"]["b1"], 1)
						elseif reactionboss == 2 or reactionboss == 1 then
							bossborder:SetBackdropBorderColor(classcolorreaction["NPCHOSTILE"]["r1"], classcolorreaction["NPCHOSTILE"]["g1"], classcolorreaction["NPCHOSTILE"]["b1"], 1)
						end
					else
						bossborder:SetBackdropBorderColor(classcolor.r, classcolor.g, classcolor.b, 1)
					end
					bossborder:SetFrameStrata(E.db.ElvUI_EltreumUI.borders.bossstrata)
					bossborder:SetFrameLevel(E.db.ElvUI_EltreumUI.borders.bosslevel)
					if E.db.ElvUI_EltreumUI.unitframes.infopanelontop and E.db.unitframe.units.boss.infoPanel.enable then
						bossborder:SetPoint("CENTER", _G["ElvUF_Boss"..i], "CENTER", 0, E.db.unitframe.units.boss.infoPanel.height)
					end
				end
			end
		end

		--arenaborder
		if E.db.ElvUI_EltreumUI.borders.arenaborder and E.db.unitframe.units.arena.enable and not E.Classic then
			for i = 1,8 do
				if _G["ElvUF_Arena"..i] then
					if not _G["EltruismArenaBorder"..i] then
						arenaborder = CreateFrame("Frame", "EltruismArenaBorder"..i, _G["ElvUF_Arena"..i], BackdropTemplateMixin and "BackdropTemplate")
					else
						arenaborder = _G["EltruismArenaBorder"..i]
					end
					arenaborder:SetSize(E.db.ElvUI_EltreumUI.borders.xarena, E.db.ElvUI_EltreumUI.borders.yarena)
					if PowerReadjust[E.db.unitframe.units.arena.power.width] then
						arenaborder:SetPoint("CENTER", _G["ElvUF_Arena"..i.."_HealthBar"], "CENTER")
					else
						arenaborder:SetPoint("CENTER", _G["ElvUF_Arena"..i], "CENTER")
					end
					arenaborder:SetBackdrop({
						edgeFile = bordertexture,
						edgeSize = E.db.ElvUI_EltreumUI.borders.arenasize,
					})
					if UnitExists("arena"..i) and E.db.ElvUI_EltreumUI.borders.classcolor then
						local reactionarena= UnitReaction("arena"..i, "player")
						if reactionarena >= 5 then
							arenaborder:SetBackdropBorderColor(classcolorreaction["NPCFRIENDLY"]["r1"], classcolorreaction["NPCFRIENDLY"]["g1"], classcolorreaction["NPCFRIENDLY"]["b1"], 1)
						elseif reactionarena == 4 then
							arenaborder:SetBackdropBorderColor(classcolorreaction["NPCNEUTRAL"]["r1"], classcolorreaction["NPCNEUTRAL"]["g1"], classcolorreaction["NPCNEUTRAL"]["b1"], 1)
						elseif reactionarena == 3 then
							arenaborder:SetBackdropBorderColor(classcolorreaction["NPCUNFRIENDLY"]["r1"], classcolorreaction["NPCUNFRIENDLY"]["g1"], classcolorreaction["NPCUNFRIENDLY"]["b1"], 1)
						elseif reactionarena == 2 or reactionarena == 1 then
							arenaborder:SetBackdropBorderColor(classcolorreaction["NPCHOSTILE"]["r1"], classcolorreaction["NPCHOSTILE"]["g1"], classcolorreaction["NPCHOSTILE"]["b1"], 1)
						end
					else
						arenaborder:SetBackdropBorderColor(classcolor.r, classcolor.g, classcolor.b, 1)
					end
					arenaborder:SetFrameStrata(E.db.ElvUI_EltreumUI.borders.arenastrata)
					arenaborder:SetFrameLevel(E.db.ElvUI_EltreumUI.borders.arenalevel)
					if E.db.ElvUI_EltreumUI.unitframes.infopanelontop and E.db.unitframe.units.arena.infoPanel.enable then
						arenaborder:SetPoint("CENTER", _G["ElvUF_Arena"..i], "CENTER", 0, E.db.unitframe.units.arena.infoPanel.height)
					end
				end
			end
		end

		--tanks
		if E.db.ElvUI_EltreumUI.borders.tankassistborders and E.db.unitframe.units.tank.enable then
			for k = 1,8 do
				if _G['ElvUF_TankUnitButton'..k] then
					local tankborder
					if not _G["ElvUF_TankUnitButton"..k.."Border"] then
						tankborder = CreateFrame("Frame", "ElvUF_TankUnitButton"..k.."Border", _G['ElvUF_TankUnitButton'..k], BackdropTemplateMixin and "BackdropTemplate")
					else
						tankborder = _G["ElvUF_TankUnitButton"..k.."Border"]
					end
					table.insert(tankborderholder, tankborder)
					tankborder:SetSize(E.db.ElvUI_EltreumUI.borders.tankassistsizex, E.db.ElvUI_EltreumUI.borders.tankassistsizey)
					tankborder:SetPoint("CENTER", _G['ElvUF_TankUnitButton'..k], "CENTER")
					tankborder:SetParent(_G['ElvUF_TankUnitButton'..k])
					tankborder:SetBackdrop({
						edgeFile = bordertexture,
						edgeSize = E.db.ElvUI_EltreumUI.borders.tankassistsize,
					})
					if E.db.ElvUI_EltreumUI.borders.classcolor then
						tankborder:SetBackdropBorderColor(1, 1, 1, 1)
					else
						tankborder:SetBackdropBorderColor(classcolor.r, classcolor.g, classcolor.b, 1)
					end
					tankborder:SetFrameStrata(E.db.ElvUI_EltreumUI.borders.tankassiststrata)
					tankborder:SetFrameLevel(E.db.ElvUI_EltreumUI.borders.tankassistlevel)
				end

				if _G['ElvUF_AssistUnitButton'..k] then
					local assistborder
					if not _G["ElvUF_AssistUnitButton"..k.."Border"] then
						assistborder = CreateFrame("Frame", "ElvUF_AssistUnitButton"..k.."Border", _G['ElvUF_AssistUnitButton'..k], BackdropTemplateMixin and "BackdropTemplate")
					else
						assistborder = _G["ElvUF_AssistUnitButton"..k.."Border"]
					end
					table.insert(assistborderholder, assistborder)
					assistborder:SetSize(E.db.ElvUI_EltreumUI.borders.tankassistsizex, E.db.ElvUI_EltreumUI.borders.tankassistsizey)
					assistborder:SetPoint("CENTER", _G['ElvUF_AssistUnitButton'..k], "CENTER")
					assistborder:SetParent(_G['ElvUF_AssistUnitButton'..k])
					assistborder:SetBackdrop({
						edgeFile = bordertexture,
						edgeSize = E.db.ElvUI_EltreumUI.borders.tankassistsize,
					})
					if E.db.ElvUI_EltreumUI.borders.classcolor then
						assistborder:SetBackdropBorderColor(1, 1, 1, 1)
					else
						assistborder:SetBackdropBorderColor(classcolor.r, classcolor.g, classcolor.b, 1)
					end
					assistborder:SetFrameStrata(E.db.ElvUI_EltreumUI.borders.tankassiststrata)
					assistborder:SetFrameLevel(E.db.ElvUI_EltreumUI.borders.tankassistlevel)
				end
			end
		end
	end
end

local function BordersPart2()

	--elvui action bars (has to be split because it bar can be different sizes)
	if E.private.actionbar.enable and not IsAddOnLoaded("ElvUI_ActionBarMasks") then
		--action bar 1
		if E.db.ElvUI_EltreumUI.borders.bar1borders and E.db.actionbar.bar1.enabled then
			local borders1 = {}
			for i = 1,12 do
				table.insert(borders1, _G["ElvUI_Bar1Button"..i])
			end
			local function createbar1borders()
				for i,v in pairs(borders1) do
					if not _G["EltruismAB1Border"..i] then
						barborder1 = CreateFrame("Frame", "EltruismAB1Border"..i, v, BackdropTemplateMixin and "BackdropTemplate")
					else
						barborder1 = _G["EltruismAB1Border"..i]
					end
					barborder1:SetSize(E.db.ElvUI_EltreumUI.borders.bar1xborder, E.db.ElvUI_EltreumUI.borders.bar1yborder)
					barborder1:SetPoint("CENTER", v, "CENTER")
					barborder1:SetBackdrop({
						edgeFile = bordertexture,
						edgeSize = E.db.ElvUI_EltreumUI.borders.baredgesize,
					})
					barborder1:SetBackdropBorderColor(classcolor.r, classcolor.g, classcolor.b, 1)
					barborder1:SetFrameStrata(E.db.ElvUI_EltreumUI.borders.bar1strata)
					barborder1:SetFrameLevel(E.db.ElvUI_EltreumUI.borders.bar1level)
				end
			end
			createbar1borders()
		end

		--bar2
		if E.db.ElvUI_EltreumUI.borders.bar2borders and E.db.actionbar.bar2.enabled then
			local borders2 = {}
			for i = 1,12 do
				table.insert(borders2, _G["ElvUI_Bar2Button"..i])
			end
			local function createbar2borders()
				for i,v in pairs(borders2) do
					if not _G["EltruismAB2Border"..i] then
						barborder2 = CreateFrame("Frame", "EltruismAB2Border"..i, v, BackdropTemplateMixin and "BackdropTemplate")
					else
						barborder2 = _G["EltruismAB2Border"..i]
					end
					barborder2:SetSize(E.db.ElvUI_EltreumUI.borders.bar2xborder, E.db.ElvUI_EltreumUI.borders.bar2yborder)
					barborder2:SetPoint("CENTER", v, "CENTER")
					barborder2:SetBackdrop({
						edgeFile = bordertexture,
						edgeSize = E.db.ElvUI_EltreumUI.borders.baredgesize,
					})
					barborder2:SetBackdropBorderColor(classcolor.r, classcolor.g, classcolor.b, 1)
					barborder2:SetFrameStrata(E.db.ElvUI_EltreumUI.borders.bar2strata)
					barborder2:SetFrameLevel(E.db.ElvUI_EltreumUI.borders.bar2level)
				end
			end
			createbar2borders()
		end

		--bar3
		if E.db.ElvUI_EltreumUI.borders.bar3borders and E.db.actionbar.bar3.enabled then
			local borders3 = {}
			for i = 1,12 do
				table.insert(borders3, _G["ElvUI_Bar3Button"..i])
			end
			local function createbar3borders()
				for i,v in pairs(borders3) do
					if not _G["EltruismAB3Border"..i] then
						barborder3 = CreateFrame("Frame", "EltruismAB3Border"..i, v, BackdropTemplateMixin and "BackdropTemplate")
					else
						barborder3 = _G["EltruismAB3Border"..i]
					end
					barborder3:SetSize(E.db.ElvUI_EltreumUI.borders.bar3xborder, E.db.ElvUI_EltreumUI.borders.bar3yborder)
					barborder3:SetPoint("CENTER", v, "CENTER")
					barborder3:SetBackdrop({
						edgeFile = bordertexture,
						edgeSize = E.db.ElvUI_EltreumUI.borders.baredgesize,
					})
					barborder3:SetBackdropBorderColor(classcolor.r, classcolor.g, classcolor.b, 1)
					barborder3:SetFrameStrata(E.db.ElvUI_EltreumUI.borders.bar3strata)
					barborder3:SetFrameLevel(E.db.ElvUI_EltreumUI.borders.bar3level)
				end
			end
			createbar3borders()
		end

		--bar4
		if E.db.ElvUI_EltreumUI.borders.bar4borders and E.db.actionbar.bar4.enabled then
			local borders4 = {}
			for i = 1,12 do
				table.insert(borders4, _G["ElvUI_Bar4Button"..i])
			end
			local function createbar4borders()
				for i,v in pairs(borders4) do
					if not _G["EltruismAB4Border"..i] then
						barborder4 = CreateFrame("Frame", "EltruismAB4Border"..i, v, BackdropTemplateMixin and "BackdropTemplate")
					else
						barborder4 = _G["EltruismAB4Border"..i]
					end
					barborder4:SetSize(E.db.ElvUI_EltreumUI.borders.bar4xborder, E.db.ElvUI_EltreumUI.borders.bar4yborder)
					barborder4:SetPoint("CENTER", v, "CENTER")
					barborder4:SetBackdrop({
						edgeFile = bordertexture,
						edgeSize = E.db.ElvUI_EltreumUI.borders.baredgesize,
					})
					barborder4:SetBackdropBorderColor(classcolor.r, classcolor.g, classcolor.b, 1)
					barborder4:SetFrameStrata(E.db.ElvUI_EltreumUI.borders.bar4strata)
					barborder4:SetFrameLevel(E.db.ElvUI_EltreumUI.borders.bar4level)
				end
			end
			createbar4borders()
		end

		--bar5
		if E.db.ElvUI_EltreumUI.borders.bar5borders and E.db.actionbar.bar5.enabled then
			local borders5 = {}
			for i = 1,12 do
				table.insert(borders5, _G["ElvUI_Bar5Button"..i])
			end
			local function createbar5borders()
				for i,v in pairs(borders5) do
					if not _G["EltruismAB5Border"..i] then
						barborder5 = CreateFrame("Frame", "EltruismAB5Border"..i, v, BackdropTemplateMixin and "BackdropTemplate")
					else
						barborder5 = _G["EltruismAB5Border"..i]
					end
					barborder5:SetSize(E.db.ElvUI_EltreumUI.borders.bar5xborder, E.db.ElvUI_EltreumUI.borders.bar5yborder)
					barborder5:SetPoint("CENTER", v, "CENTER")
					barborder5:SetBackdrop({
						edgeFile = bordertexture,
						edgeSize = E.db.ElvUI_EltreumUI.borders.baredgesize,
					})
					barborder5:SetBackdropBorderColor(classcolor.r, classcolor.g, classcolor.b, 1)
					barborder5:SetFrameStrata(E.db.ElvUI_EltreumUI.borders.bar5strata)
					barborder5:SetFrameLevel(E.db.ElvUI_EltreumUI.borders.bar5level)
				end
			end
			createbar5borders()
		end

		--bar6
		if E.db.ElvUI_EltreumUI.borders.bar6borders and E.db.actionbar.bar6.enabled then
			local borders6 = {}
			for i = 1,12 do
				table.insert(borders6, _G["ElvUI_Bar6Button"..i])
			end
			local function createbar6borders()
				for i,v in pairs(borders6) do
					if not _G["EltruismAB6Border"..i] then
						barborder6 = CreateFrame("Frame", "EltruismAB6Border"..i, v, BackdropTemplateMixin and "BackdropTemplate")
					else
						barborder6 = _G["EltruismAB6Border"..i]
					end
					barborder6:SetSize(E.db.ElvUI_EltreumUI.borders.bar6xborder, E.db.ElvUI_EltreumUI.borders.bar6yborder)
					barborder6:SetPoint("CENTER", v, "CENTER")
					barborder6:SetBackdrop({
						edgeFile = bordertexture,
						edgeSize = E.db.ElvUI_EltreumUI.borders.baredgesize,
					})
					barborder6:SetBackdropBorderColor(classcolor.r, classcolor.g, classcolor.b, 1)
					barborder6:SetFrameStrata(E.db.ElvUI_EltreumUI.borders.bar6strata)
					barborder6:SetFrameLevel(E.db.ElvUI_EltreumUI.borders.bar6level)
				end
			end
			createbar6borders()
		end

		--stances
		if E.db.ElvUI_EltreumUI.borders.stanceborders and E.db.actionbar.stanceBar.enabled then
			local stanceborders = {}
			for i = 1,10 do
				table.insert(stanceborders, _G["ElvUI_StanceBarButton"..i])
			end
			local function createstanceborders()
				for i,v in pairs(stanceborders) do
					if not _G["EltruismStanceBorder"..i] then
						stanceborder = CreateFrame("Frame", "EltruismStanceBorder"..i, v, BackdropTemplateMixin and "BackdropTemplate")
					else
						stanceborder = _G["EltruismStanceBorder"..i]
					end
					stanceborder:SetSize(E.db.ElvUI_EltreumUI.borders.stancexborder, E.db.ElvUI_EltreumUI.borders.stanceyborder)
					stanceborder:SetPoint("CENTER", v, "CENTER")
					stanceborder:SetBackdrop({
						edgeFile = bordertexture,
						edgeSize = E.db.ElvUI_EltreumUI.borders.stanceedgesize,
					})
					stanceborder:SetBackdropBorderColor(classcolor.r, classcolor.g, classcolor.b, 1)
					stanceborder:SetFrameStrata(E.db.ElvUI_EltreumUI.borders.stancestrata)
					stanceborder:SetFrameLevel(E.db.ElvUI_EltreumUI.borders.stancelevel)
				end
			end
			createstanceborders()
		end

		--pet action bars
		if E.db.ElvUI_EltreumUI.borders.petactionborders and E.db.actionbar.barPet.enabled then
			local petactionborders = {}
			for i = 1,10 do
				table.insert(petactionborders, _G["PetActionButton"..i])
			end
			local function createstancepetactionborders()
				for i,v in pairs(petactionborders) do
					if not _G["EltruismPetActionBorder"..i] then
						petactionborder = CreateFrame("Frame", "EltruismPetActionBorder"..i, v, BackdropTemplateMixin and "BackdropTemplate")
					else
						petactionborder = _G["EltruismPetActionBorder"..i]
					end
					petactionborder:SetSize(E.db.ElvUI_EltreumUI.borders.petactionxborder, E.db.ElvUI_EltreumUI.borders.petactionyborder)
					petactionborder:SetPoint("CENTER", v, "CENTER")
					petactionborder:SetBackdrop({
						edgeFile = bordertexture,
						edgeSize = E.db.ElvUI_EltreumUI.borders.petactionedgesize,
					})
					petactionborder:SetBackdropBorderColor(classcolor.r, classcolor.g, classcolor.b, 1)
					petactionborder:SetFrameStrata(E.db.ElvUI_EltreumUI.borders.petabstrata)
					petactionborder:SetFrameLevel(E.db.ElvUI_EltreumUI.borders.petablevel)
				end
			end
			createstancepetactionborders()
		end
	end

	--wotlk shaman totem bar
	--[[if E.Mists and E.myclass == 'SHAMAN' and E.db.ElvUI_EltreumUI.borders.totembar then
		local borderstotemaction = {}
		local borderstotemfly = {}
		for i = 1,4 do
			table.insert(borderstotemaction, _G["MultiCastActionButton"..i])
		end
		table.insert(borderstotemaction, _G["MultiCastSummonSpellButton"])
		table.insert(borderstotemaction, _G["MultiCastRecallSpellButton"])
		local function createtotemborders()
			for i,v in pairs(borderstotemaction) do
				if not _G["EltruismTotemBorderAction"..i] then
					totemborderaction = CreateFrame("Frame", "EltruismTotemBorderAction"..i, v, BackdropTemplateMixin and "BackdropTemplate")
				else
					totemborderaction = _G["EltruismTotemBorderAction"..i]
				end
				totemborderaction:SetSize(E.db.ElvUI_EltreumUI.borders.totemxborder, E.db.ElvUI_EltreumUI.borders.totemyborder)
				totemborderaction:SetPoint("CENTER", v, "CENTER")
				totemborderaction:SetBackdrop({
					edgeFile = bordertexture,
					edgeSize = E.db.ElvUI_EltreumUI.borders.totemedgesize,
				})
				totemborderaction:SetBackdropBorderColor(classcolor.r, classcolor.g, classcolor.b, 1)
				totemborderaction:SetFrameStrata(E.db.ElvUI_EltreumUI.borders.totemstrata)
				totemborderaction:SetFrameLevel(E.db.ElvUI_EltreumUI.borders.totemlevel)
			end
		end
		createtotemborders()

		local function createtotemflyborders()
			for i = 1,7 do
				table.insert(borderstotemfly, _G["MultiCastFlyoutButton"..i])
			end
			for i,v in pairs(borderstotemfly) do
				if not _G["EltruismTotemBorderFly"..i] then
					totemborderfly = CreateFrame("Frame", "EltruismTotemBorderFly"..i, v, BackdropTemplateMixin and "BackdropTemplate")
				else
					totemborderfly = _G["EltruismTotemBorderFly"..i]
				end
				totemborderfly:SetSize(E.db.ElvUI_EltreumUI.borders.totemxborder, E.db.ElvUI_EltreumUI.borders.totemyborder)
				totemborderfly:SetPoint("CENTER", v, "CENTER")
				totemborderfly:SetBackdrop({
					edgeFile = bordertexture,
					edgeSize = E.db.ElvUI_EltreumUI.borders.totemedgesize,
				})
				totemborderfly:SetBackdropBorderColor(classcolor.r, classcolor.g, classcolor.b, 1)
				--totemborderfly:SetFrameLevel(1)
			end
		end
		hooksecurefunc("MultiCastFlyoutFrame_ToggleFlyout", function()
			if not _G["EltruismTotemBorderFly7"] then
				createtotemflyborders()
			end
		end)
	end]]

	--nameplate power bar
	if E.db.ElvUI_EltreumUI.borders.powerbarborder then
		if not _G["EltruismPowerBarBorder"] then
			powerbarborder = CreateFrame("Frame", "EltruismPowerBarBorder", _G.EltruismPowerBar, BackdropTemplateMixin and "BackdropTemplate")
		else
			powerbarborder = _G["EltruismPowerBarBorder"]
		end
		powerbarborder:SetSize(E.db.ElvUI_EltreumUI.borders.xpowerbar, E.db.ElvUI_EltreumUI.borders.ypowerbar)
		powerbarborder:SetPoint("CENTER", _G.EltruismPowerBar, "CENTER", 0, 0)
		powerbarborder:SetBackdrop({
			edgeFile = bordertexture,
			edgeSize = E.db.ElvUI_EltreumUI.borders.powerbarsize,
		})
		powerbarborder:SetBackdropBorderColor(classcolor.r, classcolor.g, classcolor.b, 1)
		powerbarborder:SetFrameStrata(E.db.ElvUI_EltreumUI.borders.powerbarstrata)
		powerbarborder:SetFrameLevel(E.db.ElvUI_EltreumUI.borders.powerbarlevel)
	end

	-- minimap
	if E.private.general.minimap.enable ~= false and E.db.ElvUI_EltreumUI.borders.minimapborder and not (E.db.ElvUI_EltreumUI.otherstuff.minimapcardinaldirections.circle and E.db.ElvUI_EltreumUI.otherstuff.minimapcardinaldirections.rotate) then
		if not _G["EltruismMiniMapBorderFrame"] then
			MinimapBorder = CreateFrame("Frame", "EltruismMiniMapBorderFrame", _G["Minimap"], BackdropTemplateMixin and "BackdropTemplate")
		else
			MinimapBorder = _G["EltruismMiniMapBorderFrame"]
		end
		MinimapBorder:SetSize(E.db.ElvUI_EltreumUI.borders.minimapsizex, E.db.ElvUI_EltreumUI.borders.minimapsizey)
		MinimapBorder:SetParent(_G["Minimap"])
		MinimapBorder:SetBackdrop({
			edgeFile = bordertexture,
			--edgeSize = E.db.ElvUI_EltreumUI.borders.baredgesize, --13
			edgeSize = E.db.ElvUI_EltreumUI.borders.minimapsize,
		})
		MinimapBorder:SetBackdropBorderColor(classcolor.r, classcolor.g, classcolor.b, 1)
		MinimapBorder:SetFrameStrata(E.db.ElvUI_EltreumUI.borders.minimapstrata)
		MinimapBorder:SetFrameLevel(E.db.ElvUI_EltreumUI.borders.minimaplevel)

		if not E.db.datatexts.panels.MinimapPanel.backdrop or not E.db.datatexts.panels.MinimapPanel.enable then
			MinimapBorder:SetPoint("CENTER", _G["MinimapBackdrop"],"CENTER", 0, 0)
		else
			MinimapBorder:SetPoint("CENTER", _G["ElvUI_MinimapHolder"],"CENTER", 0, 0)
		end

		if IsAddOnLoaded("ElvUI_SLE") and E.private.sle.minimap.rectangle then --Shadow and Light Rectangle Minimap
			rectangleminimapdetect:SetPoint("TOPRIGHT", _G["Minimap"].backdrop ,"TOPRIGHT", 0, 0)
			rectangleminimapdetect:SetPoint("BOTTOMLEFT", _G["MinimapPanel"] ,"BOTTOMLEFT", 0, 0)

			MinimapBorder:SetPoint("CENTER", rectangleminimapdetect ,"CENTER", 0, 0)
			if not E.db.datatexts.panels.MinimapPanel.backdrop or not E.db.datatexts.panels.MinimapPanel.enable then
				MinimapBorder:SetPoint("CENTER", _G["Minimap"].backdrop.Center ,"CENTER", 0, 0)
			end
			updatelocationpos:RegisterEvent("ZONE_CHANGED")
			updatelocationpos:RegisterEvent("ZONE_CHANGED_INDOORS")
			updatelocationpos:RegisterEvent("ZONE_CHANGED_NEW_AREA")
			updatelocationpos:RegisterEvent("PLAYER_ENTERING_WORLD")
			updatelocationpos:RegisterEvent("MINIMAP_UPDATE_ZOOM")
			updatelocationpos:SetScript("OnEvent", function()
				_G.Minimap.location:ClearAllPoints()
				_G.Minimap.location:SetPoint('TOP', _G.Minimap, 'TOP', 0, -15)
			end)
		elseif IsAddOnLoaded("ElvUI_WindTools") and E.db.WT.maps.rectangleMinimap.enable then --Windtools rectangle minimap
			MinimapBorder:SetPoint("CENTER", _G["MinimapBackdrop"] ,"CENTER", 0, 0)

			updatelocationpos:RegisterEvent("ZONE_CHANGED")
			updatelocationpos:RegisterEvent("ZONE_CHANGED_INDOORS")
			updatelocationpos:RegisterEvent("ZONE_CHANGED_NEW_AREA")
			updatelocationpos:RegisterEvent("PLAYER_ENTERING_WORLD")
			updatelocationpos:RegisterEvent("MINIMAP_UPDATE_ZOOM")
			updatelocationpos:SetScript("OnEvent", function()
				_G.Minimap.location:ClearAllPoints()
				_G.Minimap.location:SetPoint('TOP', _G.Minimap, 'TOP', 0, -15)
			end)
		end
	end

	--chat
	if E.private.chat.enable and E.db.ElvUI_EltreumUI.borders.chatborder then
		--left chat
		if not _G["EltruismLeftChatBorderFrame"] then
			LeftChatBorder = CreateFrame("Frame", "EltruismLeftChatBorderFrame", _G["LeftChatPanel"], BackdropTemplateMixin and "BackdropTemplate")
		else
			LeftChatBorder = _G["EltruismLeftChatBorderFrame"]
		end
		LeftChatBorder:SetParent(_G["LeftChatPanel"].backdrop)
		LeftChatBorder:SetSize(E.db.ElvUI_EltreumUI.borders.leftchatborderx, E.db.ElvUI_EltreumUI.borders.leftchatbordery)
		LeftChatBorder:SetPoint("CENTER", _G["LeftChatMover"] ,"CENTER")
		LeftChatBorder:SetBackdrop({
			edgeFile = bordertexture,
			edgeSize = E.db.ElvUI_EltreumUI.borders.chatsize, --13
		})
		LeftChatBorder:SetBackdropBorderColor(classcolor.r, classcolor.g, classcolor.b, 1)
		LeftChatBorder:SetFrameStrata(E.db.ElvUI_EltreumUI.borders.leftchatstrata)
		LeftChatBorder:SetFrameLevel(E.db.ElvUI_EltreumUI.borders.leftchatlevel)

		--right chat
		if not _G["EltruismRightChatBorderFrame"] then
			RightChatBorder = CreateFrame("Frame", "EltruismRightChatBorderFrame", _G["RightChatPanel"], BackdropTemplateMixin and "BackdropTemplate")
		else
			RightChatBorder = _G["EltruismRightChatBorderFrame"]
		end
		RightChatBorder:SetParent(_G["RightChatPanel"].backdrop)
		RightChatBorder:SetSize(E.db.ElvUI_EltreumUI.borders.rightchatborderx, E.db.ElvUI_EltreumUI.borders.rightchatbordery)
		RightChatBorder:SetPoint("CENTER", _G["RightChatMover"] ,"CENTER")
		RightChatBorder:SetBackdrop({
			edgeFile = bordertexture,
			edgeSize = E.db.ElvUI_EltreumUI.borders.chatsize, --13
		})
		RightChatBorder:SetBackdropBorderColor(classcolor.r, classcolor.g, classcolor.b, 1)
		RightChatBorder:SetFrameStrata(E.db.ElvUI_EltreumUI.borders.rightchatstrata)
		RightChatBorder:SetFrameLevel(E.db.ElvUI_EltreumUI.borders.rightchatlevel)

		if E.db.chat.panelBackdrop == "RIGHT" then
			LeftChatBorder:Hide()
		elseif E.db.chat.panelBackdrop == "LEFT" then
			RightChatBorder:Hide()
		elseif E.db.chat.panelBackdrop == "HIDEBOTH" then
			LeftChatBorder:Hide()
			RightChatBorder:Hide()
		end
	end

	--databars
	if E.db.databars.experience.enable and E.db.ElvUI_EltreumUI.borders.experiencebar and _G.ElvUI_ExperienceBar then
		if not _G["EltruismExperienceBorder"] then
			experienceborder = CreateFrame("Frame", "EltruismExperienceBorder", _G.ElvUI_ExperienceBar, BackdropTemplateMixin and "BackdropTemplate")
		else
			experienceborder = _G["EltruismExperienceBorder"]
		end
		experienceborder:SetSize(E.db.ElvUI_EltreumUI.borders.experiencebarsizex, E.db.ElvUI_EltreumUI.borders.experiencebarsizey)
		experienceborder:SetPoint("CENTER", _G.ElvUI_ExperienceBar, "CENTER", 0, 0)
		experienceborder:SetBackdrop({
			edgeFile = bordertexture,
			edgeSize = E.db.ElvUI_EltreumUI.borders.databarsize,
		})
		experienceborder:SetBackdropBorderColor(classcolor.r, classcolor.g, classcolor.b, 1)
		experienceborder:SetFrameStrata(E.db.ElvUI_EltreumUI.borders.experiencebarstrata)
		experienceborder:SetFrameLevel(E.db.ElvUI_EltreumUI.borders.experiencebarlevel)
	end
	if E.db.databars.reputation.enable and E.db.ElvUI_EltreumUI.borders.reputationbar and _G.ElvUI_ReputationBar then
		if not _G["EltruismReputationBorder"] then
			reputationborder = CreateFrame("Frame", "EltruismReputationBorder", _G.ElvUI_ReputationBar, BackdropTemplateMixin and "BackdropTemplate")
		else
			reputationborder = _G["EltruismReputationBorder"]
		end
		reputationborder:SetSize(E.db.ElvUI_EltreumUI.borders.reputationbarsizex, E.db.ElvUI_EltreumUI.borders.reputationbarsizey)
		reputationborder:SetPoint("CENTER", _G.ElvUI_ReputationBar, "CENTER", 0, 0)
		reputationborder:SetBackdrop({
			edgeFile = bordertexture,
			edgeSize = E.db.ElvUI_EltreumUI.borders.databarsize,
		})
		reputationborder:SetBackdropBorderColor(classcolor.r, classcolor.g, classcolor.b, 1)
		reputationborder:SetFrameStrata(E.db.ElvUI_EltreumUI.borders.reputationbarstrata)
		reputationborder:SetFrameLevel(E.db.ElvUI_EltreumUI.borders.reputationbarlevel)
	end
	if E.db.databars.threat.enable and E.db.ElvUI_EltreumUI.borders.threatbar and _G.ElvUI_ThreatBar then
		if not _G["EltruismThreatBorder"] then
			threatborder = CreateFrame("Frame", "EltruismThreatBorder", _G.ElvUI_ThreatBar, BackdropTemplateMixin and "BackdropTemplate")
		else
			threatborder = _G["EltruismThreatBorder"]
		end
		threatborder:SetSize(E.db.ElvUI_EltreumUI.borders.threatbarsizex, E.db.ElvUI_EltreumUI.borders.threatbarsizey)
		threatborder:SetPoint("CENTER", _G.ElvUI_ThreatBar, "CENTER", 0, 0)
		threatborder:SetBackdrop({
			edgeFile = bordertexture,
			edgeSize = E.db.ElvUI_EltreumUI.borders.databarsize,
		})
		threatborder:SetBackdropBorderColor(classcolor.r, classcolor.g, classcolor.b, 1)
		threatborder:SetFrameStrata(E.db.ElvUI_EltreumUI.borders.threatbarstrata)
		threatborder:SetFrameLevel(E.db.ElvUI_EltreumUI.borders.threatbarlevel)
	end

	--altpowerbar
	if E.db.general.altPowerBar.enable and E.db.ElvUI_EltreumUI.borders.altpowerbar and _G.ElvUI_AltPowerBar then
		if not _G["EltruismAltPowerBorder"] then
			altpowerborder = CreateFrame("Frame", "EltruismAltPowerBorder", _G.ElvUI_AltPowerBar, BackdropTemplateMixin and "BackdropTemplate")
		else
			altpowerborder = _G["EltruismAltPowerBorder"]
		end
		altpowerborder:SetSize(E.db.ElvUI_EltreumUI.borders.altpowerbarsizex, E.db.ElvUI_EltreumUI.borders.altpowerbarsizey)
		altpowerborder:SetPoint("CENTER", _G.ElvUI_AltPowerBar, "CENTER", 0, 0)
		altpowerborder:SetBackdrop({
			edgeFile = bordertexture,
			edgeSize = E.db.ElvUI_EltreumUI.borders.altpowerbarsize,
		})
		altpowerborder:SetBackdropBorderColor(classcolor.r, classcolor.g, classcolor.b, 1)
		altpowerborder:SetFrameStrata(E.db.ElvUI_EltreumUI.borders.altpowerbarstrata)
		altpowerborder:SetFrameLevel(E.db.ElvUI_EltreumUI.borders.altpowerbarlevel)
	end

	--fire tooltip border
	if E.db.ElvUI_EltreumUI.borders.tooltipborders and E.private.tooltip.enable then
		ElvUI_EltreumUI:TooltipBorder()
	end
end

--Borders on frames
function ElvUI_EltreumUI:Borders()
	if E.db.ElvUI_EltreumUI.borders.borders and not E.db.ElvUI_EltreumUI.borders.bordertest then
		if E.Classic and not E.db.ElvUI_EltreumUI.skins.classicblueshaman then
			classcolorreaction["SHAMAN"] = {r1 = 0.95686066150665, g1 = 0.54901838302612, b1 = 0.72941017150879}
		end
		ElvUI_EltreumUI:GetBorderClassColors()

		--borders not nice with transparent power
		if PowerReadjust[E.db.unitframe.units.player.power.width] then
			E.db.unitframe.colors.transparentPower = false
		end

		if E.db.ElvUI_EltreumUI.borders.texture then
			bordertexture = E.LSM:Fetch("border", E.db.ElvUI_EltreumUI.borders.texture)
			if bordertexture == nil then --the border was not found so apply the default
				bordertexture = E.LSM:Fetch("border", "Eltreum-Border-1")
				E.db.ElvUI_EltreumUI.borders.texture = "Eltreum-Border-1"
			end
		end

		BordersPart1()
		BordersPart2()
	end
end

--from elvui
local debuffColors = { -- handle colors of LibDispel
	["none"] = { r = E.db.general.debuffColors.none.r, g = E.db.general.debuffColors.none.g, b = E.db.general.debuffColors.none.b },
	["Magic"] = { r = E.db.general.debuffColors.Magic.r, g = E.db.general.debuffColors.Magic.g, b = E.db.general.debuffColors.Magic.b },
	["Curse"] = { r = E.db.general.debuffColors.Curse.r, g = E.db.general.debuffColors.Curse.g, b = E.db.general.debuffColors.Curse.b },
	["Disease"] = { r = E.db.general.debuffColors.Disease.r, g = E.db.general.debuffColors.Disease.g, b = E.db.general.debuffColors.Disease.b },
	["Poison"] = { r = E.db.general.debuffColors.Poison.r, g = E.db.general.debuffColors.Poison.g, b = E.db.general.debuffColors.Poison.b },

	-- These dont exist in Blizzards color table
	["EnemyNPC"] = { r = E.db.general.debuffColors.EnemyNPC.r, g = E.db.general.debuffColors.EnemyNPC.g, b = E.db.general.debuffColors.EnemyNPC.b },
	["BadDispel"] = { r = E.db.general.debuffColors.BadDispel.r, g = E.db.general.debuffColors.BadDispel.g, b = E.db.general.debuffColors.BadDispel.b },
	["Bleed"] = { r = E.db.general.debuffColors.Bleed.r, g = E.db.general.debuffColors.Bleed.g, b = E.db.general.debuffColors.Bleed.b },
	["Stealable"] = { r = E.db.general.debuffColors.Stealable.r, g = E.db.general.debuffColors.Stealable.g, b = E.db.general.debuffColors.Stealable.b },
}

function ElvUI_EltreumUI:AuraBorders(button)
	if button and E.db.ElvUI_EltreumUI.borders.borders and E.db.ElvUI_EltreumUI.borders.auraborder and E.private.auras.enable and not E.db.ElvUI_EltreumUI.borders.bordertest then
		local auraborder
		if not _G["EltruismAuraBorder"..button:GetName()] then
			auraborder = CreateFrame("Frame", "EltruismAuraBorder"..button:GetName(), button, BackdropTemplateMixin and "BackdropTemplate")
		else
			auraborder = _G["EltruismAuraBorder"..button:GetName()]
		end

		if button.auraType == "debuffs" then
			auraborder:SetSize(E.db.ElvUI_EltreumUI.borders.debuffaurasizex, E.db.ElvUI_EltreumUI.borders.debuffaurasizey)
		else
			auraborder:SetSize(E.db.ElvUI_EltreumUI.borders.aurasizex, E.db.ElvUI_EltreumUI.borders.aurasizey)
		end
		auraborder:SetPoint("CENTER", button, "CENTER", 0, 0)
		auraborder:SetBackdrop({
			edgeFile = E.LSM:Fetch("border", E.db.ElvUI_EltreumUI.borders.texture),
			edgeSize = E.db.ElvUI_EltreumUI.borders.aurasize,
		})
		--E:Delay(1, function()
			--[[if button.auraType == "debuffs" then
				print(debuffColors[button.debuffType],button.debuffType)
				if debuffColors[button.debuffType] then
					auraborder:SetBackdropBorderColor(debuffColors[button.debuffType].r, debuffColors[button.debuffType].g, debuffColors[button.debuffType].b, 1)
				else
					auraborder:SetBackdropBorderColor(0.8, 0, 0, 1)
				end
			else
				auraborder:SetBackdropBorderColor(classcolor.r, classcolor.g, classcolor.b, 1)
			end]]
		--end)

		auraborder:SetFrameStrata(E.db.ElvUI_EltreumUI.borders.aurastrata)
		auraborder:SetFrameLevel(E.db.ElvUI_EltreumUI.borders.auralevel)
	end
end
hooksecurefunc(A, 'CreateIcon', ElvUI_EltreumUI.AuraBorders) --aura (minimap) borders

function ElvUI_EltreumUI:AuraBordersColorDebuff(button)
	if button and E.db.ElvUI_EltreumUI.borders.borders and E.db.ElvUI_EltreumUI.borders.auraborder and E.private.auras.enable and not E.db.ElvUI_EltreumUI.borders.bordertest then
		local auraborder = _G["EltruismAuraBorder"..button:GetName()]
		if not auraborder then return end
		if button.auraType == "debuffs" then
			if debuffColors[button.debuffType] then
				auraborder:SetBackdropBorderColor(debuffColors[button.debuffType].r, debuffColors[button.debuffType].g, debuffColors[button.debuffType].b, 1)
			else
				auraborder:SetBackdropBorderColor(0.8, 0, 0, 1)
			end
		else
			auraborder:SetBackdropBorderColor(classcolor.r, classcolor.g, classcolor.b, 1)
		end
	end

	if button.eltruismbordertest then --cursed borders
		if button.auraType == "debuffs" then
			if debuffColors[button.debuffType] then
				button.eltruismbordertest:SetBackdropBorderColor(debuffColors[button.debuffType].r, debuffColors[button.debuffType].g, debuffColors[button.debuffType].b, 1)
			else
				button.eltruismbordertest:SetBackdropBorderColor(0.8, 0, 0, 1)
			end
		else
			button.eltruismbordertest:SetBackdropBorderColor(classcolor.r, classcolor.g, classcolor.b, 1)
		end
	end
end
hooksecurefunc(A, 'UpdateAura', ElvUI_EltreumUI.AuraBordersColorDebuff) --debuff colors update

function ElvUI_EltreumUI:UFAuraBorders(_,button)
	if button and E.db.ElvUI_EltreumUI.borders.borders and E.db.ElvUI_EltreumUI.borders.auraborderuf and E.private.auras.enable and not E.db.ElvUI_EltreumUI.borders.bordertest then
		ElvUI_EltreumUI:GetButtonCasterForBorderColor(button) --fix the border color
		local auraborder
		if not _G["EltruismAuraBorder"..button:GetName()] then
			auraborder = CreateFrame("Frame", "EltruismAuraBorder"..button:GetName(), button, BackdropTemplateMixin and "BackdropTemplate")
			auraborder:SetPoint("CENTER", button, "CENTER", 0, 0)
			auraborder:SetBackdrop({
				edgeFile = E.LSM:Fetch("border", E.db.ElvUI_EltreumUI.borders.texture),
				edgeSize = E.db.ElvUI_EltreumUI.borders.ufaurasize,
			})
			auraborder:SetFrameStrata(E.db.ElvUI_EltreumUI.borders.auraufstrata)
			auraborder:SetFrameLevel(E.db.ElvUI_EltreumUI.borders.aurauflevel)
			if button.filter == "HELPFUL" then
				auraborder:SetSize(E.db.ElvUI_EltreumUI.borders.ufbuffsizex, E.db.ElvUI_EltreumUI.borders.ufbuffsizey)
				if classcolor2check then
					auraborder:SetBackdropBorderColor(classcolor2.r, classcolor2.g, classcolor2.b, 1)
				else
					auraborder:SetBackdropBorderColor(classcolor.r, classcolor.g, classcolor.b, 1)
				end
			else
				auraborder:SetSize(E.db.ElvUI_EltreumUI.borders.ufdebuffsizex, E.db.ElvUI_EltreumUI.borders.ufdebuffsizey)
				local r,g,b = button:GetBackdropBorderColor()
				if r then
					auraborder:SetBackdropBorderColor(r,g,b, 1)
				else
					auraborder:SetBackdropBorderColor(0.8, 0, 0, 1)
				end
			end
		else
			auraborder = _G["EltruismAuraBorder"..button:GetName()]
			if button.filter == "HELPFUL" then
				auraborder:SetSize(E.db.ElvUI_EltreumUI.borders.ufbuffsizex, E.db.ElvUI_EltreumUI.borders.ufbuffsizey)
				if classcolor2check then
					auraborder:SetBackdropBorderColor(classcolor2.r, classcolor2.g, classcolor2.b, 1)
				else
					auraborder:SetBackdropBorderColor(classcolor.r, classcolor.g, classcolor.b, 1)
				end
			else
				auraborder:SetSize(E.db.ElvUI_EltreumUI.borders.ufdebuffsizex, E.db.ElvUI_EltreumUI.borders.ufdebuffsizey)
				local r,g,b = button:GetBackdropBorderColor()
				if r then
					auraborder:SetBackdropBorderColor(r,g,b, 1)
				else
					auraborder:SetBackdropBorderColor(0.8, 0, 0, 1)
				end
			end
		end
	end

	if button and button.eltruismbordertest then --cursed borders
		if button.isDebuff then
			local r,g,b = button:GetBackdropBorderColor()
			if r then
				button.eltruismbordertest:SetBackdropBorderColor(r,g,b, 1)
			else
				button.eltruismbordertest:SetBackdropBorderColor(classcolor.r, classcolor.g, classcolor.b, 1)
			end
		else
			button.eltruismbordertest:SetBackdropBorderColor(classcolor.r, classcolor.g, classcolor.b, 1)
		end
	end
end
hooksecurefunc(UF, 'PostUpdateAura', ElvUI_EltreumUI.UFAuraBorders) --uf aura borders and debuff colors update

local ttx,tty,tthpx,tthpy
function ElvUI_EltreumUI:TooltipBorder()
	if not _G["EltruismTooltipBorder"] then
		tooltipborder = CreateFrame("Frame", "EltruismTooltipBorder", _G.GameTooltip, BackdropTemplateMixin and "BackdropTemplate")
	else
		tooltipborder = _G["EltruismTooltipBorder"]
	end


	tooltipborder:SetBackdrop({
		edgeFile = bordertexture,
		edgeSize = E.db.ElvUI_EltreumUI.borders.tooltipsize,
	})
	tooltipborder:SetBackdropBorderColor(classcolor.r, classcolor.g, classcolor.b, 1)
	tooltipborder:SetFrameStrata(E.db.ElvUI_EltreumUI.borders.tooltipstrata)
	tooltipborder:SetFrameLevel(E.db.ElvUI_EltreumUI.borders.tooltiplevel)
	--tooltipborder:SetPoint("CENTER", _G.GameTooltip, "CENTER", 0, 0)
	--tooltipborder:SetSize(100, 100)

	 if not tooltipborder.Hooks then
	 	local function FixSize()
	 		if _G.GameTooltipStatusBar and _G.GameTooltipStatusBar:IsShown() and (_G.GameTooltipStatusBar:GetAlpha() ~= 0) then --isshown and isvisible always return true
				tthpx,tthpy = _G.GameTooltipStatusBar:GetSize()
				ttx,tty = _G.GameTooltip:GetSize()
				if E.db.tooltip.healthBar.statusPosition == "TOP" then
					tooltipborder:SetPoint("CENTER", _G.GameTooltip, "CENTER", 0, tthpy/2)
				else
					tooltipborder:SetPoint("CENTER", _G.GameTooltip, "CENTER", 0, -tthpy/2)
				end
				tooltipborder:SetSize(ttx+E.db.ElvUI_EltreumUI.borders.tooltipsizex, tty+tthpy+E.db.ElvUI_EltreumUI.borders.tooltipsizey)
			else
				ttx,tty = _G.GameTooltip:GetSize()
				tooltipborder:SetPoint("CENTER", _G.GameTooltip, "CENTER", 0, 0)
				tooltipborder:SetSize(ttx+E.db.ElvUI_EltreumUI.borders.tooltipsizex, tty+E.db.ElvUI_EltreumUI.borders.tooltipsizey)
			end
	 	end

	 	local function FixColor()
	 		if _G.GameTooltip:GetUnit() and E.db.ElvUI_EltreumUI.borders.classcolor then --has unit
				local _,unittp = _G.GameTooltip:GetUnit() --can error for target of target npc
				if not unittp then
					if UnitExists("targettarget") then
						unittp = "targettarget"
					else
						unittp = "target"
					end
				end
				local reaction = UnitReaction(unittp, "player")
				if UnitIsPlayer(unittp) or (E.Retail and UnitInPartyIsAI(unittp)) then
					local _, classunit = UnitClass(unittp)
					local valuecolors = E:ClassColor(classunit, true)
					tooltipborder:SetBackdropBorderColor(valuecolors.r, valuecolors.g, valuecolors.b, 1)
				else
					local reactionColor = ElvUF.colors.reaction[reaction]
					tooltipborder:SetBackdropBorderColor(reactionColor.r, reactionColor.g, reactionColor.b, 1)
				end
			elseif _G.GameTooltip:GetItem() then --has item
				local name,itemLink = GameTooltip:GetItem()
				if not name then return end
				if not itemLink then return end
				local _, _, itemQuality = GetItemInfo(itemLink)
				if not itemQuality then return end
				local itemR,itemG,itemB = GetItemQualityColor(itemQuality)
				tooltipborder:SetBackdropBorderColor(itemR, itemG, itemB, 1)
			else --is regular tooltip
				tooltipborder:SetBackdropBorderColor(classcolor.r, classcolor.g, classcolor.b, 1)
			end
	 	end

		local function TooltipBorderFix()
			if _G.GameTooltip.shadow then
				_G.GameTooltip.shadow:Hide()
			end
			FixSize()

			FixColor()
		end
		_G.GameTooltip:HookScript("OnShow", TooltipBorderFix) --when it appears
		_G.GameTooltip:HookScript("OnEvent", TooltipBorderFix) --for other events
		_G.GameTooltip:HookScript("OnSizeChanged", TooltipBorderFix) --when comparing
		tooltipborder.Hooks = true
	end
end

function ElvUI_EltreumUI:BordersTargetChanged() --does not work whent target of target changes if the target is not in party/raid, no event to register :(
	if E.db.ElvUI_EltreumUI.borders.borders and E.db.ElvUI_EltreumUI.borders.classcolor and not E.db.ElvUI_EltreumUI.borders.bordertest then

		--targettarget doesnt fire events, and if both units are registered then only the last one is triggering the function, with player never triggering it
		local powertypemonitortarget = CreateFrame("frame")
		powertypemonitortarget:RegisterUnitEvent("UNIT_DISPLAYPOWER", "target")
		powertypemonitortarget:SetScript("OnEvent", function()
			if not UnitExists("target") then return end
			local _, powertypetarget = UnitPowerType("target")
			if E.db.unitframe.units.target.enable and E.db.ElvUI_EltreumUI.borders.targetpower and E.db.unitframe.units.target.power.enable and (E.db.unitframe.units.target.power.width == "spaced" or E.db.unitframe.units.target.power.detachFromFrame) then
				if E.db.unitframe.colors.power[powertypetarget] then
					targetpowerborder:SetBackdropBorderColor(E.db.unitframe.colors.power[powertypetarget].r, E.db.unitframe.colors.power[powertypetarget].g, E.db.unitframe.colors.power[powertypetarget].b, 1)
				else
					targetpowerborder:SetBackdropBorderColor(classcolor.r, classcolor.g, classcolor.b, 1)
				end
			else
				powertypemonitortarget:UnregisterEvent("UNIT_DISPLAYPOWER")
			end
		end)

		local powertypemonitorfocus = CreateFrame("frame")
		powertypemonitorfocus:RegisterUnitEvent("UNIT_DISPLAYPOWER", "focus")
		powertypemonitorfocus:RegisterUnitEvent("PLAYER_FOCUS_CHANGED")
		powertypemonitorfocus:SetScript("OnEvent", function()
			if not UnitExists("focus") then return end
			local _, powertypefocus = UnitPowerType("focus")
			if E.db.unitframe.units.focus.enable and E.db.ElvUI_EltreumUI.borders.focuspowerborder and E.db.unitframe.units.focus.power.enable and (E.db.unitframe.units.focus.power.width == "spaced" or E.db.unitframe.units.focus.power.detachFromFrame) then
				if E.db.unitframe.colors.power[powertypefocus] then
					focuspowerborder:SetBackdropBorderColor(E.db.unitframe.colors.power[powertypefocus].r, E.db.unitframe.colors.power[powertypefocus].g, E.db.unitframe.colors.power[powertypefocus].b, 1)
				else
					focuspowerborder:SetBackdropBorderColor(classcolor.r, classcolor.g, classcolor.b, 1)
				end
			else
				powertypemonitortarget:UnregisterEvent("UNIT_DISPLAYPOWER")
			end
		end)

		local powertypemonitorplayer = CreateFrame("frame")
		powertypemonitorplayer:RegisterUnitEvent("UNIT_DISPLAYPOWER", "player")
		powertypemonitorplayer:SetScript("OnEvent", function()
			local _, powertypeplayer = UnitPowerType("player")
			if playerpowerborder and E.db.unitframe.units.player.enable and E.db.ElvUI_EltreumUI.borders.playerpower and E.db.unitframe.units.player.power.enable and (E.db.unitframe.units.player.power.width == "spaced" or E.db.unitframe.units.player.power.detachFromFrame) then
				if E.db.unitframe.colors.power[powertypeplayer] then
					playerpowerborder:SetBackdropBorderColor(E.db.unitframe.colors.power[powertypeplayer].r, E.db.unitframe.colors.power[powertypeplayer].g, E.db.unitframe.colors.power[powertypeplayer].b, 1)
				else
					playerpowerborder:SetBackdropBorderColor(classcolor.r, classcolor.g, classcolor.b, 1)
				end
			else
				powertypemonitorplayer:UnregisterEvent("UNIT_DISPLAYPOWER")
			end
		end)

		if E.db.unitframe.units.target.enable then
			if UnitExists("target") then
				if E.db.unitframe.units.target.buffs.enable then
					local number = E.db.unitframe.units.target.buffs.numrows * E.db.unitframe.units.target.buffs.perrow or 2
					for i = 1, number do
						if _G["ElvUF_TargetBuffsButton"..i] then
							ElvUI_EltreumUI:UFAuraBorders(nil,_G["ElvUF_TargetBuffsButton"..i])
						end
					end
				end
				if E.db.unitframe.units.target.debuffs.enable then
					local number = E.db.unitframe.units.target.debuffs.numrows * E.db.unitframe.units.target.debuffs.perrow or 2
					for i = 1, number do
						if _G["ElvUF_TargetDebuffsButton"..i] then
							ElvUI_EltreumUI:UFAuraBorders(nil,_G["ElvUF_TargetDebuffsButton"..i])
						end
					end
				end

				if UnitIsPlayer("target") or (E.Retail and UnitInPartyIsAI("target")) then
					local _, targetclass = UnitClass("target")
					if E.db.ElvUI_EltreumUI.borders.targetborder and E.db.unitframe.units.target.enable and targetborder ~= nil then
						targetborder:SetBackdropBorderColor(classcolorreaction[targetclass]["r1"], classcolorreaction[targetclass]["g1"], classcolorreaction[targetclass]["b1"], 1)
					end
					if E.db.ElvUI_EltreumUI.borders.targetcastborder and E.db.unitframe.units.target.castbar.enable and E.db.unitframe.units.target.castbar.overlayOnFrame == "None" and targetcastbarborder ~= nil then
						targetcastbarborder:SetBackdropBorderColor(classcolorreaction[targetclass]["r1"], classcolorreaction[targetclass]["g1"], classcolorreaction[targetclass]["b1"], 1)
					end
					if E.db.ElvUI_EltreumUI.borders.targetpower and E.db.unitframe.units.target.power.enable and (E.db.unitframe.units.target.power.width == "spaced" or E.db.unitframe.units.target.power.detachFromFrame) then
						local _, powertype = UnitPowerType("target")
						if E.db.unitframe.colors.power[powertype] then
							targetpowerborder:SetBackdropBorderColor(E.db.unitframe.colors.power[powertype].r, E.db.unitframe.colors.power[powertype].g, E.db.unitframe.colors.power[powertype].b, 1)
						else
							targetpowerborder:SetBackdropBorderColor(classcolorreaction[targetclass]["r1"], classcolorreaction[targetclass]["g1"], classcolorreaction[targetclass]["b1"], 1)
						end
					end
				elseif not UnitIsPlayer("target") then
					local reactiontarget = UnitReaction("target", "player")
					if reactiontarget >= 5 then
						if E.db.ElvUI_EltreumUI.borders.targetborder and E.db.unitframe.units.target.enable and targetborder ~= nil then
							targetborder:SetBackdropBorderColor(classcolorreaction["NPCFRIENDLY"]["r1"], classcolorreaction["NPCFRIENDLY"]["g1"], classcolorreaction["NPCFRIENDLY"]["b1"], 1)
						end
						if E.db.ElvUI_EltreumUI.borders.targetcastborder and E.db.unitframe.units.target.castbar.enable and E.db.unitframe.units.target.castbar.overlayOnFrame == "None" and targetcastbarborder ~= nil then
							targetcastbarborder:SetBackdropBorderColor(classcolorreaction["NPCFRIENDLY"]["r1"], classcolorreaction["NPCFRIENDLY"]["g1"], classcolorreaction["NPCFRIENDLY"]["b1"], 1)
						end
						if E.db.ElvUI_EltreumUI.borders.targetpower and E.db.unitframe.units.target.power.enable and (E.db.unitframe.units.target.power.width == "spaced" or E.db.unitframe.units.target.power.detachFromFrame) then
							local _, powertype = UnitPowerType("target")
							if E.db.unitframe.colors.power[powertype] then
								targetpowerborder:SetBackdropBorderColor(E.db.unitframe.colors.power[powertype].r, E.db.unitframe.colors.power[powertype].g, E.db.unitframe.colors.power[powertype].b, 1)
							else
								targetpowerborder:SetBackdropBorderColor(classcolorreaction["NPCFRIENDLY"]["r1"], classcolorreaction["NPCFRIENDLY"]["g1"], classcolorreaction["NPCFRIENDLY"]["b1"], 1)
							end
						end
					elseif reactiontarget == 4 then
						if E.db.ElvUI_EltreumUI.borders.targetborder and E.db.unitframe.units.target.enable and targetborder ~= nil then
							targetborder:SetBackdropBorderColor(classcolorreaction["NPCNEUTRAL"]["r1"], classcolorreaction["NPCNEUTRAL"]["g1"], classcolorreaction["NPCNEUTRAL"]["b1"], 1)
						end
						if E.db.ElvUI_EltreumUI.borders.targetcastborder and E.db.unitframe.units.target.castbar.enable and E.db.unitframe.units.target.castbar.overlayOnFrame == "None" and targetcastbarborder ~= nil then
							targetcastbarborder:SetBackdropBorderColor(classcolorreaction["NPCNEUTRAL"]["r1"], classcolorreaction["NPCNEUTRAL"]["g1"], classcolorreaction["NPCNEUTRAL"]["b1"], 1)
						end
						if E.db.ElvUI_EltreumUI.borders.targetpower and E.db.unitframe.units.target.power.enable and (E.db.unitframe.units.target.power.width == "spaced" or E.db.unitframe.units.target.power.detachFromFrame) then
							local _, powertype = UnitPowerType("target")
							if E.db.unitframe.colors.power[powertype] then
								targetpowerborder:SetBackdropBorderColor(E.db.unitframe.colors.power[powertype].r, E.db.unitframe.colors.power[powertype].g, E.db.unitframe.colors.power[powertype].b, 1)
							else
								targetpowerborder:SetBackdropBorderColor(classcolorreaction["NPCNEUTRAL"]["r1"], classcolorreaction["NPCNEUTRAL"]["g1"], classcolorreaction["NPCNEUTRAL"]["b1"], 1)
							end
						end
					elseif reactiontarget == 3 then
						if E.db.ElvUI_EltreumUI.borders.targetborder and E.db.unitframe.units.target.enable and targetborder ~= nil then
							targetborder:SetBackdropBorderColor(classcolorreaction["NPCUNFRIENDLY"]["r1"], classcolorreaction["NPCUNFRIENDLY"]["g1"], classcolorreaction["NPCUNFRIENDLY"]["b1"], 1)
						end
						if E.db.ElvUI_EltreumUI.borders.targetcastborder and E.db.unitframe.units.target.castbar.enable and E.db.unitframe.units.target.castbar.overlayOnFrame == "None" and targetcastbarborder ~= nil then
							targetcastbarborder:SetBackdropBorderColor(classcolorreaction["NPCUNFRIENDLY"]["r1"], classcolorreaction["NPCUNFRIENDLY"]["g1"], classcolorreaction["NPCUNFRIENDLY"]["b1"], 1)
						end
						if E.db.ElvUI_EltreumUI.borders.targetpower and E.db.unitframe.units.target.power.enable and (E.db.unitframe.units.target.power.width == "spaced" or E.db.unitframe.units.target.power.detachFromFrame) then
							local _, powertype = UnitPowerType("target")
							if E.db.unitframe.colors.power[powertype] then
								targetpowerborder:SetBackdropBorderColor(E.db.unitframe.colors.power[powertype].r, E.db.unitframe.colors.power[powertype].g, E.db.unitframe.colors.power[powertype].b, 1)
							else
								targetpowerborder:SetBackdropBorderColor(classcolorreaction["NPCUNFRIENDLY"]["r1"], classcolorreaction["NPCUNFRIENDLY"]["g1"], classcolorreaction["NPCUNFRIENDLY"]["b1"], 1)
							end
						end
					elseif reactiontarget == 2 or reactiontarget == 1 then
						if E.db.ElvUI_EltreumUI.borders.targetborder and E.db.unitframe.units.target.enable and targetborder ~= nil then
							targetborder:SetBackdropBorderColor(classcolorreaction["NPCHOSTILE"]["r1"], classcolorreaction["NPCHOSTILE"]["g1"], classcolorreaction["NPCHOSTILE"]["b1"], 1)
						end
						if E.db.ElvUI_EltreumUI.borders.targetcastborder and E.db.unitframe.units.target.castbar.enable and E.db.unitframe.units.target.castbar.overlayOnFrame == "None" and targetcastbarborder ~= nil then
							targetcastbarborder:SetBackdropBorderColor(classcolorreaction["NPCHOSTILE"]["r1"], classcolorreaction["NPCHOSTILE"]["g1"], classcolorreaction["NPCHOSTILE"]["b1"], 1)
						end
						if E.db.ElvUI_EltreumUI.borders.targetpower and E.db.unitframe.units.target.power.enable and (E.db.unitframe.units.target.power.width == "spaced" or E.db.unitframe.units.target.power.detachFromFrame) then
							local _, powertype = UnitPowerType("target")
							if E.db.unitframe.colors.power[powertype] then
								targetpowerborder:SetBackdropBorderColor(E.db.unitframe.colors.power[powertype].r, E.db.unitframe.colors.power[powertype].g, E.db.unitframe.colors.power[powertype].b, 1)
							else
								targetpowerborder:SetBackdropBorderColor(classcolorreaction["NPCHOSTILE"]["r1"], classcolorreaction["NPCHOSTILE"]["g1"], classcolorreaction["NPCHOSTILE"]["b1"], 1)
							end
						end
					end
				end
			end
		end

		if E.db.unitframe.units.targettarget.enable then
			if E.db.ElvUI_EltreumUI.borders.targettargetborder and E.db.unitframe.units.targettarget.enable then
				if UnitExists("targettarget") and targettargetborder ~= nil then
					if UnitIsPlayer("targettarget") or (E.Retail and UnitInPartyIsAI("targettarget")) then
						local _, targettargetclass = UnitClass("targettarget")
						targettargetborder:SetBackdropBorderColor(classcolorreaction[targettargetclass]["r1"], classcolorreaction[targettargetclass]["g1"], classcolorreaction[targettargetclass]["b1"], 1)
					elseif not UnitIsPlayer("targettarget") then
						local reactiontargettarget = UnitReaction("targettarget", "player")
						if reactiontargettarget >= 5 then
							targettargetborder:SetBackdropBorderColor(classcolorreaction["NPCFRIENDLY"]["r1"], classcolorreaction["NPCFRIENDLY"]["g1"], classcolorreaction["NPCFRIENDLY"]["b1"], 1)
						elseif reactiontargettarget == 4 then
							targettargetborder:SetBackdropBorderColor(classcolorreaction["NPCNEUTRAL"]["r1"], classcolorreaction["NPCNEUTRAL"]["g1"], classcolorreaction["NPCNEUTRAL"]["b1"], 1)
						elseif reactiontargettarget == 3 then
							targettargetborder:SetBackdropBorderColor(classcolorreaction["NPCUNFRIENDLY"]["r1"], classcolorreaction["NPCUNFRIENDLY"]["g1"], classcolorreaction["NPCUNFRIENDLY"]["b1"], 1)
						elseif reactiontargettarget == 2 or reactiontargettarget == 1 then
							targettargetborder:SetBackdropBorderColor(classcolorreaction["NPCHOSTILE"]["r1"], classcolorreaction["NPCHOSTILE"]["g1"], classcolorreaction["NPCHOSTILE"]["b1"], 1)
						end
					end
				end
			end
		end

		if E.db.ElvUI_EltreumUI.borders.focusborder and E.db.unitframe.units.focus.enable and not E.Classic then
			if UnitExists("focus") then
				if focusborder ~= nil then
					if UnitIsPlayer("focus") or (E.Retail and UnitInPartyIsAI("focus")) then
						local _, focusclass = UnitClass("focus")
						focusborder:SetBackdropBorderColor(classcolorreaction[focusclass]["r1"], classcolorreaction[focusclass]["g1"], classcolorreaction[focusclass]["b1"], 1)
					elseif not UnitIsPlayer("focus") then
						local reactionfocus = UnitReaction("focus", "player")
						if reactionfocus >= 5 then
							focusborder:SetBackdropBorderColor(classcolorreaction["NPCFRIENDLY"]["r1"], classcolorreaction["NPCFRIENDLY"]["g1"], classcolorreaction["NPCFRIENDLY"]["b1"], 1)
						elseif reactionfocus == 4 then
							focusborder:SetBackdropBorderColor(classcolorreaction["NPCNEUTRAL"]["r1"], classcolorreaction["NPCNEUTRAL"]["g1"], classcolorreaction["NPCNEUTRAL"]["b1"], 1)
						elseif reactionfocus == 3 then
							focusborder:SetBackdropBorderColor(classcolorreaction["NPCUNFRIENDLY"]["r1"], classcolorreaction["NPCUNFRIENDLY"]["g1"], classcolorreaction["NPCUNFRIENDLY"]["b1"], 1)
						elseif reactionfocus == 2 or reactionfocus == 1 then
							focusborder:SetBackdropBorderColor(classcolorreaction["NPCHOSTILE"]["r1"], classcolorreaction["NPCHOSTILE"]["g1"], classcolorreaction["NPCHOSTILE"]["b1"], 1)
						end
					end
				end
				if focuscastbarborder ~= nil then
					if UnitIsPlayer("focus") or (E.Retail and UnitInPartyIsAI("focus")) then
						local _, focusclass = UnitClass("focus")
						focuscastbarborder:SetBackdropBorderColor(classcolorreaction[focusclass]["r1"], classcolorreaction[focusclass]["g1"], classcolorreaction[focusclass]["b1"], 1)
					elseif not UnitIsPlayer("focus") then
						local reactionfocus = UnitReaction("focus", "player")
						if reactionfocus >= 5 then
							focuscastbarborder:SetBackdropBorderColor(classcolorreaction["NPCFRIENDLY"]["r1"], classcolorreaction["NPCFRIENDLY"]["g1"], classcolorreaction["NPCFRIENDLY"]["b1"], 1)
						elseif reactionfocus == 4 then
							focuscastbarborder:SetBackdropBorderColor(classcolorreaction["NPCNEUTRAL"]["r1"], classcolorreaction["NPCNEUTRAL"]["g1"], classcolorreaction["NPCNEUTRAL"]["b1"], 1)
						elseif reactionfocus == 3 then
							focuscastbarborder:SetBackdropBorderColor(classcolorreaction["NPCUNFRIENDLY"]["r1"], classcolorreaction["NPCUNFRIENDLY"]["g1"], classcolorreaction["NPCUNFRIENDLY"]["b1"], 1)
						elseif reactionfocus == 2 or reactionfocus == 1 then
							focuscastbarborder:SetBackdropBorderColor(classcolorreaction["NPCHOSTILE"]["r1"], classcolorreaction["NPCHOSTILE"]["g1"], classcolorreaction["NPCHOSTILE"]["b1"], 1)
						end
					end
				end
			end
		end

		if E.db.ElvUI_EltreumUI.borders.focustargetborder and E.db.unitframe.units.focustarget.enable and not E.Classic then
			if UnitExists("focustarget") then
				local _, focustargetclass = UnitClass("focustarget")
				local reactionfocustarget = UnitReaction("focustarget", "player")
				if focustargetborder ~= nil then
					if UnitIsPlayer("focustarget") or (E.Retail and UnitInPartyIsAI("focustarget")) then
						focustargetborder:SetBackdropBorderColor(classcolorreaction[focustargetclass]["r1"], classcolorreaction[focustargetclass]["g1"], classcolorreaction[focustargetclass]["b1"], 1)
					elseif not UnitIsPlayer("focustarget") then
						if reactionfocustarget >= 5 then
							focustargetborder:SetBackdropBorderColor(classcolorreaction["NPCFRIENDLY"]["r1"], classcolorreaction["NPCFRIENDLY"]["g1"], classcolorreaction["NPCFRIENDLY"]["b1"], 1)
						elseif reactionfocustarget == 4 then
							focustargetborder:SetBackdropBorderColor(classcolorreaction["NPCNEUTRAL"]["r1"], classcolorreaction["NPCNEUTRAL"]["g1"], classcolorreaction["NPCNEUTRAL"]["b1"], 1)
						elseif reactionfocustarget == 3 then
							focustargetborder:SetBackdropBorderColor(classcolorreaction["NPCUNFRIENDLY"]["r1"], classcolorreaction["NPCUNFRIENDLY"]["g1"], classcolorreaction["NPCUNFRIENDLY"]["b1"], 1)
						elseif reactionfocustarget == 2 or reactionfocustarget == 1 then
							focustargetborder:SetBackdropBorderColor(classcolorreaction["NPCHOSTILE"]["r1"], classcolorreaction["NPCHOSTILE"]["g1"], classcolorreaction["NPCHOSTILE"]["b1"], 1)
						end
					end
				end
			end
		end

		if E.db.ElvUI_EltreumUI.borders.bossborder and E.db.unitframe.units.boss.enable and not E.Classic then
			for i = 1,8 do
				local bossbordername = _G["EltruismBossBorder"..i]
				if UnitExists("boss"..i) and bossbordername ~= nil then
					if UnitIsPlayer("boss1"..i) or (E.Retail and UnitInPartyIsAI("boss1"..i)) then
						local _, bossclass = UnitClass("boss"..i)
						bossbordername:SetBackdropBorderColor(classcolorreaction[bossclass]["r1"], classcolorreaction[bossclass]["g1"], classcolorreaction[bossclass]["b1"], 1)
					elseif not UnitIsPlayer("boss"..i) then
						if E.db.ElvUI_EltreumUI.borders.classcolor then
							local reactionboss = UnitReaction("boss1", "player")
							if reactionboss >= 5 then
								bossbordername:SetBackdropBorderColor(classcolorreaction["NPCFRIENDLY"]["r1"], classcolorreaction["NPCFRIENDLY"]["g1"], classcolorreaction["NPCFRIENDLY"]["b1"], 1)
							elseif reactionboss == 4 then
								bossbordername:SetBackdropBorderColor(classcolorreaction["NPCNEUTRAL"]["r1"], classcolorreaction["NPCNEUTRAL"]["g1"], classcolorreaction["NPCNEUTRAL"]["b1"], 1)
							elseif reactionboss == 3 then
								bossbordername:SetBackdropBorderColor(classcolorreaction["NPCUNFRIENDLY"]["r1"], classcolorreaction["NPCUNFRIENDLY"]["g1"], classcolorreaction["NPCUNFRIENDLY"]["b1"], 1)
							elseif reactionboss <=2 then
								bossbordername:SetBackdropBorderColor(classcolorreaction["NPCHOSTILE"]["r1"], classcolorreaction["NPCHOSTILE"]["g1"], classcolorreaction["NPCHOSTILE"]["b1"], 1)
							end
						else
							bossborder:SetBackdropBorderColor(classcolor.r, classcolor.g, classcolor.b, 1)
						end
					end
				end
			end
		end

		if E.db.ElvUI_EltreumUI.borders.arenaborder and E.db.unitframe.units.arena.enable and not E.Classic then
			for i = 1,5 do
				local arenabordername = _G["EltruismArenaBorder"..i]
				local arenaunit
				if UnitExists("arena"..i) then
					arenaunit = "arena"..i
				else
					arenaunit = "player"
				end
				if arenabordername ~= nil then
					if arenaunit or (E.Retail and UnitInPartyIsAI("arena"..i)) then
						local _, arenaclass = UnitClass(arenaunit)
						arenabordername:SetBackdropBorderColor(classcolorreaction[arenaclass]["r1"], classcolorreaction[arenaclass]["g1"], classcolorreaction[arenaclass]["b1"], 1)
					elseif not UnitIsPlayer(arenaunit) then
						if E.db.ElvUI_EltreumUI.borders.classcolor then
							local reactionarena = UnitReaction(arenaunit, "player")
							if reactionarena >= 5 then
								arenabordername:SetBackdropBorderColor(classcolorreaction["NPCFRIENDLY"]["r1"], classcolorreaction["NPCFRIENDLY"]["g1"], classcolorreaction["NPCFRIENDLY"]["b1"], 1)
							elseif reactionarena == 4 then
								arenabordername:SetBackdropBorderColor(classcolorreaction["NPCNEUTRAL"]["r1"], classcolorreaction["NPCNEUTRAL"]["g1"], classcolorreaction["NPCNEUTRAL"]["b1"], 1)
							elseif reactionarena == 3 then
								arenabordername:SetBackdropBorderColor(classcolorreaction["NPCUNFRIENDLY"]["r1"], classcolorreaction["NPCUNFRIENDLY"]["g1"], classcolorreaction["NPCUNFRIENDLY"]["b1"], 1)
							elseif reactionarena <=2 then
								arenabordername:SetBackdropBorderColor(classcolorreaction["NPCHOSTILE"]["r1"], classcolorreaction["NPCHOSTILE"]["g1"], classcolorreaction["NPCHOSTILE"]["b1"], 1)
							end
						else
							arenaborder:SetBackdropBorderColor(classcolor.r, classcolor.g, classcolor.b, 1)
						end
					end
				end
			end
		end
	end
end

local updatetargettarget = CreateFrame("Frame")
updatetargettarget:RegisterUnitEvent("UNIT_TARGET", "target")
--updatetargettarget:RegisterUnitEvent("UNIT_TARGET", "player")
--updatetargettarget:RegisterUnitEvent("PLAYER_TARGET_CHANGED")
updatetargettarget:RegisterUnitEvent("ENCOUNTER_START")
updatetargettarget:RegisterUnitEvent("PLAYER_FOCUS_CHANGED")
updatetargettarget:SetScript("OnEvent", function()
	if not IsAddOnLoaded("ElvUI_EltreumUI") then
		return
	elseif not E.private.ElvUI_EltreumUI then
		return
	end
	if E.db.ElvUI_EltreumUI.borders.borders and E.db.ElvUI_EltreumUI.borders.classcolor then
		ElvUI_EltreumUI:BordersTargetChanged()
	end
end)

--Function to toggle borders during install
function ElvUI_EltreumUI:ShowHideBorders(install)
	local borderlist = {
		playerborder,
		targetborder,
		targettargetborder,
		targetcastbarborder,
		petborder,
		focusborder,
		bossborder,
		arenaborder,
		powerbarborder,
		MinimapBorder,
		LeftChatBorder,
		RightChatBorder,
		playercastbarborder,
		focuscastbarborder,
		stanceborder,
		experienceborder,
		threatborder,
		playerpowerborder,
		targetpowerborder,
		reputationborder,
		focustargetborder,
		targettargetpowerborder,
		altpowerborder,
		focuspowerborder,
		tooltipborder,
	}
	local barborderbutton
	local barborderbuttonnumber

	local function Show()
		for _, frame in pairs(borderlist) do
			if frame ~= nil then
				frame:Show()
			end
		end
		for _, frame in pairs(partyborderholder) do
			if frame then
				frame:Show()
			end
		end
		for _, frame in pairs(comboborderholder) do
			if frame then
				frame:Show()
			end
		end
		for _, frame in pairs(raid1borderholder) do
			if frame then
				frame:Show()
			end
		end
		for _, frame in pairs(raid2borderholder) do
			if frame then
				frame:Show()
			end
		end
		for _, frame in pairs(raid3borderholder) do
			if frame then
				frame:Show()
			end
		end
		for _, frame in pairs(tankborderholder) do
			if frame then
				frame:Show()
			end
		end
		for _, frame in pairs(assistborderholder) do
			if frame then
				frame:Show()
			end
		end
		for k = 1,6 do
			barborderbutton = "EltruismAB"..k.."Border"
			for b = 1,12 do
				barborderbuttonnumber = tostring(barborderbutton)..tostring(b)
				if _G[barborderbuttonnumber] ~= nil then
					_G[barborderbuttonnumber]:Show()
				end
			end
		end
		for aura = 1,40 do
			if _G["EltruismAuraBorder"..aura] then
				_G["EltruismAuraBorder"..aura]:Show()
			end
		end
		for totem = 1, 7 do
			if _G["EltruismTotemBorderAction"..totem] then
				_G["EltruismTotemBorderAction"..totem]:Show()
			end
		end
		for totemfly = 1, 7 do
			if _G["EltruismTotemBorderFly"..totemfly] then
				_G["EltruismTotemBorderFly"..totemfly]:Show()
			end
		end
		for stance = 1, 10 do
			if _G["EltruismStanceBorder"..stance] then
				_G["EltruismStanceBorder"..stance]:Show()
			end
		end
	end

	local function Hide()
		for _, frame in pairs(borderlist) do
			if frame then
				frame:Hide()
			end
		end
		for _, frame in pairs(partyborderholder) do
			if frame then
				frame:Hide()
			end
		end
		for _, frame in pairs(comboborderholder) do
			if frame then
				frame:Hide()
			end
		end
		for _, frame in pairs(raid1borderholder) do
			if frame then
				frame:Hide()
			end
		end
		for _, frame in pairs(raid2borderholder) do
			if frame then
				frame:Hide()
			end
		end
		for _, frame in pairs(raid3borderholder) do
			if frame then
				frame:Hide()
			end
		end
		for _, frame in pairs(tankborderholder) do
			if frame then
				frame:Hide()
			end
		end
		for _, frame in pairs(assistborderholder) do
			if frame then
				frame:Hide()
			end
		end

		for k = 1,6 do
			barborderbutton = "EltruismAB"..k.."Border"
			for b = 1,12 do
				barborderbuttonnumber = tostring(barborderbutton)..tostring(b)
				if _G[barborderbuttonnumber] ~= nil then
					_G[barborderbuttonnumber]:Hide()
				end
			end
		end
		for aura = 1,40 do
			if _G["EltruismAuraBorder"..aura] then
				_G["EltruismAuraBorder"..aura]:Hide()
			end
		end
		for totem = 1, 7 do
			if _G["EltruismTotemBorderAction"..totem] then
				_G["EltruismTotemBorderAction"..totem]:Hide()
			end
		end
		for totemfly = 1, 7 do
			if _G["EltruismTotemBorderFly"..totemfly] then
				_G["EltruismTotemBorderFly"..totemfly]:Hide()
			end
		end
		for stance = 1, 10 do
			if _G["EltruismStanceBorder"..stance] then
				_G["EltruismStanceBorder"..stance]:Hide()
			end
		end
	end

	ElvUI_EltreumUI:GetBorderClassColors()
	if install or not E.private.ElvUI_EltreumUI.install_version then
		if not E.db.ElvUI_EltreumUI.borders.borders then
			E.db.ElvUI_EltreumUI.borders.borders = true
			E.db.ElvUI_EltreumUI.borders.borderautoadjust = true
			ElvUI_EltreumUI:BorderAdjust()
			ElvUI_EltreumUI:Borders()
			ElvUI_EltreumUI:Shadows()
			Show()
			ElvUI_EltreumUI:Print("Borders Enabled")
		elseif E.db.ElvUI_EltreumUI.borders.borders then
			E.db.ElvUI_EltreumUI.borders.borders = false
			ElvUI_EltreumUI:BorderAdjust()
			E.db.ElvUI_EltreumUI.borders.borderautoadjust = false
			ElvUI_EltreumUI:Shadows()
			Hide()
			ElvUI_EltreumUI:Print("Borders Disabled")
		end
	else
		if not E.db.ElvUI_EltreumUI.borders.borders then
			Hide()
			E.db.ElvUI_EltreumUI.borders.borders = false
			--E.db.ElvUI_EltreumUI.borders.borderautoadjust = false
		elseif E.db.ElvUI_EltreumUI.borders.borders then
			E.db.ElvUI_EltreumUI.borders.borders = true
			--E.db.ElvUI_EltreumUI.borders.borderautoadjust = true
			Show()
		end
	end
end

--regenerate blizz raid frame borders in case it didnt exist before
function ElvUI_EltreumUI:RegenerateBlizzRaidBorders()
	if _G["CompactRaidFrameContainer"] then
		if _G["CompactRaidGroup1Member1"] and _G["CompactRaidGroup1Member1"]:IsVisible() then
			for l = 1, 8 do
				for k = 1, 5 do
					if _G["CompactRaidGroup"..l.."Member"..k] then
						local raid1border
						if not _G["EltruismRaid1Group"..l.."Border"..k] then
							raid1border = CreateFrame("Frame", "EltruismRaid1Group"..l.."Border"..k, _G["CompactRaidGroup"..k.."Member"..l], BackdropTemplateMixin and "BackdropTemplate")
						else
							raid1border = _G["EltruismRaid1Group"..l.."Border"..k]
						end
						table.insert(raid1borderholder, raid1border)
						raid1border:SetSize(E.db.ElvUI_EltreumUI.borders.raidsizex, E.db.ElvUI_EltreumUI.borders.raidsizey)
						raid1border:SetPoint("CENTER", _G["CompactRaidGroup"..l.."Member"..k], "CENTER")
						raid1border:SetParent(_G["CompactRaidGroup"..l.."Member"..k])
						raid1border:SetBackdrop({
							edgeFile = bordertexture,
							edgeSize = E.db.ElvUI_EltreumUI.borders.groupsize,
						})
						if E.db.ElvUI_EltreumUI.borders.classcolor then
							raid1border:SetBackdropBorderColor(1, 1, 1, 1)
						else
							raid1border:SetBackdropBorderColor(classcolor.r, classcolor.g, classcolor.b, 1)
						end
						raid1border:SetFrameStrata(E.db.ElvUI_EltreumUI.borders.raidstrata)
						raid1border:SetFrameLevel(E.db.ElvUI_EltreumUI.borders.raidlevel)
					end
				end
			end
		elseif _G["CompactRaidFrame1"] and _G["CompactRaidFrame1"]:IsVisible() then
			for i = 1, 40 do
				if _G["CompactRaidFrame"..i] then
					local raid1border
					if not _G["EltruismRaid1Group".."Border"..i] then
						raid1border = CreateFrame("Frame", "EltruismRaid1GroupBorder"..i, _G["CompactRaidFrame"..i], BackdropTemplateMixin and "BackdropTemplate")
					else
						raid1border = _G["EltruismRaid1Group".."Border"..i]
					end
					table.insert(raid1borderholder, raid1border)
					raid1border:SetSize(E.db.ElvUI_EltreumUI.borders.raidsizex, E.db.ElvUI_EltreumUI.borders.raidsizey)
					raid1border:SetPoint("CENTER", _G["CompactRaidFrame"..i], "CENTER")
					raid1border:SetParent(_G["CompactRaidFrame"..i])
					raid1border:SetBackdrop({
						edgeFile = bordertexture,
						edgeSize = E.db.ElvUI_EltreumUI.borders.groupsize,
					})
					if E.db.ElvUI_EltreumUI.borders.classcolor then
						raid1border:SetBackdropBorderColor(1, 1, 1, 1)
					else
						raid1border:SetBackdropBorderColor(classcolor.r, classcolor.g, classcolor.b, 1)
					end
					raid1border:SetFrameStrata(E.db.ElvUI_EltreumUI.borders.raidstrata)
					raid1border:SetFrameLevel(E.db.ElvUI_EltreumUI.borders.raidlevel)
				end
			end
		end
	end
end

--set class color to party/raid borders
function ElvUI_EltreumUI:GroupBorderColorUpdate()
	if E.db.ElvUI_EltreumUI.borders.borders and E.db.ElvUI_EltreumUI.borders.classcolor then
		if E.db.ElvUI_EltreumUI.borders.partyborders and E.db.unitframe.units.party.enable then
			for i = 1,5 do
				if _G["EltruismPartyBorder"..i] then
					if _G["ElvUF_PartyGroup1UnitButton"..i] then
						local _ , unitclass = UnitClass(_G["ElvUF_PartyGroup1UnitButton"..i].unit)
						if unitclass then
							_G["EltruismPartyBorder"..i]:SetBackdropBorderColor(classcolorreaction[unitclass]["r1"], classcolorreaction[unitclass]["g1"], classcolorreaction[unitclass]["b1"], 1)
						end
					end
				end
			end
		end

		if E.db.ElvUI_EltreumUI.borders.raidborders then
			if E.db.unitframe.units.raid1.enable then
				for k = 1, 8 do
					for l = 1, 5 do
						if _G["EltruismRaid1Group"..k.."Border"..l] then
							if _G["ElvUF_Raid1Group"..k.."UnitButton"..l] then
								local _ , unitclass = UnitClass(_G["ElvUF_Raid1Group"..k.."UnitButton"..l].unit)
								if unitclass then
									_G["EltruismRaid1Group"..k.."Border"..l]:SetBackdropBorderColor(classcolorreaction[unitclass]["r1"], classcolorreaction[unitclass]["g1"], classcolorreaction[unitclass]["b1"], 1)
								end
							end
						end
					end
				end
			elseif not E.db.unitframe.units.raid1.enable and not E.private.unitframe.disabledBlizzardFrames.raid then
				if _G["CompactRaidFrameContainer"] then
					if _G["CompactRaidGroup1Member1"] and _G["CompactRaidGroup1Member1"]:IsVisible() then
						for k = 1, 8 do
							for l = 1, 5 do
								if _G["CompactRaidGroup"..k.."Member"..l] then
									if _G["CompactRaidGroup"..k.."Member"..l].displayedUnit then
										local _ , unitclass = UnitClass(_G["CompactRaidGroup"..k.."Member"..l].displayedUnit)
										if unitclass then
											if _G["EltruismRaid1Group"..k.."Border"..l] then
												_G["EltruismRaid1Group"..k.."Border"..l]:SetBackdropBorderColor(classcolorreaction[unitclass]["r1"], classcolorreaction[unitclass]["g1"], classcolorreaction[unitclass]["b1"], 1)
											else
												ElvUI_EltreumUI:RegenerateBlizzRaidBorders()
												_G["EltruismRaid1Group"..k.."Border"..l]:SetBackdropBorderColor(classcolorreaction[unitclass]["r1"], classcolorreaction[unitclass]["g1"], classcolorreaction[unitclass]["b1"], 1)
											end
										end
									end
								end
							end
						end
					elseif _G["CompactRaidFrame1"] and _G["CompactRaidFrame1"]:IsVisible() then
						for i = 1, 40 do
							if _G["CompactRaidFrame"..i] then
								if _G["CompactRaidFrame"..i].displayedUnit then
									local _ , unitclass = UnitClass(_G["CompactRaidFrame"..i].displayedUnit)
									if unitclass then
										if _G["EltruismRaid1GroupBorder"..i] then
											_G["EltruismRaid1GroupBorder"..i]:SetBackdropBorderColor(classcolorreaction[unitclass]["r1"], classcolorreaction[unitclass]["g1"], classcolorreaction[unitclass]["b1"], 1)
										else
											ElvUI_EltreumUI:RegenerateBlizzRaidBorders()
											_G["EltruismRaid1GroupBorder"..i]:SetBackdropBorderColor(classcolorreaction[unitclass]["r1"], classcolorreaction[unitclass]["g1"], classcolorreaction[unitclass]["b1"], 1)
										end
									end
								end
							end
						end
					end
				end
			end
		end

		if E.db.unitframe.units.raid2.enable and E.db.ElvUI_EltreumUI.borders.raid2borders then
			for k = 1, 8 do
				for l = 1, 5 do
					if _G["EltruismRaid2Group"..k.."Border"..l] then
						if _G["ElvUF_Raid2Group"..k.."UnitButton"..l] then
							local _ , unitclass = UnitClass(_G["ElvUF_Raid2Group"..k.."UnitButton"..l].unit)
							if unitclass then
								_G["EltruismRaid2Group"..k.."Border"..l]:SetBackdropBorderColor(classcolorreaction[unitclass]["r1"], classcolorreaction[unitclass]["g1"], classcolorreaction[unitclass]["b1"], 1)
							end
						end
					end
				end
			end
		end

		if E.db.unitframe.units.raid3.enable and E.db.ElvUI_EltreumUI.borders.raid40borders then
			for k = 1, 8 do
				for l = 1, 5 do
					if _G["EltruismRaid3Group"..k.."Border"..l] then
						if _G["ElvUF_Raid3Group"..k.."UnitButton"..l] then
							local _ , unitclass = UnitClass(_G["ElvUF_Raid3Group"..k.."UnitButton"..l].unit)
							if unitclass then
								_G["EltruismRaid3Group"..k.."Border"..l]:SetBackdropBorderColor(classcolorreaction[unitclass]["r1"], classcolorreaction[unitclass]["g1"], classcolorreaction[unitclass]["b1"], 1)
							end
						end
					end
				end
			end
		end

		if E.db.ElvUI_EltreumUI.borders.tankassistborders and E.db.unitframe.units.tank.enable then
			for k = 1, 8 do
				if _G["ElvUF_TankUnitButton"..k.."Border"] then
					if _G["ElvUF_TankUnitButton"..k.."Border"] then
						local _ , unitclass = UnitClass(_G["ElvUF_TankUnitButton"..k].unit)
						if unitclass then
							_G["ElvUF_TankUnitButton"..k.."Border"]:SetBackdropBorderColor(classcolorreaction[unitclass]["r1"], classcolorreaction[unitclass]["g1"], classcolorreaction[unitclass]["b1"], 1)
						end
					end
				end
			end
			for k = 1, 8 do
				if _G["ElvUF_AssistUnitButton"..k.."Border"] then
					if _G["ElvUF_AssistUnitButton"..k.."Border"] then
						local _ , unitclass = UnitClass(_G["ElvUF_AssistUnitButton"..k].unit)
						if unitclass then
							_G["ElvUF_AssistUnitButton"..k.."Border"]:SetBackdropBorderColor(classcolorreaction[unitclass]["r1"], classcolorreaction[unitclass]["g1"], classcolorreaction[unitclass]["b1"], 1)
						end
					end
				end
			end
		end
	end
end
