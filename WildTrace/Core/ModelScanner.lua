local WT = WildTrace

-- La disponibilidad visual es propia de la instalacion del cliente, no del personaje.
-- Estos estados viven solo en memoria y se reconstruyen al entrar al mundo.
WT.ModelAvailability = {}

local probe = CreateFrame("GameTooltip", "WT_ModelCacheTooltip")
probe:AddFontStrings(
    probe:CreateFontString("$parentTextLeft1", nil, "GameTooltipText"),
    probe:CreateFontString("$parentTextRight1", nil, "GameTooltipText")
)
probe:Hide()

local function queryModelCache(npcID)
    if not npcID or npcID < 1 or npcID > 65535 then return false end
    local ok, available = pcall(function()
        probe:SetOwner(WorldFrame, "ANCHOR_NONE")
        probe:SetHyperlink(("unit:0xF53000%04X000000"):format(npcID))
        return probe:IsShown()
    end)
    probe:Hide()
    if not ok then return nil end
    return available and true or false
end

local zoneNPCs = {}
local allNPCs = {}
local activeZone
local activePending = {}
local startupIndex = 1
local startupDone = false
local scanElapsed = 0

function WT.CheckModelCache(npcID)
    local available = queryModelCache(npcID)
    if available ~= nil then
        WT.ModelAvailability[npcID] = available
    end
    return available
end

function WT.IsModelAvailable(npcID)
    return WT.ModelAvailability[npcID] == true
end

local function updateActiveZone()
    local zoneKey = WT.GetPlayerZoneKey and WT.GetPlayerZoneKey() or nil
    activeZone = zoneKey
    activePending = {}
    for _, npcID in ipairs(zoneNPCs[zoneKey] or {}) do
        if WT.ModelAvailability[npcID] ~= true then
            table.insert(activePending, npcID)
        end
    end
end

local scanner = CreateFrame("Frame", "WT_ModelScanner")

function WT.StartModelScanner()
    zoneNPCs = {}
    allNPCs = {}
    WT.ModelAvailability = {}
    startupIndex = 1
    startupDone = false
    scanElapsed = 0

    local seen = {}
    for zoneKey, zone in pairs(WT.Zones) do
        local list = {}
        local zoneSeen = {}
        for _, creature in ipairs(zone.creatures) do
            local npcID = WT.GetCreatureNPCID(creature)
            if npcID and npcID <= 65535 then
                if not seen[npcID] then
                    seen[npcID] = true
                    table.insert(allNPCs, npcID)
                end
                if not zoneSeen[npcID] then
                    zoneSeen[npcID] = true
                    table.insert(list, npcID)
                end
            end
        end
        zoneNPCs[zoneKey] = list
    end
    table.sort(allNPCs)
    updateActiveZone()
    scanner:Show()
end

function WT.RefreshModelScannerZone()
    if not WT.initialized then return end
    updateActiveZone()
end

local function refreshSelectedModel(npcID)
    if not WT.DetailModelSelectedCreature or not WT.DetailModelContainer then return end
    if not WT.DetailModelContainer:IsVisible() then return end
    if WT.GetCreatureNPCID(WT.DetailModelSelectedCreature) ~= npcID then return end
    if WT.RefreshCreatureModelPreview then
        WT.RefreshCreatureModelPreview(WT.DetailModelSelectedCreature)
    end
end

scanner:SetScript("OnUpdate", function(self, elapsed)
    if not WT.initialized then return end

    if not startupDone then
        -- Distribuir el inventario inicial para evitar una rafaga de consultas.
        local limit = math.min(startupIndex + 11, #allNPCs)
        for i = startupIndex, limit do
            WT.CheckModelCache(allNPCs[i])
        end
        startupIndex = limit + 1
        if startupIndex > #allNPCs then
            startupDone = true
            updateActiveZone()
        end
        return
    end

    scanElapsed = scanElapsed + elapsed
    if scanElapsed < 0.8 then return end
    scanElapsed = 0

    -- El cambio de zona puede ocurrir antes del evento o al cargar una instancia.
    local zoneKey = WT.GetPlayerZoneKey and WT.GetPlayerZoneKey() or nil
    if zoneKey ~= activeZone then updateActiveZone() end

    local index = 1
    while index <= #activePending do
        local npcID = activePending[index]
        if WT.ModelAvailability[npcID] == true then
            table.remove(activePending, index)
        elseif WT.CheckModelCache(npcID) then
            table.remove(activePending, index)
            refreshSelectedModel(npcID)
        else
            index = index + 1
        end
    end
end)
scanner:Hide()
