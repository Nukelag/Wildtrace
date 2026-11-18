local WT = WildTrace

local TEX = "Interface\\AddOns\\WildTrace\\Textures\\"
local WHITE = "Interface\\Buttons\\WHITE8X8"

local function createText(parent, text, size, layer)
    local fs = parent:CreateFontString(nil, layer or "OVERLAY", "GameFontNormal")
    fs:SetFont("Fonts\\FRIZQT__.TTF", size or 12, "")
    fs:SetShadowColor(0, 0, 0, 0.92)
    fs:SetShadowOffset(1, -1)
    fs:SetText(text or "")
    return fs
end

local function addLine(parent, text, size, x, y, width)
    local fs = createText(parent, text, size)
    fs:SetPoint("TOPLEFT", parent, "TOPLEFT", x, y)
    if width then fs:SetWidth(width) fs:SetJustifyH("LEFT") end
    return fs
end

local function createPanel(parent, x, y, width, height, r, g, b, gold)
    local f = CreateFrame("Frame", nil, parent)
    f:SetWidth(width)
    f:SetHeight(height)
    f:SetPoint("TOPLEFT", parent, "TOPLEFT", x, y)
    f:SetBackdrop({
        bgFile = WHITE,
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        edgeSize = 16,
        insets = {left = 4, right = 4, top = 4, bottom = 4},
    })
    f:SetBackdropColor(r, g, b, 1)
    if gold then f:SetBackdropBorderColor(0.67, 0.49, 0.19, 1)
    else f:SetBackdropBorderColor(0.37, 0.34, 0.30, 1) end
    return f
end

local function createDropdown(parent, name, x, y, width, getOptions, onSelect)
    local dropdown = CreateFrame("Frame", name, parent, "UIDropDownMenuTemplate")
    dropdown:SetPoint("TOPLEFT", parent, "TOPLEFT", x, y)
    UIDropDownMenu_SetWidth(dropdown, width)
    UIDropDownMenu_Initialize(dropdown, function(self, level)
        for _, option in ipairs(getOptions()) do
            local info = UIDropDownMenu_CreateInfo()
            info.text = option.text
            info.value = option.value
            info.checked = option.value == dropdown.selectedValue
            info.func = function()
                dropdown.selectedValue = option.value
                UIDropDownMenu_SetSelectedValue(dropdown, option.value)
                UIDropDownMenu_SetText(dropdown, option.text)
                onSelect(option.value)
            end
            UIDropDownMenu_AddButton(info, level)
        end
    end)
    return dropdown
end

local function matchesSearch(creature, query)
    if not query or query == "" then return true end
    query = string.lower(query)
    return string.find(string.lower(creature.name or ""), query, 1, true) ~= nil
        or string.find(string.lower(creature.englishName or ""), query, 1, true) ~= nil
end

local function setCreaturePortrait(texture, creature)
    texture:SetTexture(0, 0, 0, 1)

    if creature and creature.id then
        texture:SetTexture(TEX .. "Portraits\\" .. tostring(creature.id) .. ".tga")
    end
end


-- ===============================================================
-- Cabecera metalica de WildTrace.
-- ===============================================================
local JOURNAL_TEXTURES = TEX .. "Journal\\"

local function createJournalFramePiece(frame, file, w, h, u1, u2, v1, v2, horizontal, vertical, layer)
    local piece = frame:CreateTexture(nil, layer or "OVERLAY")
    piece:SetTexture(JOURNAL_TEXTURES .. file)
    piece:SetTexCoord(u1, u2, v1, v2)
    piece:SetWidth(w)
    piece:SetHeight(h)
    if horizontal then piece:SetHorizTile(true) end
    if vertical then piece:SetVertTile(true) end
    return piece
end

local function createJournalFrame(frame)
    local metal = "uiframemetal2x.blp"
    local horizontal = "uiframemetalhorizontal2x.blp"
    local vertical = "uiframemetalvertical2x.blp"

    local tl = frame:CreateTexture(nil, "OVERLAY")
    tl:SetTexture(JOURNAL_TEXTURES .. "CornerClean.tga")
    tl:SetWidth(75)
    tl:SetHeight(75)
    tl:SetPoint("TOPLEFT", frame, "TOPLEFT", -13, 16)

    -- Huella dorada dentro del aro original
local cornerPaw = frame:CreateTexture(nil, "ARTWORK")
cornerPaw:SetTexture(TEX .. "Brand\\CornerPaw.tga")
cornerPaw:SetPoint("CENTER", tl, "CENTER", 0, 0)
cornerPaw:SetWidth(70)
cornerPaw:SetHeight(70)

    local joins = frame:CreateTexture(nil, "OVERLAY")
    joins:SetTexture(JOURNAL_TEXTURES .. "CornerJoin.tga")
    joins:SetWidth(75)
    joins:SetHeight(75)
    joins:SetPoint("TOPLEFT", frame, "TOPLEFT", -13, 16)
    joins:SetDrawLayer("OVERLAY", 1)

    local tr = createJournalFramePiece(frame, metal, 75, 75, 0.298828, 0.591797, 0.00195312, 0.294922)
    tr:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 4, 16)

    local bl = createJournalFramePiece(frame, metal, 32, 32, 0.298828, 0.423828, 0.298828, 0.423828)
    bl:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", -13, -3)

    local br = createJournalFramePiece(frame, metal, 32, 32, 0.427734, 0.552734, 0.298828, 0.423828)
    br:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 4, -3)

    local top = createJournalFramePiece(frame, horizontal, 32, 75, 0, 1, 0.00390625, 0.589844, true)
    top:SetPoint("TOPLEFT", tl, "TOPRIGHT", -4, 0)
    top:SetPoint("TOPRIGHT", tr, "TOPLEFT", 4, 0)

    local bottom = createJournalFramePiece(frame, horizontal, 16, 32, 0, 0.5, 0.597656, 0.847656, true)
    bottom:SetPoint("BOTTOMLEFT", bl, "BOTTOMRIGHT", 0, 0)
    bottom:SetPoint("BOTTOMRIGHT", br, "BOTTOMLEFT", 0, 0)

    local left = createJournalFramePiece(frame, vertical, 75, 16, 0.00195312, 0.294922, 0, 1, false, true)
    left:SetPoint("TOPLEFT", tl, "BOTTOMLEFT", 0, 0)
    left:SetPoint("BOTTOMLEFT", bl, "TOPLEFT", 0, 0)

    local right = createJournalFramePiece(frame, vertical, 75, 16, 0.298828, 0.591797, 0, 1, false, true)
    right:SetPoint("TOPRIGHT", tr, "BOTTOMRIGHT", 0, 0)
    right:SetPoint("BOTTOMRIGHT", br, "TOPRIGHT", 0, 0)

    -- No rectangular streak behind the circular upper-left bezel.
end

function WT.CreateMainWindow()
    if WT.MainFrame then return end

    -- Blizzard CollectionsJournal-inspired dimensions. All values are WoW UI
    -- coordinates, not physical pixels; the layout keeps its proportions at
    -- different UI scales and never relies on modern Retail-only templates.
    local journalWidth, journalHeight = 1120, 681
    local rowHeight, rowStep = 55, 57
    local frame = CreateFrame("Frame", "WT_MainFrame", UIParent)
    frame:SetWidth(journalWidth)
    frame:SetHeight(journalHeight)
    frame:SetPoint("CENTER", UIParent, "CENTER", 0, 17)
    frame:SetFrameStrata("DIALOG")
    frame:SetMovable(true)
    frame:SetClampedToScreen(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", function(self) self:StartMoving() end)
    frame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
    -- Textura de roca para el fondo del registro.
    -- Mantenerla separada de los bordes metalicos: no dibujar cuadros negros
    -- sobre el aro dorado. El archivo forma parte del paquete.
    local mountRock = frame:CreateTexture(nil, "BACKGROUND", nil, -7)
    mountRock:SetTexture(JOURNAL_TEXTURES .. "ui-background-rock.blp", "REPEAT", "REPEAT")
    mountRock:SetHorizTile(true)
    mountRock:SetVertTile(true)
    mountRock:SetPoint("TOPLEFT", frame, "TOPLEFT", 2, -22)
    mountRock:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -2, 2)

    -- Banner: recorte panoramico de NUESTRA ilustracion existente.
    -- Dos mitades 1024x256 para compatibilidad con WoW 3.3.5a.
    -- Solo aparece por encima de los paneles, sin deformar la escena completa.
    local bannerL = frame:CreateTexture(nil, "ARTWORK", nil, -8)
    bannerL:SetTexture(JOURNAL_TEXTURES .. "BannerLeft.tga")
    bannerL:SetPoint("TOPLEFT", frame, "TOPLEFT", 2, -26)
    bannerL:SetWidth(558)
    bannerL:SetHeight(85)
    local bannerR = frame:CreateTexture(nil, "ARTWORK", nil, -8)
    bannerR:SetTexture(JOURNAL_TEXTURES .. "BannerRight.tga")
    bannerR:SetPoint("TOPLEFT", bannerL, "TOPRIGHT", 0, 0)
    bannerR:SetWidth(558)
    bannerR:SetHeight(85)

   -- Linea dorada de separacion del banner.
local bannerEdge = frame:CreateTexture(nil, "OVERLAY", nil, 0)
bannerEdge:SetTexture(WHITE)
bannerEdge:SetVertexColor(0.48, 0.38, 0.21, 0.90)
bannerEdge:SetPoint("TOPLEFT", frame, "TOPLEFT", 2, -111)
bannerEdge:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -2, -111)
bannerEdge:SetHeight(1)


    if UISpecialFrames then
        local exists = false
        for _, v in ipairs(UISpecialFrames) do
            if v == "WT_MainFrame" then exists = true break end
        end
        if not exists then table.insert(UISpecialFrames, "WT_MainFrame") end
    end

    -- The original dimensions remain exact unless the player's UI viewport is
    -- smaller than the window. The fallback shrinks the whole journal evenly.
    local function fitToScreen(self)
        local width = UIParent:GetWidth() or journalWidth
        local height = UIParent:GetHeight() or journalHeight
        if width < 1 or height < 1 then return end
        local factor = math.min(1, (width-16)/journalWidth, (height-16)/journalHeight)
        self:SetScale(math.max(0.55, factor))
    end
    fitToScreen(frame)

    -- Cabecera metalica del registro.
    createJournalFrame(frame)
    -- Anclajes del titulo del registro.
    local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    title:SetPoint("TOPLEFT", frame, "TOPLEFT", 58, -6)
    title:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -24, -6)
    title:SetJustifyH("CENTER")
    title:SetText("WildTrace - Registro de criaturas")
    title:SetTextColor(1, 0.82, 0.28)
    local close = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
    close:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 1, 3)
    close:SetScript("OnClick", function() frame:Hide() end)

    local left = createPanel(frame, 18, -117, 320, 548, 0.04, 0.04, 0.045, true)
    left:SetBackdropColor(0, 0, 0, 0)
    left:SetBackdropBorderColor(0.49, 0.41, 0.28, 0.90)

    local detail = createPanel(frame, 350, -117, 366, 548, 0.03, 0.03, 0.035, true)
    detail:SetBackdropColor(0.035, 0.031, 0.038, 0.38)
    detail:SetBackdropBorderColor(0.49, 0.41, 0.28, 0.78)
    detail:SetBackdrop(nil)

    -- Fondo panel central
    local detailBg = detail:CreateTexture(nil, "BACKGROUND", nil, 1)
    detailBg:SetTexture(JOURNAL_TEXTURES .. "CenterBackground.tga")
    detailBg:SetPoint("TOPLEFT", detail, "TOPLEFT", 0, 0)
    detailBg:SetPoint("BOTTOMRIGHT", detail, "BOTTOMRIGHT", 0, 0)

    -- Divisor dorado del panel central
local detailDivider = detail:CreateTexture(nil, "ARTWORK")
detailDivider:SetTexture(JOURNAL_TEXTURES .. "GoldDivider.tga")
detailDivider:SetPoint("TOP", detail, "TOP", 0, -170)
detailDivider:SetWidth(320)
detailDivider:SetHeight(20)

    local modelPane = createPanel(frame, 728, -117, 373, 548, 0.03, 0.03, 0.035, true)
    modelPane:SetBackdropColor(0, 0, 0, 0)
    modelPane:SetBackdropBorderColor(0.49, 0.41, 0.28, 0.78)


-- Un mismo marco para los tres paneles
local function applyPanelBorder(panel)
    local path = JOURNAL_TEXTURES .. "PanelBorder.tga"

    local u = 40 / 512
    local v = 48 / 1024
    local w, h = 30, 26

    local function piece(u1, u2, v1, v2)
        local tex = panel:CreateTexture(nil, "OVERLAY", nil, 4)
        tex:SetTexture(path)
        tex:SetTexCoord(u1, u2, v1, v2)
        return tex
    end

    local tl = piece(0, u, 0, v)
    tl:SetPoint("TOPLEFT", panel, "TOPLEFT", 0, 0)
    tl:SetWidth(w)
    tl:SetHeight(h)

    local tr = piece(1-u, 1, 0, v)
    tr:SetPoint("TOPRIGHT", panel, "TOPRIGHT", 0, 0)
    tr:SetWidth(w)
    tr:SetHeight(h)

    local bl = piece(0, u, 1-v, 1)
    bl:SetPoint("BOTTOMLEFT", panel, "BOTTOMLEFT", 0, 0)
    bl:SetWidth(w)
    bl:SetHeight(h)

    local br = piece(1-u, 1, 1-v, 1)
    br:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", 0, 0)
    br:SetWidth(w)
    br:SetHeight(h)

    local top = piece(u, 1-u, 0, v)
    top:SetPoint("TOPLEFT", panel, "TOPLEFT", w, 0)
    top:SetPoint("TOPRIGHT", panel, "TOPRIGHT", -w, 0)
    top:SetHeight(h)

    local bottom = piece(u, 1-u, 1-v, 1)
    bottom:SetPoint("BOTTOMLEFT", panel, "BOTTOMLEFT", w, 0)
    bottom:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", -w, 0)
    bottom:SetHeight(h)

    local l = piece(0, u, v, 1-v)
    l:SetPoint("TOPLEFT", panel, "TOPLEFT", 0, -h)
    l:SetPoint("BOTTOMLEFT", panel, "BOTTOMLEFT", 0, h)
    l:SetWidth(w)

    local r = piece(1-u, 1, v, 1-v)
    r:SetPoint("TOPRIGHT", panel, "TOPRIGHT", 0, -h)
    r:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", 0, h)
    r:SetWidth(w)
end

-- Ocultar los bordes antiguos generados por WoW
left:SetBackdropBorderColor(0, 0, 0, 0)
detail:SetBackdropBorderColor(0, 0, 0, 0)
modelPane:SetBackdropBorderColor(0, 0, 0, 0)

-- Aplicar nuestro marco
applyPanelBorder(left)
applyPanelBorder(detail)
applyPanelBorder(modelPane) 

    -- Filtros nativos dentro del panel izquierdo.
    WT.ContinentDropdown = createDropdown(left, "WT_ContinentDropdown", 20, -12, 248, function()
        return {
            {text=WT.GetContinentDisplayName("Kalimdor"),value="Kalimdor"},
            {text=WT.GetContinentDisplayName("EasternKingdoms"),value="EasternKingdoms"},
            {text=WT.GetContinentDisplayName("Outland"),value="Outland"},
            {text=WT.GetContinentDisplayName("Northrend"),value="Northrend"},
        }
    end, function(value)
        if table.getn(WT.GetZoneKeys(value)) > 0 then
            WT.SetContinent(value)
        else
            WT.Print("todavía no hay zonas cargadas para " .. WT.GetContinentDisplayName(value) .. ".")
            WT.SetContinent("EasternKingdoms")
        end
        WT.RefreshDropdowns()
    end)
    WT.ZoneDropdown = createDropdown(left, "WT_ZoneDropdown", 20, -45, 248, function()
        local options = {}
        for _, key in ipairs(WT.GetZoneKeys(WT.SelectedContinent)) do
            table.insert(options, {text=WT.GetZoneDisplayName(WT.Zones[key]),value=key})
        end
        return options
    end, function(value)
        WT.SetZone(value)
        WT.RefreshDropdowns()
    end)

    WT.ContinentDropdown:Show()
    WT.ZoneDropdown:Show()

    -- Barra de busqueda 
    local searchBar = createPanel(left, 13, -84, 294, 29, 0.049, 0.048, 0.048, false)
    searchBar:SetBackdropBorderColor(0.37, 0.37, 0.36, 1)
   
    WT.SearchEditBox = CreateFrame("EditBox", "WT_SearchEditBox", searchBar)
    WT.SearchEditBox:SetWidth(260)
    WT.SearchEditBox:SetHeight(24)
    WT.SearchEditBox:SetPoint("LEFT", searchBar, "LEFT", 14, 0)
    WT.SearchEditBox:SetFont("Fonts\\FRIZQT__.TTF", 11, "")
    WT.SearchEditBox:SetTextColor(1, 0.94, 0.78)
    WT.SearchEditBox:SetAutoFocus(false)
    WT.SearchEditBox:SetMaxLetters(60)
    local placeholder = createText(searchBar, "Buscar criatura", 11)
    placeholder:SetPoint("LEFT", searchBar, "LEFT", 15, 0)
    placeholder:SetTextColor(0.55, 0.54, 0.52)
    WT.SearchEditBox:SetScript("OnTextChanged", function(self)
        local value = self:GetText() or ""
        WT.SearchText = value
        if value == "" then placeholder:Show() else placeholder:Hide() end
        WT.ListPage = 1
        WT.SelectedCreatureID = nil
        if WT.JournalScroll then WT.JournalScroll:SetVerticalScroll(0) end
        WT.RefreshList()
    end)
    WT.SearchEditBox:SetScript("OnEnterPressed", function(self) self:ClearFocus() end)
    WT.SearchEditBox:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)

    -- Listado de criaturas
    local listFrame = createPanel(left, 13, -127, 294, 377, 0.034, 0.032, 0.032, false)
listFrame:SetBackdropColor(0, 0, 0, 0)
listFrame:SetBackdropBorderColor(0, 0, 0, 0)
    local scroll = CreateFrame("ScrollFrame", "WT_JournalListScroll", listFrame, "UIPanelScrollFrameTemplate")
    scroll:SetPoint("TOPLEFT", listFrame, "TOPLEFT", 5, 0)
    scroll:SetPoint("BOTTOMRIGHT", listFrame, "BOTTOMRIGHT", -24, 7)
    local child = CreateFrame("Frame", nil, scroll)
    child:SetWidth(257)
    child:SetHeight(10*rowStep)
    scroll:SetScrollChild(child)

-- Apariencia del deslizador
local bar = _G[scroll:GetName() .. "ScrollBar"]
bar:SetWidth(12)

-- Fondo oscuro
local track = bar:CreateTexture(nil, "BACKGROUND")
track:SetTexture(WHITE)
track:SetVertexColor(0.08, 0.07, 0.06, 0.9)
track:SetWidth(6)
track:SetPoint("TOP", bar, "TOP", 0, 0)
track:SetPoint("BOTTOM", bar, "BOTTOM", 0, 0)

-- Indicador dorado
local thumb = bar:GetThumbTexture()
thumb:SetTexture("Interface\\Buttons\\UI-ScrollBar-Knob")
thumb:SetTexCoord(0, 1, 0, 1)
thumb:SetVertexColor(0.85, 0.72, 0.48, 1)
thumb:SetWidth(18)
thumb:SetHeight(24)

-- Flechas
local up = _G[bar:GetName() .. "ScrollUpButton"]
local down = _G[bar:GetName() .. "ScrollDownButton"]

up:GetNormalTexture():SetVertexColor(0.75, 0.58, 0.30)
down:GetNormalTexture():SetVertexColor(0.75, 0.58, 0.30)

    scroll:EnableMouseWheel(true)
    scroll:SetScript("OnMouseWheel", function(self, delta)
        local nextValue = self:GetVerticalScroll() - (delta*rowStep)
        self:SetVerticalScroll(math.max(0, math.min(self:GetVerticalScrollRange(), nextValue)))
    end)
    WT.JournalScroll = scroll
    WT.JournalScrollChild = child

    WT.ListRows = {}
    local function createListRow(i)
        local row = CreateFrame("Button", nil, child)
        row:SetWidth(252)
        row:SetHeight(rowHeight)
        row:SetPoint("TOPLEFT", child, "TOPLEFT", 2, -(i-1)*rowStep)
        row:RegisterForClicks("LeftButtonUp", "RightButtonUp")
        row:SetBackdrop({bgFile=WHITE, edgeFile="Interface\\Tooltips\\UI-Tooltip-Border",
            edgeSize=12, insets={left=3,right=3,top=3,bottom=3}})
        row:SetBackdropColor(0.055, 0.055, 0.056, 1)
        row:SetBackdropBorderColor(0.29, 0.29, 0.29, 1)
        row.portrait = row:CreateTexture(nil, "ARTWORK")
        row.portrait:SetPoint("LEFT", row, "LEFT", 6, 0)
        row.portrait:SetWidth(45)
        row.portrait:SetHeight(45)
        row.iconBorder = row:CreateTexture(nil, "OVERLAY")
        row.iconBorder:SetTexture(WHITE)
        row.iconBorder:SetVertexColor(0.60, 0.47, 0.25, 0.8)
        row.iconBorder:SetPoint("TOPLEFT", row.portrait, "TOPLEFT", -1, 1)
        row.iconBorder:SetPoint("BOTTOMRIGHT", row.portrait, "BOTTOMRIGHT", 1, -1)
        row.iconBorder:SetDrawLayer("BACKGROUND", 2)
        row.nameText = createText(row, "", 11)
        row.nameText:SetPoint("TOPLEFT", row, "TOPLEFT", 56, -7)
        row.nameText:SetWidth(188)
        row.nameText:SetJustifyH("LEFT")
        row.nameText:SetWordWrap(false)
        row.levelText = createText(row, "", 9)
        row.levelText:SetPoint("BOTTOMLEFT", row, "BOTTOMLEFT", 56, 8)
        row.levelText:SetWidth(98)
        row.levelText:SetJustifyH("LEFT")
        row.levelText:SetTextColor(0.76, 0.72, 0.63)
        row.statusText = createText(row, "", 9)
        row.statusText:SetPoint("BOTTOMRIGHT", row, "BOTTOMRIGHT", -7, 8)
        row.statusText:SetWidth(55)
        row.statusText:SetJustifyH("RIGHT")
        local listArt = TEX .. "Journal\\SelectionHighlights.blp"

-- Brillo azul al pasar el mouse
row.hoverGlow = row:CreateTexture(nil, "HIGHLIGHT")
row.hoverGlow:SetTexture(listArt)
row.hoverGlow:SetTexCoord(0.00390625, 0.8203125, 0.19140625, 0.37109375)
row.hoverGlow:SetAllPoints(row)
row.hoverGlow:SetAlpha(0.8)

-- Brillo dorado de selección
row.selectGlow = row:CreateTexture(nil, "ARTWORK", nil, 1)
row.selectGlow:SetTexture(listArt)
row.selectGlow:SetTexCoord(0.00390625, 0.8203125, 0.37890625, 0.55859375)
row.selectGlow:SetAllPoints(row)
row.selectGlow:Hide()
    
        row:SetScript("OnClick", function(self, which)
    if not self.creature then return end

    WT.SelectedCreatureID = self.creature.id

    if which == "RightButton" then
        WT.ShowCreatureMenu(self.creature, self)
    end

    WT.RefreshList()
end)
        WT.ListRows[i] = row
end

WT.CreateListRow = createListRow

for i = 1, 10 do
    createListRow(i)
end

    WT.ListInfo = createText(left, "", 10)
WT.ListInfo:SetPoint("BOTTOMLEFT", left, "BOTTOMLEFT", 18, 12)
WT.ListInfo:SetWidth(284)
WT.ListInfo:SetHeight(28)
WT.ListInfo:SetJustifyH("LEFT")
WT.ListInfo:SetJustifyV("TOP")
WT.ListInfo:SetWordWrap(true)
WT.ListInfo:SetTextColor(0.90, 0.83, 0.70)

    -- Ficha (panel central): retrato, nombre, nivel, tipo, descripcion y estado.
    -- Conservamos WT.DetailPortrait oculto como en la version anterior;
    -- el retrato especifico y el sello de cera se definiran en la fase visual.
 local portraitFrame = detail:CreateTexture(nil, "OVERLAY")
portraitFrame:SetTexture(JOURNAL_TEXTURES .. "PortraitFrame.tga")
portraitFrame:SetPoint("TOP", detail, "TOP", 0, -5)
portraitFrame:SetWidth(125)
portraitFrame:SetHeight(125)

-- Foto retrato de criatrua en panel central
WT.DetailPortrait = detail:CreateTexture(nil, "ARTWORK")
WT.DetailPortrait:SetPoint("CENTER", portraitFrame, "CENTER", 0, 3)
WT.DetailPortrait:SetWidth(95)
WT.DetailPortrait:SetHeight(95)
WT.DetailPortrait:SetTexture(0, 0, 0, 1)
    
-- Nombre panel central
    WT.DetailName = createText(detail, "Selecciona una criatura", 22)
WT.DetailName:SetPoint("TOP", portraitFrame, "BOTTOM", 0, 5)
WT.DetailName:SetWidth(320)
WT.DetailName:SetHeight(52)
WT.DetailName:SetJustifyH("CENTER")
WT.DetailName:SetJustifyV("TOP")
WT.DetailName:SetWordWrap(true)
WT.DetailName:SetTextColor(1, 0.79, 0.19)

-- Nivel y rareza
    WT.DetailLevel = createText(detail, "", 13)
WT.DetailLevel:SetPoint("BOTTOM", detailDivider, "TOP", 0, 1)
WT.DetailLevel:SetWidth(320)
WT.DetailLevel:SetJustifyH("CENTER")
WT.DetailLevel:SetTextColor(0.97, 0.96, 0.91)


    WT.DetailBadge = addLine(detail, "", 11, 111, -83, 237)
    WT.DetailBadge:SetTextColor(0.68, 0.91, 0.61)
    WT.DetailBadge:Hide()

WT.DetailType = createText(detail, "", 13)
WT.DetailType:SetPoint("TOP", detailDivider, "BOTTOM", 0, -1)
WT.DetailType:SetWidth(320)
WT.DetailType:SetJustifyH("CENTER")
WT.DetailType:SetWordWrap(true)
WT.DetailType:SetTextColor(0.98, 0.96, 0.93)

    WT.DetailTame = addLine(detail, "", 12, 23, -166, 319)
    WT.DetailTame:SetTextColor(0.85, 0.83, 0.80)
    WT.DetailTame:Hide()

    -- Texto cabecera descripción criatura 
    local notesLabel = addLine(detail, "DESCRIPCIÓN", 12, 23, -222, 315)
    notesLabel:SetTextColor(1, 0.79, 0.21)

    -- Texto descripción criatura
    WT.DetailNotes = createText(detail, "", 13)
WT.DetailNotes:SetPoint("TOP", detail, "TOP", 0, -239)
WT.DetailNotes:SetWidth(320)
WT.DetailNotes:SetHeight(190)
WT.DetailNotes:SetJustifyH("LEFT")
WT.DetailNotes:SetJustifyV("TOP")
WT.DetailNotes:SetWordWrap(true)
WT.DetailNotes:SetTextColor(0.96, 0.90, 0.78)

    -- El estado permanece como texto provisional hasta diseñar el sello de cera.
    WT.DetailStatus = createText(detail, "Aún no conseguida", 12)
    WT.DetailStatus:SetPoint("BOTTOM", detail, "BOTTOM", 0, 20)
    WT.DetailStatus:SetTextColor(0.93, 0.84, 0.74)

    WT.DetailSeal = detail:CreateTexture(nil, "OVERLAY")
WT.DetailSeal:SetTexture(TEX .. "Journal\\HuntedSeal.tga")
WT.DetailSeal:SetWidth(180)
WT.DetailSeal:SetHeight(180)
WT.DetailSeal:SetPoint("BOTTOM", detail, "BOTTOM", 0, 55)
WT.DetailSeal:Hide()

-- Fondo del visor con el telón abierto
local openCurtain = modelPane:CreateTexture(nil, "BACKGROUND")
openCurtain:SetTexture(TEX .. "ModelViewer\\CurtainOpen.tga")
openCurtain:SetPoint("TOPLEFT", modelPane, "TOPLEFT", 3, -3)
openCurtain:SetPoint("BOTTOMRIGHT", modelPane, "BOTTOMRIGHT", -3, 3)

    -- Visor 3D (panel derecho): sin panel negro adicional.
    local preview = CreateFrame("Frame", nil, modelPane)
    preview:SetPoint("TOPLEFT", modelPane, "TOPLEFT", 10, -12)
    preview:SetWidth(353)
    preview:SetHeight(518)
    WT.CreateCreatureModelPreview(preview)
    
    -- Telon cerrado panel derecho
    WT.DetailModelLockedIcon:SetParent(modelPane)
WT.DetailModelLockedIcon:SetDrawLayer("ARTWORK")

WT.DetailModelMessage:HookScript("OnShow", function()
    WT.DetailModelLockedIcon:Show()
end)

WT.DetailModelMessage:HookScript("OnHide", function()
    WT.DetailModelLockedIcon:Hide()
end)

WT.DetailModelLockedIcon:Hide()

WT.DetailModelLockedIcon:ClearAllPoints()
WT.DetailModelLockedIcon:SetPoint("TOPLEFT", modelPane, "TOPLEFT", 3, -3)
WT.DetailModelLockedIcon:SetPoint("BOTTOMRIGHT", modelPane, "BOTTOMRIGHT", -3, 3)

WT.DetailModelHeading:ClearAllPoints()
WT.DetailModelHeading:SetPoint("BOTTOM", preview, "BOTTOM", 0, 77)

WT.DetailModelDescription:ClearAllPoints()
WT.DetailModelDescription:SetPoint("BOTTOM", preview, "BOTTOM", 0, 45)
WT.DetailModelDescription:SetWidth(310)
WT.DetailModelHeading:SetAlpha(0)
WT.DetailModelDescription:SetAlpha(0)

    frame:SetScript("OnShow", function(self)
        fitToScreen(self)
        if WT.SelectPlayerZone then WT.SelectPlayerZone() end
        WT.RefreshList()
    end)
    WT.MainFrame = frame
    WT.RefreshDropdowns()
    WT.MainWindowReady = true
    frame:Hide()
end

function WT.RefreshDropdowns()
    if not WT.ContinentDropdown or not WT.ZoneDropdown then return end
    WT.ContinentDropdown.selectedValue=WT.SelectedContinent
    UIDropDownMenu_SetSelectedValue(WT.ContinentDropdown,WT.SelectedContinent)
    UIDropDownMenu_SetText(WT.ContinentDropdown,WT.GetContinentDisplayName(WT.SelectedContinent))
    WT.ZoneDropdown.selectedValue=WT.SelectedZone
    UIDropDownMenu_Initialize(WT.ZoneDropdown,function(self,level)
        for _,key in ipairs(WT.GetZoneKeys(WT.SelectedContinent)) do
            local info=UIDropDownMenu_CreateInfo()
            info.text=WT.GetZoneDisplayName(WT.Zones[key])
            info.value=key
            info.checked=(key==WT.SelectedZone)
            info.func=function()
                WT.SelectedZone=key
                UIDropDownMenu_SetSelectedValue(WT.ZoneDropdown,key)
                UIDropDownMenu_SetText(WT.ZoneDropdown,WT.GetZoneDisplayName(WT.Zones[key]))
                WT.ListPage=1
                WT.SelectedCreatureID=nil
                if WT.JournalScroll then WT.JournalScroll:SetVerticalScroll(0) end
                WT.RefreshList()
            end
            UIDropDownMenu_AddButton(info,level)
        end
    end)
    if WT.SelectedZone and WT.Zones[WT.SelectedZone] then
        UIDropDownMenu_SetSelectedValue(WT.ZoneDropdown,WT.SelectedZone)
        UIDropDownMenu_SetText(WT.ZoneDropdown,WT.GetZoneDisplayName(WT.Zones[WT.SelectedZone]))
    else
        UIDropDownMenu_SetText(WT.ZoneDropdown,"Sin zonas")
    end
end

function WT.RefreshDetail(creature)
    if not WT.DetailName then return end
    if not creature then
        WT.DetailName:SetText("Sin criaturas para mostrar")
        WT.DetailLevel:SetText("")
        WT.DetailType:SetText("")
        WT.DetailTame:SetText("")
        WT.DetailNotes:SetText("Elige otra zona o cambia la búsqueda.")
        setCreaturePortrait(WT.DetailPortrait, nil)
        WT.RefreshCreatureModelPreview(nil)
        WT.DetailBadge:SetText("")
        WT.DetailStatus:Hide()
        WT.DetailSeal:Hide()
        return
    end
    
    local status=WT.GetCreatureStatus(creature.id)
setCreaturePortrait(WT.DetailPortrait, creature)
WT.RefreshCreatureModelPreview(creature)
WT.DetailModelHeading:SetAlpha(status.hunted and 1 or 0)
WT.DetailModelDescription:SetAlpha(status.hunted and 1 or 0)


    WT.DetailName:SetText(WT.GetCreatureDisplayName(creature))
    WT.DetailLevel:SetText("Nivel " .. tostring(creature.level or "?") .. "  |  " .. tostring(creature.kind or "Sin clasificación"))
    local kind=tostring(creature.creatureType or "Desconocido")
    if creature.creatureSubtype then kind=kind .. " - " .. creature.creatureSubtype end
    WT.DetailType:SetText("|cFFFFC936Tipo:|r  " .. kind)
    if creature.tameable then
        local family=creature.petFamily or creature.creatureSubtype or "No indicada"
        WT.DetailTame:SetText((creature.exotic and "Domesticable (exótica)" or "Domesticable") .. "  ·  " .. family)
        WT.DetailTame:SetTextColor(0.66,0.96,0.64)
    else
        WT.DetailTame:SetText("No domesticable")
        WT.DetailTame:SetTextColor(0.91,0.86,0.79)
    end
    WT.DetailNotes:SetText(creature.notes or creature.description or "Sin descripción disponible.")
    if status.hunted then
    WT.DetailBadge:SetText("Cazada")
    WT.DetailBadge:SetTextColor(0.60, 0.93, 0.51)
    WT.DetailSeal:Show()
    WT.DetailStatus:Hide()
else
    WT.DetailBadge:SetText("Pendiente de caza")
    WT.DetailBadge:SetTextColor(0.86, 0.76, 0.56)
    WT.DetailStatus:SetText("Aún no conseguida")
    WT.DetailStatus:SetTextColor(0.93, 0.84, 0.74)
    WT.DetailSeal:Hide()
    WT.DetailStatus:Show()
end
end

function WT.RefreshList()
    if not WT.ListRows then return end
    local zone=WT.Zones[WT.SelectedZone]
    local all=zone and zone.creatures or {}
    local list={}
    for _,creature in ipairs(all) do
        if matchesSearch(creature,WT.SearchText) then table.insert(list,creature) end
    end
    local selected = nil

if WT.SelectedCreatureID then
    for _, creature in ipairs(list) do
        if creature.id == WT.SelectedCreatureID then
            selected = creature
            break
        end
    end
end

if not selected then
    selected = list[1]
    WT.SelectedCreatureID = selected and selected.id or nil
end

-- Crear filas adicionales cuando sean necesarias
for i = #WT.ListRows + 1, #list do
    WT.CreateListRow(i)
end
    local shown=0
    for i,row in ipairs(WT.ListRows) do
        local creature=list[i]
        row.creature=creature
        if creature then
            shown=shown+1
            local hunted=WT.GetCreatureStatus(creature.id).hunted
            row.nameText:SetText(WT.GetCreatureDisplayName(creature))
            setCreaturePortrait(row.portrait, creature)
            row.levelText:SetText("Nv. " .. tostring(creature.level or "?") .. " · " .. tostring(creature.kind or ""))
            row.statusText:SetText(hunted and "Cazada" or "")
            row.statusText:SetTextColor(0.50,0.86,0.47)
            if selected==creature then
                row:SetBackdropColor(0.30,0.20,0.064,1)
                row:SetBackdropBorderColor(1,0.81,0.30,1)
                row.nameText:SetTextColor(1,0.80,0.22)
                row.portrait:SetDesaturated(false)
                row.portrait:SetAlpha(1)
                row.selectGlow:Show()
row.hoverGlow:SetAlpha(0)
            else
                row:SetBackdropColor(0.065,0.065,0.068,1)
                row:SetBackdropBorderColor(0.31,0.29,0.27,1)
                row.nameText:SetTextColor(0.68,0.67,0.66)
                row.portrait:SetDesaturated(true)
                row.portrait:SetAlpha(0.67)
                row.selectGlow:Hide()
row.hoverGlow:SetAlpha(0.8)
            end
            row:Show()
        else
            row:Hide()
        end
    end
    if WT.JournalScrollChild then
        WT.JournalScrollChild:SetHeight(math.max(10, #list * 57))
    end
    WT.RefreshDetail(selected)
   
    if zone then
        WT.ListInfo:SetText(
    WT.GetZoneDisplayName(zone) .. "  ·  " ..
    tostring(table.getn(list)) .. " criaturas\n" ..
    "Clic izquierdo: ficha  |  Derecho: opciones"
)
    else
        WT.ListInfo:SetText("No hay datos cargados para esta zona.")
    end
end

local function isMouseWithinFrameTree(frame)
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

local function setContextActionText(button, text)
    if not button then return end
    if button.currentText == text then
        -- Re-assert the label in case another addon skin refreshed the template text.
        if button.label then button.label:SetText(text) end
        return
    end
    button.currentText = text
    -- Use our own FontString instead of relying on a skinned template's
    -- ButtonText region; this makes live label changes explicit on 3.3.5a.
    if button.label then
        button.label:SetText(text)
    else
        button:SetText(text)
        local label = button:GetFontString()
        if label then label:SetText(text) end
    end
end

local function createContextMenu()
    local menu = CreateFrame("Frame", "WT_CreatureContextMenu", UIParent)
    menu:SetWidth(250)
    menu:SetHeight(112)
    menu:SetFrameStrata("TOOLTIP")
    menu:EnableMouse(true)
    menu:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8X8",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true, tileSize = 8, edgeSize = 24,
        insets = { left = 7, right = 7, top = 7, bottom = 7 },
    })
    menu:SetBackdropColor(0.025, 0.022, 0.018, 1.0)
    menu.title = createText(menu, "", 12)
    menu.title:SetPoint("TOPLEFT", menu, "TOPLEFT", 14, -13)
    menu.title:SetWidth(220)
    menu.title:SetJustifyH("LEFT")

    local function addAction(text, y, callback)
        local button = CreateFrame("Button", nil, menu, "UIPanelButtonTemplate")
        button:SetWidth(220)
        button:SetHeight(24)
        button:SetPoint("TOPLEFT", menu, "TOPLEFT", 14, y)
        -- Blank the template label and use a dedicated font string that we
        -- control directly when the action changes from Mark to Remove mark.
        button:SetText("")
        button.label = createText(button, text, 11, "OVERLAY")
        button.label:SetPoint("CENTER", button, "CENTER", 0, 1)
        button.label:SetWidth(210)
        button.label:SetJustifyH("CENTER")
        button.currentText = text
        button:SetScript("OnClick", callback)
        return button
    end

    menu.huntButton = addAction("Marcar como cazada", -42, function()
        if menu.creature then
            WT.ToggleCreatureHunted(menu.creature.id)
            WT.UpdateContextMenu(true)
        end
    end)

    menu._leftWasDown = false
    menu._rightWasDown = false
    menu._refreshElapsed = 0
    menu:SetScript("OnShow", function(self)
        self._leftWasDown = IsMouseButtonDown and IsMouseButtonDown("LeftButton") or false
        self._rightWasDown = IsMouseButtonDown and IsMouseButtonDown("RightButton") or false
        self._refreshElapsed = 0
        WT.UpdateContextMenu(true)
    end)
    menu:SetScript("OnUpdate", function(self, elapsed)
        -- Keep visible labels synchronized even if another code path changed a flag.
        self._refreshElapsed = self._refreshElapsed + (elapsed or 0)
        if self._refreshElapsed >= 0.10 then
            self._refreshElapsed = 0
            WT.UpdateContextMenu()
        end

        local leftDown = IsMouseButtonDown and IsMouseButtonDown("LeftButton") or false
        local rightDown = IsMouseButtonDown and IsMouseButtonDown("RightButton") or false
        local newClick = (leftDown and not self._leftWasDown) or (rightDown and not self._rightWasDown)
        self._leftWasDown = leftDown
        self._rightWasDown = rightDown
        if newClick and not isMouseWithinFrameTree(self) then self:Hide() end
    end)
    return menu
end

function WT.UpdateContextMenu(force)
    local menu = WT.ContextMenu
    if not menu or not menu.creature then return end
    local status = WT.GetCreatureStatus(menu.creature.id)
    local huntText = status.hunted and "Quitar marca de cazada" or "Marcar como cazada"
    setContextActionText(menu.huntButton, huntText)
    -- 2-line and 3-line titles must leave the action button below the text.
    local titleHeight = menu.title:GetStringHeight() or 30
    titleHeight = math.max(26, titleHeight)
    local buttonTop = 14 + titleHeight + 9
    menu.huntButton:ClearAllPoints()
    menu.huntButton:SetPoint("TOPLEFT", menu, "TOPLEFT", 14, -buttonTop)
    menu:SetHeight(buttonTop + 24 + 14)
end

function WT.ShowCreatureMenu(creature, anchor)
    if not creature then return end
    if not WT.ContextMenu then WT.ContextMenu = createContextMenu() end
    local menu = WT.ContextMenu
    menu.creature = creature
    local creatureType = creature.creatureType or "Tipo desconocido"
    if creature.creatureSubtype then creatureType = creatureType .. " (" .. creature.creatureSubtype .. ")" end
    menu.title:SetText(WT.GetCreatureDisplayName(creature) .. "\n" .. WT.GetZoneDisplayName(WT.Zones[creature.zoneKey]) .. " - Nv. " .. tostring(creature.level or "?") .. " - " .. creatureType)
    menu:ClearAllPoints()
    if anchor then menu:SetPoint("TOPLEFT", anchor, "BOTTOMRIGHT", 4, -4)
    else menu:SetPoint("CENTER", UIParent, "CENTER", 0, 0) end
    menu._leftWasDown = IsMouseButtonDown and IsMouseButtonDown("LeftButton") or false
    menu._rightWasDown = IsMouseButtonDown and IsMouseButtonDown("RightButton") or false
    menu:Show()
    WT.UpdateContextMenu(true)
end

-- Seleccionar la zona REAL del personaje al abrir el diario, no la zona
-- que tenga seleccionada el mapa del mundo. Los nombres cambian segun
-- idioma y pueden contener articulos (ej. "Las Mil Agujas").
local ZONE_ALIASES = {
    DunMorogh = { "Dun Morogh" },
    LochModan = { "Loch Modan" },
    Wetlands = { "Wetlands", "Los Humedales" },
    ArathiHighlands = { "Arathi Highlands" },
    HillsbradFoothills = { "Hillsbrad Foothills" },
    AlteracMountains = { "Alterac Mountains" },
    ThousandNeedles = { "Thousand Needles" },
}

local function normalizeZoneName(value)
    if not value or value == "" then return "" end
    -- WoW 3.3.5a usa Lua 5.1; string.lower no convierte mayusculas UTF-8.
    -- Sustituir tildes ANTES de normalizar para comparar esES/esMX/enUS.
    local accents = {
        ["Á"]="a", ["À"]="a", ["Â"]="a", ["Ä"]="a", ["á"]="a", ["à"]="a", ["â"]="a", ["ä"]="a",
        ["É"]="e", ["È"]="e", ["Ê"]="e", ["Ë"]="e", ["é"]="e", ["è"]="e", ["ê"]="e", ["ë"]="e",
        ["Í"]="i", ["Ì"]="i", ["Ï"]="i", ["í"]="i", ["ì"]="i", ["ï"]="i",
        ["Ó"]="o", ["Ò"]="o", ["Ô"]="o", ["Ö"]="o", ["ó"]="o", ["ò"]="o", ["ô"]="o", ["ö"]="o",
        ["Ú"]="u", ["Ù"]="u", ["Ü"]="u", ["ú"]="u", ["ù"]="u", ["ü"]="u",
        ["Ñ"]="n", ["ñ"]="n",
    }
    value = string.gsub(value, "[\194-\244][\128-\191]+", function(char)
        return accents[char] or char
    end)
    value = string.lower(value)
    value = string.gsub(value, "^%s+", "")
    value = string.gsub(value, "^las%s+", "")
    value = string.gsub(value, "^los%s+", "")
    value = string.gsub(value, "^el%s+", "")
    value = string.gsub(value, "^la%s+", "")
    return string.gsub(value, "[%s%p]+", "")
end

local function zoneMatches(zoneKey, zone, wantedName)
    local names = { zone.name, zone.mapFile, zone.key }
    if zone.displayName then table.insert(names, zone.displayName) end
    if WT.GetZoneDisplayName then
        local localized = WT.GetZoneDisplayName(zone)
        if localized then table.insert(names, localized) end
    end
    for _, alias in ipairs(ZONE_ALIASES[zoneKey] or {}) do
        table.insert(names, alias)
    end
    for _, candidate in ipairs(names) do
        if normalizeZoneName(candidate) == wantedName then return true end
    end
    return false
end

function WT.GetPlayerZoneKey()
    local names = {}
    if GetRealZoneText then table.insert(names, GetRealZoneText() or "") end
    if GetZoneText then table.insert(names, GetZoneText() or "") end
    for _, playerName in ipairs(names) do
        local normalized = normalizeZoneName(playerName)
        if normalized ~= "" then
            for key, zone in pairs(WT.Zones) do
                if zoneMatches(key, zone, normalized) then return key end
            end
        end
    end
    return nil
end

function WT.SelectPlayerZone()
    local names = {}
    if GetZoneText then table.insert(names, GetZoneText() or "") end
    if GetRealZoneText then table.insert(names, GetRealZoneText() or "") end
    for _, playerName in ipairs(names) do
        local normalized = normalizeZoneName(playerName)
        if normalized ~= "" then
            for key, zone in pairs(WT.Zones) do
                if zoneMatches(key, zone, normalized) then
                    if WT.SelectedZone ~= key or WT.SelectedContinent ~= zone.continent then
                        WT.SelectedContinent = zone.continent
                        WT.SelectedZone = key
                        WT.SelectedCreatureID = nil
                        WT.ListPage = 1
                        if WT.JournalScroll then WT.JournalScroll:SetVerticalScroll(0) end
                    end
                    WT.RefreshDropdowns()
                    return true
                end
            end
        end
    end
    return false -- Solo se puede seleccionar una zona incluida en el catalogo.
end

-- Diagnostico a peticion del usuario, sin cambiar los filtros del mapa.
function WT.PrintPlayerZoneDiagnostic()
    local actual = GetZoneText and GetZoneText() or "(no disponible)"
    local real = GetRealZoneText and GetRealZoneText() or "(no disponible)"
    local matched = WT.SelectPlayerZone()
    local selected = WT.Zones[WT.SelectedZone]
    WT.Print("zona del personaje: " .. tostring(actual) .. " / " .. tostring(real))
    WT.Print("zona detectada en el catalogo: " .. (matched and "si" or "no"))
    WT.Print("zona del registro: " .. tostring(selected and selected.name or "(ninguna)"))
    if WT.MainFrame and WT.MainFrame:IsShown() then WT.RefreshList() end
end
