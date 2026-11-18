local WT = WildTrace

function WT.CreateMinimapButton()
    if WT.MinimapButton or not Minimap then return end
    local button = CreateFrame("Button", "WT_MinimapButton", Minimap)
    button:SetWidth(32)
    button:SetHeight(32)
    button:SetFrameStrata("MEDIUM")
    button:SetPoint("TOPLEFT", Minimap, "TOPLEFT", -4, -4)
    button:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")

    local icon = button:CreateTexture(nil, "BACKGROUND")
    icon:SetTexture("Interface\\AddOns\\WildTrace\\Textures\\Brand\\LogoButton.tga")
    icon:SetWidth(25)
    icon:SetHeight(25)
    icon:SetPoint("CENTER", button, "CENTER", 0, 0)

    local border = button:CreateTexture(nil, "OVERLAY")
    border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
    border:SetAllPoints(button)

    button:SetScript("OnClick", function()
        if not WT.MainWindowReady or not WT.MainFrame then
            WT.Print("la ventana principal no está disponible. Revisa los errores Lua.")
            return
        end
        if WT.MainFrame:IsShown() then
            WT.MainFrame:Hide()
        else
            WT.MainFrame:Show()
            if WT.RefreshList then WT.RefreshList() end
        end
    end)
    button:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_LEFT")
        GameTooltip:AddLine("WildTrace v" .. WT.version, 1.0, 0.82, 0.0)
        GameTooltip:AddLine("Clic para abrir/cerrar el registro", 1.0, 1.0, 1.0)
        GameTooltip:Show()
    end)
    button:SetScript("OnLeave", function() GameTooltip:Hide() end)
    WT.MinimapButton = button
end
