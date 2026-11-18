local WT = WildTrace

local function positiveID(value)
    local n = tonumber(value)
    if n and n > 0 and n == math.floor(n) then return n end
    return nil
end

function WT.GetCreatureNPCID(creature)
    if not creature then return nil end
    local explicit = positiveID(creature.npcID) or positiveID(creature.creatureID)
    if explicit then return explicit end
    if type(creature.id) == "number" then return positiveID(creature.id) end
    if type(creature.id) == "string" then
        local encoded = string.match(creature.id, "^NPC%-(%d+)$")
        if encoded then return positiveID(encoded) end
        return nil
    end
    return nil
end

local function applyRotation(model, angle)
    if model.SetRotation then
        model:SetRotation(angle)
    elseif model.SetFacing then
        model:SetFacing(angle)
    end
end

local function setRotation(angle)
    if not WT.DetailModelNPCID or not WT.DetailModel3D then return end
    WT.DetailModelRotation = angle % (math.pi * 2)
    applyRotation(WT.DetailModel3D, WT.DetailModelRotation)
end

local function setZoom(scale)
    if not WT.DetailModelNPCID or not WT.DetailModel3D then return end
    if not WT.DetailModel3D.SetModelScale then return end
    WT.DetailModelZoom = math.max(0.15, math.min(4, scale))
    WT.DetailModel3D:SetModelScale(WT.DetailModelZoom)
end

local function showPlaceholder(heading, description)
    WT.DetailModel3D:Hide()
    WT.DetailModelNPCID = nil
    WT.DetailModelLockedIcon:Show()
    WT.DetailModelHeading:SetText(heading)
    WT.DetailModelDescription:SetText(description)
    WT.DetailModelMessage:Show()
end

local function showSelection(creature)
    if not WT.DetailModelContainer then return end
    WT.DetailModelSelectedCreature = creature
    WT.DetailModelDragging = false
    WT.DetailModelCursorX = nil

    if not creature then
        WT.DetailModelKey = nil
        WT.DetailModel3D:Hide()
        WT.DetailModelMessage:Hide()
        WT.DetailModelNPCID = nil
        return
    end

    local npcID = WT.GetCreatureNPCID(creature)
    local hunted = WT.GetCreatureStatus(creature.id).hunted
    if not hunted then
        WT.DetailModelKey = "bloqueado:" .. tostring(creature.id)
        showPlaceholder("Modelo 3D bloqueado", "Caza esta criatura para desbloquear su modelo 3D.")
        return
    end

    local available = npcID and WT.CheckModelCache and WT.CheckModelCache(npcID)
    if not available then
        WT.DetailModelKey = "pendiente:" .. tostring(creature.id)
        showPlaceholder("Modelo 3D no disponible", "La apariencia de esta criatura se mostrará cuando el cliente disponga de ella.")
        return
    end

    local key = "npc:" .. npcID
    if WT.DetailModelKey == key and WT.DetailModelNPCID == npcID and WT.DetailModel3D:IsShown() then
        WT.DetailModelMessage:Hide()
        return
    end

    local model = WT.DetailModel3D
    WT.DetailModelMessage:Hide()
    WT.DetailModelRotation = 0
    WT.DetailModelZoom = 1
    if model.ClearModel then model:ClearModel() end
    model:Show()
    local ok, err = pcall(function()
        model:SetCreature(npcID)
        if model.SetCamera then model:SetCamera(1) end
        if model.SetModelScale then model:SetModelScale(1) end
        if model.SetPosition then model:SetPosition(0, 0, 0) end
        applyRotation(model, 0)
    end)
    if ok then
        WT.DetailModelNPCID = npcID
        WT.DetailModelKey = key
    else
        WT.DetailModelKey = nil
        showPlaceholder("Modelo 3D no disponible", "La apariencia de esta criatura no se pudo cargar.")
    end
end

function WT.CreateCreatureModelPreview(container)
    WT.DetailModelContainer = container
    WT.DetailModelNPCID = nil
    WT.DetailModelRotation = 0
    WT.DetailModelZoom = 1
    WT.DetailModelDragging = false

    local model = CreateFrame("PlayerModel", nil, container)
    model:SetPoint("TOPLEFT", container, "TOPLEFT", 6, -5)
    model:SetPoint("BOTTOMRIGHT", container, "BOTTOMRIGHT", -6, 25)
    model:EnableMouse(false)
    model:Hide()
    WT.DetailModel3D = model

    local message = CreateFrame("Frame", nil, container)
    message:SetAllPoints(container)
    message:EnableMouse(false)
    WT.DetailModelMessage = message

    local icon = message:CreateTexture(nil, "ARTWORK")
    icon:SetTexture("Interface\\AddOns\\WildTrace\\Textures\\ModelViewer\\CurtainClosed.tga")
    icon:SetWidth(118)
    icon:SetHeight(118)
    icon:SetPoint("CENTER", message, "CENTER", 0, 70)
    WT.DetailModelLockedIcon = icon

    local heading = message:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    heading:SetPoint("TOP", icon, "BOTTOM", 0, -12)
    heading:SetWidth(330)
    heading:SetJustifyH("CENTER")
    heading:SetTextColor(0.95, 0.77, 0.35)
    WT.DetailModelHeading = heading

    local description = message:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    description:SetPoint("TOP", heading, "BOTTOM", 0, -10)
    description:SetWidth(340)
    description:SetJustifyH("CENTER")
    description:SetTextColor(0.85, 0.83, 0.77)
    WT.DetailModelDescription = description
    message:Hide()

    local interaction = CreateFrame("Frame", nil, container)
    interaction:SetPoint("TOPLEFT", container, "TOPLEFT", 6, -5)
    interaction:SetPoint("BOTTOMRIGHT", container, "BOTTOMRIGHT", -6, 25)
    interaction:EnableMouse(true)
    interaction:EnableMouseWheel(true)
    WT.DetailModelInteraction = interaction

    interaction:SetScript("OnMouseDown", function(self, button)
        if button ~= "LeftButton" or not WT.DetailModelNPCID then return end
        WT.DetailModelDragging = true
        WT.DetailModelCursorX = GetCursorPosition()
    end)
    interaction:SetScript("OnMouseUp", function(self, button)
        if button == "LeftButton" then
            WT.DetailModelDragging = false
            WT.DetailModelCursorX = nil
        end
    end)
    interaction:SetScript("OnUpdate", function(self, elapsed)
        if not WT.DetailModelDragging or not WT.DetailModelNPCID then return end
        if IsMouseButtonDown and not IsMouseButtonDown("LeftButton") then
            WT.DetailModelDragging = false
            WT.DetailModelCursorX = nil
            return
        end
        local x = GetCursorPosition()
        if WT.DetailModelCursorX then
            local diff = x - WT.DetailModelCursorX
            if diff ~= 0 then setRotation((WT.DetailModelRotation or 0) + diff * 0.012) end
        end
        WT.DetailModelCursorX = x
    end)
    interaction:SetScript("OnMouseWheel", function(self, delta)
        if not WT.DetailModelNPCID then return end
        if delta > 0 then
            setZoom((WT.DetailModelZoom or 1) * 1.18)
        elseif delta < 0 then
            setZoom((WT.DetailModelZoom or 1) / 1.18)
        end
    end)
    interaction:SetScript("OnHide", function(self)
        WT.DetailModelDragging = false
        WT.DetailModelCursorX = nil
    end)
    container:SetScript("OnShow", function(self)
        if WT.DetailModelSelectedCreature then showSelection(WT.DetailModelSelectedCreature) end
    end)
end

function WT.RefreshCreatureModelPreview(creature)
    showSelection(creature)
end
