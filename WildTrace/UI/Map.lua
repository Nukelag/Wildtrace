local WT = WildTrace

WT.MapMarkers = {}

local function shouldShowCreature(creature)
    if not WildTraceDB or not WildTraceDB.showIcons then return false end
    local status = WT.GetCreatureStatus(creature.id)
    if status.hunted then
        return not WildTraceDB.hideHunted
    end
    return WildTraceDB.showPendingHunt and true or false
end

local function createMarker(creature, location, markerID)
    local marker = CreateFrame("Button", nil, WorldMapButton)
    marker:SetWidth(17)
    marker:SetHeight(17)
    marker:SetFrameLevel(WorldMapButton:GetFrameLevel() + 8)
    marker:RegisterForClicks("LeftButtonUp")

    local icon = marker:CreateTexture(nil, "ARTWORK")
    icon:SetTexture("Interface\\AddOns\\WildTrace\\Textures\\Map\\MarkerPending.tga")
    icon:SetWidth(15)
    icon:SetHeight(15)
    icon:SetPoint("CENTER", marker, "CENTER", 0, 0)
    marker.icon = icon

    marker:SetScript("OnEnter", function(self) WT.ShowCreatureTooltip(self, self.creature) end)
    marker:SetScript("OnLeave", function() GameTooltip:Hide() end)
    marker:SetScript("OnClick", function(self) WT.ShowCreatureMenu(self.creature, self) end)
    marker.creature = creature
    marker.location = location
    marker.markerID = markerID
    return marker
end

local function getOrCreateMarker(creature, location, slot)
    local marker = WT.MapMarkers[slot]
    if not marker then
        marker = createMarker(creature, location, slot)
        WT.MapMarkers[slot] = marker
    end
    marker.creature = creature
    marker.location = location
    marker.markerID = slot
    return marker
end

local function applyMarkerIcon(marker, creatureID)
    if not marker.icon then return end
    local status = WT.GetCreatureStatus(creatureID)
    local texture = status.hunted
        and "Interface\\AddOns\\WildTrace\\Textures\\Map\\MarkerHunted.tga"
        or "Interface\\AddOns\\WildTrace\\Textures\\Map\\MarkerPending.tga"
    marker.icon:SetTexture(texture)
    marker.icon:SetAlpha(1)
    marker.icon:Show()
end

function WT.RefreshCreatureMarkers(creatureID)
    if WorldMapFrame and WorldMapFrame:IsShown() then
        WT.RefreshMapMarkers()
        WT.PendingMarkerRefresh = true
    end
end

if not WT.MarkerRefreshFrame then
    WT.MarkerRefreshFrame = CreateFrame("Frame", "WT_MarkerRefreshFrame")
    WT.MarkerRefreshFrame:SetScript("OnUpdate", function(self)
        if WT.PendingMarkerRefresh then
            WT.PendingMarkerRefresh = nil
            WT.RefreshMapMarkers()
        end
    end)
end

local function getMapMarkerLocations(creature)
    if creature.markerCenter then
        return { creature.markerCenter }, true
    end
    return creature.locations or {}, false
end

function WT.RefreshMapMarkers()
    if not WorldMapFrame or not WorldMapButton then return end
    for _, marker in pairs(WT.MapMarkers) do marker:Hide() end
    if not WorldMapFrame:IsShown() or not WildTraceDB then return end

    local mapFile = GetMapInfo and GetMapInfo() or nil
    if not mapFile then return end
    local width, height = WorldMapButton:GetWidth(), WorldMapButton:GetHeight()
    if not width or not height or width == 0 or height == 0 then return end

    if not WildTraceDB.showIcons then return end

    local nextSlot = 0
    for _, zone in pairs(WT.Zones) do
        if zone.mapFile == mapFile then
            for _, creature in ipairs(zone.creatures) do
                if shouldShowCreature(creature) then
                    local locations = getMapMarkerLocations(creature)
                    for _, location in ipairs(locations) do
                        local x = location.x or location[1]
                        local y = location.y or location[2]
                        if type(x) == "number" and type(y) == "number"
                            and x >= 0 and x <= 100 and y >= 0 and y <= 100 then
                            nextSlot = nextSlot + 1
                            local marker = getOrCreateMarker(creature, location, nextSlot)
                            marker:ClearAllPoints()
                            marker:SetPoint("CENTER", WorldMapButton, "TOPLEFT", (x / 100) * width, -(y / 100) * height)
                            applyMarkerIcon(marker, creature.id)
                            marker:SetFrameLevel(WorldMapButton:GetFrameLevel() + 8)
                            marker:Show()
                        end
                    end
                end
            end
        end
    end
end

function WT.PositionMapOptionsButton()
    if not WT.MapOptionsButton or not WorldMapFrame then return end
    if not WorldMapButton then return end
    WT.MapOptionsButton:ClearAllPoints()
    WT.MapOptionsButton:SetPoint("CENTER", WorldMapButton, "TOPLEFT",
        WorldMapButton:GetWidth() * 0.98,
        -(WorldMapButton:GetHeight() * 0.055))
    WT.MapOptionsButton:SetFrameStrata(WorldMapButton:GetFrameStrata())
    WT.MapOptionsButton:SetFrameLevel(WorldMapButton:GetFrameLevel() + 25)
    if WT.MapOptionsFrame then
        WT.MapOptionsFrame:SetFrameStrata("FULLSCREEN_DIALOG")
        WT.MapOptionsFrame:SetFrameLevel(220)
    end

end

local function isMouseWithinFrameTree(frame)
    if not frame then return false end
    if GetMouseFocus then
        local focus = GetMouseFocus()
        while focus do
            if focus == frame then return true end
            if not focus.GetParent then break end
            focus = focus:GetParent()
        end
    end
    return MouseIsOver and MouseIsOver(frame) or false
end

function WT.CreateMapControls()
    if not WorldMapFrame or WT.MapOptionsButton then return end

    local button = CreateFrame("Button", "WT_MapOptionsButton", WorldMapButton)
    button:SetWidth(29)
    button:SetHeight(29)
    button:EnableMouse(true)
    button:RegisterForClicks("LeftButtonUp")
    local paw = button:CreateTexture(nil, "ARTWORK")
    paw:SetTexture("Interface\\AddOns\\WildTrace\\Textures\\Brand\\LogoButton.tga")
    paw:SetAllPoints(button)
    button:SetFrameStrata(WorldMapButton:GetFrameStrata())
    button:SetFrameLevel(WorldMapButton:GetFrameLevel() + 25)
    WT.MapOptionsButton = button

    local panel = CreateFrame("Frame", "WT_MapOptionsFrame", UIParent)
    panel:SetWidth(332)
    panel:SetHeight(125)
    panel:SetFrameStrata("FULLSCREEN_DIALOG")
    panel:SetFrameLevel(220)
    panel:EnableMouse(true)
    panel:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8X8", edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", tile = true, tileSize = 8, edgeSize = 14, insets = { left = 4, right = 4, top = 4, bottom = 4 } })
    panel:SetBackdropColor(0.20, 0.19, 0.18, 0.96)
    panel:SetBackdropBorderColor(0.46, 0.44, 0.4, 1.0)
    panel.title = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    panel.title:SetPoint("TOPLEFT", panel, "TOPLEFT", 16, -14)
    panel.title:SetText("Visualización en el mapa")

    local function addCheckbox(name, label, y, key)
        local check = CreateFrame("CheckButton", name, panel)
        check:SetWidth(300)
        check:SetHeight(20)
        check:SetPoint("TOPLEFT", panel, "TOPLEFT", 14, y)
        check:SetFrameLevel(panel:GetFrameLevel() + 5)
        check:EnableMouse(true)
        check:RegisterForClicks("LeftButtonUp")

        local square = check:CreateTexture(nil, "BACKGROUND")
        square:SetTexture("Interface\\Buttons\\WHITE8X8")
        square:SetVertexColor(0.02, 0.02, 0.02, 1)
        square:SetWidth(17)
        square:SetHeight(17)
        square:SetPoint("LEFT", check, "LEFT", 0, 0)

        local function edge(width, height, point, relativePoint, x, y)
            local edge = check:CreateTexture(nil, "BORDER")
            edge:SetTexture("Interface\\Buttons\\WHITE8X8")
            edge:SetVertexColor(0.4, 0.4, 0.38, 1)
            edge:SetWidth(width)
            edge:SetHeight(height)
            edge:SetPoint(point, square, relativePoint, x, y)
            return edge
        end
        edge(17, 1, "TOP", "TOP", 0, 0)
        edge(17, 1, "BOTTOM", "BOTTOM", 0, 0)
        edge(1, 17, "LEFT", "LEFT", 0, 0)
        edge(1, 17, "RIGHT", "RIGHT", 0, 0)

        local tick = check:CreateTexture(nil, "OVERLAY")
        tick:SetTexture("Interface\\Buttons\\UI-CheckBox-Check")
        tick:SetWidth(20)
        tick:SetHeight(20)
        tick:SetPoint("CENTER", square, "CENTER", 0, 0)

        local text = check:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        text:SetTextColor(1, 0.83, 0.26)
        text:SetPoint("LEFT", square, "RIGHT", 8, 0)
        text:SetText(label)

        local function refreshVisual()
            if check:GetChecked() then
                tick:Show()
            else
                tick:Hide()
            end
        end
        check.RefreshVisual = refreshVisual
        check:SetScript("OnClick", function(self)
            WildTraceDB[key] = self:GetChecked() and true or false
            self.RefreshVisual()
            WT.RefreshMapMarkers()
        end)
        WT.MapOptionChecks = WT.MapOptionChecks or {}
        WT.MapOptionChecks[key] = check
        refreshVisual()
        return check
    end

    addCheckbox("WT_MapOptionIcons", "Mostrar iconos de criaturas", -40, "showIcons")
    addCheckbox("WT_MapOptionPendingHunt", "Mostrar criaturas pendientes de caza", -66, "showPendingHunt")
    addCheckbox("WT_MapOptionHideHunted", "Ocultar criaturas ya cazadas", -92, "hideHunted")

    WT.MapOptionsFrame = panel
    panel:SetPoint("TOPRIGHT", button, "BOTTOMRIGHT", 0, -3)
    panel._leftWasDown = false
    panel._rightWasDown = false
    panel:SetScript("OnShow", function(self)
        self._leftWasDown = IsMouseButtonDown and IsMouseButtonDown("LeftButton") or false
        self._rightWasDown = IsMouseButtonDown and IsMouseButtonDown("RightButton") or false
        WT.UpdateMapOptionChecks()
    end)
    panel:SetScript("OnUpdate", function(self)
        local leftDown = IsMouseButtonDown and IsMouseButtonDown("LeftButton") or false
        local rightDown = IsMouseButtonDown and IsMouseButtonDown("RightButton") or false
        local newClick = (leftDown and not self._leftWasDown) or (rightDown and not self._rightWasDown)
        self._leftWasDown = leftDown
        self._rightWasDown = rightDown
        if newClick then
            local inPanel = isMouseWithinFrameTree(self)
            local inButton = isMouseWithinFrameTree(WT.MapOptionsButton)
            if not inPanel and not inButton then self:Hide() end
        end
    end)

    button:SetScript("OnClick", function()
        if IsControlKeyDown and IsControlKeyDown() then
            panel:Hide()
            if not WT.MainWindowReady or not WT.MainFrame then
                WT.Print("la ventana principal no está disponible. Revisa los errores Lua.")
                return
            end
            WT.MainFrame:Show()
            if WT.SelectPlayerZone then WT.SelectPlayerZone() end
            if WT.RefreshList then WT.RefreshList() end
            return
        end
        if panel:IsShown() then panel:Hide() else panel:Show() end
    end)
    button:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
        GameTooltip:AddLine("WildTrace v" .. tostring(WT.version), 1.0, 0.82, 0.0)
        GameTooltip:AddLine("Filtros de WildTrace", 1.0, 1.0, 1.0)
        GameTooltip:AddLine("Clic: abrir/cerrar filtros", 0.84, 0.84, 0.84)
        GameTooltip:AddLine("Ctrl + clic: abrir registro", 0.84, 0.84, 0.84)
        GameTooltip:Show()
    end)
    button:SetScript("OnLeave", function() GameTooltip:Hide() end)

    panel:Hide()
    WT.UpdateMapOptionChecks()
    WT.PositionMapOptionsButton()
end

function WT.UpdateMapOptionChecks()
    if not WT.MapOptionChecks then return end
    for key, check in pairs(WT.MapOptionChecks) do
        check:SetChecked(WildTraceDB[key] and true or false)
        if check.RefreshVisual then check.RefreshVisual() end
    end
end

function WT.InstallMapHooks()
    if WT.MapHooksInstalled then return end
    WT.MapHooksInstalled = true
    if WorldMapFrame and WorldMapFrame.HookScript then
        WorldMapFrame:HookScript("OnShow", function()
            WT.PositionMapOptionsButton()
            WT.RefreshMapMarkers()
        end)
        WorldMapFrame:HookScript("OnHide", function()
            if WT.MapOptionsFrame then WT.MapOptionsFrame:Hide() end
            if WT.ContextMenu then WT.ContextMenu:Hide() end
        end)
    end
    if WorldMapButton and WorldMapButton.HookScript then
        WorldMapButton:HookScript("OnSizeChanged", function() WT.RefreshMapMarkers() end)
    end
    if hooksecurefunc and WorldMapFrame_Update then
        hooksecurefunc("WorldMapFrame_Update", function() WT.RefreshMapMarkers() end)
    end
end
