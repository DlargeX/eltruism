local E = unpack(ElvUI)
local S = E:GetModule('Skins')
local _G = _G
--local classcolor = E:ClassColor(E.myclass, true)
local pairs = _G.pairs
local tostring = _G.tostring
local tonumber = _G.tonumber
local InCombatLockdown = _G.InCombatLockdown
local IsAddOnLoaded = _G.C_AddOns and _G.C_AddOns.IsAddOnLoaded
local GetQuestItemInfo = _G.GetQuestItemInfo
local GetItemQualityColor = _G.C_Item and _G.C_Item.GetItemQualityColor or _G.GetItemQualityColor

--skin immersion
function ElvUI_EltreumUI:EltruismImmersion()
	if not IsAddOnLoaded("ElvUI_EltreumUI") then return end
	if not E.db.general.font then return end
	if not E.db.general.fontSize then return end
	if not E.db.general.fontStyle then return end
	if not E.LSM:Fetch("font", E.db.general.font) then return end
	if E.db.ElvUI_EltreumUI.skins.immersion then
		local frames = {
			_G["ImmersionFrame"].TalkBox.BackgroundFrame,
			_G["ImmersionFrame"].TalkBox.Elements,
			_G["ImmersionFrame"].TalkBox.PortraitFrame,
		}
		for _, v in pairs(frames) do
			S:HandleFrame(v)
		end

		if _G["ImmersionFrame"].TalkBox.ReputationBar then
			S:HandleStatusBar(_G["ImmersionFrame"].TalkBox.ReputationBar)
			_G["ImmersionFrame"].TalkBox.ReputationBar:ClearAllPoints()
			_G["ImmersionFrame"].TalkBox.ReputationBar:SetPoint("BOTTOMLEFT", _G["ImmersionFrame"].TalkBox, "TOPLEFT", 0, E.db.ElvUI_EltreumUI.skins.shadow.length)
			_G["ImmersionFrame"].TalkBox.ReputationBar:SetPoint("BOTTOMRIGHT", _G["ImmersionFrame"].TalkBox, "TOPRIGHT", 0, E.db.ElvUI_EltreumUI.skins.shadow.length)
			_G["ImmersionFrame"].TalkBox.ReputationBar:SetHeight(4)
			if E.db.ElvUI_EltreumUI.skins.shadow.enable and not E.db.ElvUI_EltreumUI.borders.universalborders then
				if not _G["ImmersionFrame"].TalkBox.ReputationBar.shadow then
					_G["ImmersionFrame"].TalkBox.ReputationBar:CreateShadow(E.db.ElvUI_EltreumUI.skins.shadow.length)
					ElvUI_EltreumUI:ShadowColor(_G["ImmersionFrame"].TalkBox.ReputationBar.shadow)
				end
			end
		end

		if _G["ImmersionFrame"].TalkBox.ProgressionBar then
			S:HandleStatusBar(_G["ImmersionFrame"].TalkBox.ProgressionBar)
			local width, height = _G["ImmersionFrame"].TalkBox.ProgressionBar:GetSize()
			_G["ImmersionFrame"].TalkBox.ProgressionBar:GetStatusBarTexture():SetGradient(E.db.ElvUI_EltreumUI.unitframes.gradientmode.orientationpower, ElvUI_EltreumUI:GradientColors(E.myclass, false, false))
			_G["ImmersionFrame"].TalkBox.ProgressionBar:SetSize(width,height+5)
		end

		if E.db.ElvUI_EltreumUI.skins.shadow.enable and not E.db.ElvUI_EltreumUI.borders.universalborders then
			for _, frame in pairs(frames) do
				if frame and not frame.shadow then
					frame:CreateShadow(E.db.ElvUI_EltreumUI.skins.shadow.length)
					ElvUI_EltreumUI:ShadowColor(frame.shadow)
				end
			end
			if E.Classic then
				if _G["ImmersionFrame"].TalkBox.BackgroundFrame.shadow then
					_G["ImmersionFrame"].TalkBox.BackgroundFrame.shadow:Hide()
				end
				local classicframes = {
					_G["ImmersionFrame"].TalkBox.MainFrame,
					_G["ImmersionFrame"].TalkBox.Elements,
				}
				for _, frame in pairs(classicframes) do
					if frame and not frame.shadow then
						frame:CreateShadow(E.db.ElvUI_EltreumUI.skins.shadow.length)
						ElvUI_EltreumUI:ShadowColor(frame.shadow)
					end
				end
			end
		end

		S:HandleCloseButton(_G["ImmersionFrame"].TalkBox.MainFrame.CloseButton)

		--hide highlights/animations
		_G["ImmersionFrame"].TalkBox.MainFrame.Model.ModelShadow:Hide()
		_G["ImmersionFrame"].TalkBox.MainFrame.Model.PortraitBG:Hide()
		_G["ImmersionFrame"].TalkBox.Hilite:Hide()
		_G["ImmersionFrame"].TalkBox.PortraitFrame:Hide()
		_G["ImmersionFrame"].TalkBox.MainFrame.TextSheen:StripTextures()
		_G["ImmersionFrame"].TalkBox.MainFrame.Sheen:StripTextures()
		_G["ImmersionFrame"].TalkBox.MainFrame.Overlay:StripTextures()

		--fonts
		if _G["ImmersionFrame"].TalkBox.TextFrame then
			if _G["ImmersionFrame"].TalkBox.TextFrame.SpeechProgress then
				_G["ImmersionFrame"].TalkBox.TextFrame.SpeechProgress:SetFont(E.LSM:Fetch("font", E.db.general.font), E.db.general.fontSize + 4, ElvUI_EltreumUI:FontFlag(E.db.general.fontStyle))
			end
			if _G["ImmersionFrame"].TalkBox.NameFrame.Name then
				_G["ImmersionFrame"].TalkBox.NameFrame.Name:SetFont(E.LSM:Fetch("font", E.db.general.font), E.db.general.fontSize + 4, ElvUI_EltreumUI:FontFlag(E.db.general.fontStyle))
			end
			if _G["ImmersionFrame"].TalkBox.TextFrame.Text then
				_G["ImmersionFrame"].TalkBox.TextFrame.Text:SetFont(E.LSM:Fetch("font", E.db.general.font), E.db.general.fontSize + 2, ElvUI_EltreumUI:FontFlag(E.db.general.fontStyle))
			end
		end
		if _G["ImmersionContentFrame"] then
			if _G["ImmersionContentFrame"].ObjectivesHeader then
				_G["ImmersionContentFrame"].ObjectivesHeader:SetFont(E.LSM:Fetch("font", E.db.general.font), E.db.general.fontSize + 6, ElvUI_EltreumUI:FontFlag(E.db.general.fontStyle))
			end
			if _G["ImmersionContentFrame"].ObjectivesText then
				_G["ImmersionContentFrame"].ObjectivesText:SetFont(E.LSM:Fetch("font", E.db.general.font), E.db.general.fontSize + 1, ElvUI_EltreumUI:FontFlag(E.db.general.fontStyle))
			end

			if _G["ImmersionContentFrame"].RewardsFrame then
				if _G["ImmersionContentFrame"].RewardsFrame.Header then
					_G["ImmersionContentFrame"].RewardsFrame.Header:SetFont(E.LSM:Fetch("font", E.db.general.font), E.db.general.fontSize + 6, ElvUI_EltreumUI:FontFlag(E.db.general.fontStyle))
				end
				if _G["ImmersionContentFrame"].RewardsFrame.ItemChooseText then
					_G["ImmersionContentFrame"].RewardsFrame.ItemChooseText:SetFont(E.LSM:Fetch("font", E.db.general.font), E.db.general.fontSize + 1, ElvUI_EltreumUI:FontFlag(E.db.general.fontStyle))
				end
				if _G["ImmersionContentFrame"].RewardsFrame.ItemReceiveText then
					_G["ImmersionContentFrame"].RewardsFrame.ItemReceiveText:SetFont(E.LSM:Fetch("font", E.db.general.font), E.db.general.fontSize + 1, ElvUI_EltreumUI:FontFlag(E.db.general.fontStyle))
				end
			end
		end

		--update buttons on events/show
		local function updatebuttons()
			if not E.db.general then return end
			if not E.db.general.font then return end
			if not E.db.general.fontSize then return end
			if not E.db.general.fontStyle then return end
			if not E.LSM:Fetch("font", E.db.general.font) then return end

			--move so it doesnt overlap
			if not InCombatLockdown() then
				_G["ImmersionFrame"].TalkBox.Elements:ClearAllPoints()
				_G["ImmersionFrame"].TalkBox.Elements:SetPoint("TOP", _G["ImmersionFrame"].TalkBox, "BOTTOM", 0, -10)
			end

			for i = 1, 30 do --button seems to go to 20, but there might be more somewhere
				if _G["ImmersionQuestInfoItem" .. i] then
					if not _G["ImmersionQuestInfoItem" .. i].EltruismSkin then
						_G["ImmersionQuestInfoItem" .. i].NameFrame:StripTextures()
						_G["ImmersionQuestInfoItem" .. i].NameFrame:CreateBackdrop('Transparent')
						_G["ImmersionQuestInfoItem" .. i].NameFrame.backdrop:ClearAllPoints()
						_G["ImmersionQuestInfoItem" .. i].NameFrame.backdrop:SetPoint("TOPLEFT",_G["ImmersionQuestInfoItem" .. i .."Name"],"TOPLEFT",-3,-1)
						_G["ImmersionQuestInfoItem" .. i].NameFrame.backdrop:SetPoint("BOTTOMRIGHT",_G["ImmersionQuestInfoItem" .. i .."Name"],"BOTTOMRIGHT",-7,0)
						--_G["ImmersionQuestInfoItem" .. i].NameFrame.backdrop:SetOutside(_G["ImmersionQuestInfoItem" .. i .."Name"])
						_G["ImmersionQuestInfoItem" .. i].NameFrame.backdrop:SetAlpha(0.5) --transparent is setting alpha to 1 for some reason
						if _G["ImmersionQuestInfoItem"..i].objectType and _G["ImmersionQuestInfoItem"..i].objectType == "item" and _G["ImmersionQuestInfoItem" .. i].Name:GetText() ~= nil then
							local _, _, _, quality = GetQuestItemInfo(tostring(_G["ImmersionQuestInfoItem"..i].type), tonumber(_G["ImmersionQuestInfoItem" .. i]:GetID()))
							local r,g,b = GetItemQualityColor(quality)
							_G["ImmersionQuestInfoItem" .. i].Name:SetTextColor(r, g, b)
							--_G["ImmersionQuestInfoItem" .. i].NameFrame.backdrop:SetBackdropBorderColor(r, g, b)
						end
						if _G["ImmersionQuestInfoItem" .. i].Name then
							_G["ImmersionQuestInfoItem" .. i].Name:SetFont(E.LSM:Fetch("font", E.db.general.font), E.db.general.fontSize, ElvUI_EltreumUI:FontFlag(E.db.general.fontStyle))
						end
						_G["ImmersionQuestInfoItem" .. i].EltruismSkin = true
					else
						if _G["ImmersionQuestInfoItem" .. i].NameFrame.backdrop then
							_G["ImmersionQuestInfoItem" .. i].NameFrame.backdrop:ClearAllPoints()
							_G["ImmersionQuestInfoItem" .. i].NameFrame.backdrop:SetPoint("TOPLEFT",_G["ImmersionQuestInfoItem" .. i .."Name"],"TOPLEFT",-3,-1)
							_G["ImmersionQuestInfoItem" .. i].NameFrame.backdrop:SetPoint("BOTTOMRIGHT",_G["ImmersionQuestInfoItem" .. i .."Name"],"BOTTOMRIGHT",-7,0)
						end
						if _G["ImmersionQuestInfoItem" .. i].Name then
							_G["ImmersionQuestInfoItem" .. i].Name:SetFont(E.LSM:Fetch("font", E.db.general.font), E.db.general.fontSize, ElvUI_EltreumUI:FontFlag(E.db.general.fontStyle))
						end
					end
				end
				if _G["ImmersionProgressItem" .. i] then
					if not _G["ImmersionProgressItem" .. i].EltruismSkin then
						_G["ImmersionProgressItem" .. i].NameFrame:StripTextures()
						_G["ImmersionProgressItem" .. i].NameFrame:CreateBackdrop('Transparent')
						_G["ImmersionProgressItem" .. i].NameFrame.backdrop:ClearAllPoints()
						_G["ImmersionProgressItem" .. i].NameFrame.backdrop:SetPoint("TOPLEFT",_G["ImmersionProgressItem" .. i .."Name"],"TOPLEFT",-3,0)
						_G["ImmersionProgressItem" .. i].NameFrame.backdrop:SetPoint("BOTTOMRIGHT",_G["ImmersionProgressItem" .. i .."Name"],"BOTTOMRIGHT",-7,0)
						--_G["ImmersionProgressItem" .. i].NameFrame.backdrop:SetOutside(_G["ImmersionProgressItem" .. i .."Name"])
						_G["ImmersionProgressItem" .. i].NameFrame.backdrop:SetAlpha(0.5) --transparent is setting alpha to 1 for some reason
						if _G["ImmersionProgressItem"..i].objectType and _G["ImmersionProgressItem"..i].objectType == "item" then
							local _, _, _, quality = GetQuestItemInfo(tostring(_G["ImmersionProgressItem"..i].type), tonumber(_G["ImmersionProgressItem" .. i]:GetID()))
							local r,g,b = GetItemQualityColor(quality)
							--_G["ImmersionProgressItem" .. i].NameFrame.backdrop:SetBackdropBorderColor(r, g, b)
							_G["ImmersionProgressItem" .. i].Name:SetTextColor(r, g, b)
						end
						if _G["ImmersionProgressItem" .. i].Name then
							_G["ImmersionProgressItem" .. i].Name:SetFont(E.LSM:Fetch("font", E.db.general.font), E.db.general.fontSize, ElvUI_EltreumUI:FontFlag(E.db.general.fontStyle))
						end
						_G["ImmersionProgressItem" .. i].EltruismSkin = true
					else
						if _G["ImmersionProgressItem" .. i].NameFrame.backdrop then
							_G["ImmersionProgressItem" .. i].NameFrame.backdrop:ClearAllPoints()
							_G["ImmersionProgressItem" .. i].NameFrame.backdrop:SetPoint("TOPLEFT",_G["ImmersionProgressItem" .. i .."Name"],"TOPLEFT",-3,0)
							_G["ImmersionProgressItem" .. i].NameFrame.backdrop:SetPoint("BOTTOMRIGHT",_G["ImmersionProgressItem" .. i .."Name"],"BOTTOMRIGHT",-7,0)
						end

						if _G["ImmersionProgressItem" .. i].Name then
							_G["ImmersionProgressItem" .. i].Name:SetFont(E.LSM:Fetch("font", E.db.general.font), E.db.general.fontSize, ElvUI_EltreumUI:FontFlag(E.db.general.fontStyle))
						end
					end
				end
			end

			for _, v in ipairs(_G["ImmersionFrame"].TitleButtons.Buttons) do
				if v then
					--S:HandleButton(v,true,nil,nil,true,"TRANSPARENT")
					S:HandleButton(v)
					--v:CreateBackdrop('Transparent')
					v.Hilite:Hide()
					v.Overlay:Hide()
					--v:StyleButton()
					v.Center:Show()
					v.Center:SetAlpha(E.db.general.backdropfadecolor.a)
					--v.Center.SetAlpha = E.noop
					--v.backdrop:SetAlpha(E.db.general.backdropfadecolor.a)

					--v.hover:SetVertexColor(classcolor.r, classcolor.g,classcolor.b, 0.7) --hover color
					--v.pushed:SetColorTexture(classcolor.r, classcolor.g,classcolor.b, 0.8) --pushed color
					v.Label:SetFont(E.LSM:Fetch("font", E.db.general.font), E.db.general.fontSize+3, ElvUI_EltreumUI:FontFlag(E.db.general.fontStyle))
					v.Label:SetShadowOffset(1,-1)
					if E.db.ElvUI_EltreumUI.skins.shadow.enable and not E.db.ElvUI_EltreumUI.borders.universalborders then
						if v and not v.shadow then
							v:CreateShadow(E.db.ElvUI_EltreumUI.skins.shadow.length)
							ElvUI_EltreumUI:ShadowColor(v.shadow)
						end
					end
					if not v.EltruismPoint then
						local point, relativeTo, relativePoint, xOfs, yOfs = v:GetPoint()
						v:ClearAllPoints()
						v:SetPoint(point,relativeTo,relativePoint,xOfs,yOfs-5)
						v.EltruismPoint = true
					end
				end
			end
		end

		--buttons are created depending on quest, hook frame to update them
		_G["ImmersionFrame"]:HookScript("OnShow", updatebuttons)
		_G["ImmersionFrame"]:HookScript("OnEvent", updatebuttons)
		updatebuttons() --fire before show just in case
	end
end
S:AddCallbackForAddon('Immersion', "EltruismImmersion", ElvUI_EltreumUI.EltruismImmersion)
