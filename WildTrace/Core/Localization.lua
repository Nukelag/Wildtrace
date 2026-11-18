local WT = WildTrace

WT.ContinentInfo = {
    Kalimdor = { mapIndex = 1, fallback = "Kalimdor" },
    EasternKingdoms = { mapIndex = 2, fallback = "Reinos del Este" },
    Outland = { mapIndex = 3, fallback = "Terrallende" },
    Northrend = { mapIndex = 4, fallback = "Rasganorte" },
}

local continentNames

function WT.RefreshLocalizedData()
    continentNames = {}
    if GetMapContinents then
        local names = { GetMapContinents() }
        for key, info in pairs(WT.ContinentInfo) do
            continentNames[key] = names[info.mapIndex] or info.fallback
        end
    end

    for _, zone in pairs(WT.Zones) do
        local localizedName
        if GetMapNameByID and zone.worldMapAreaID then
            localizedName = GetMapNameByID(zone.worldMapAreaID)
        end
        zone.displayName = (localizedName and localizedName ~= "") and localizedName or zone.name
    end
end

function WT.GetContinentDisplayName(key)
    local info = WT.ContinentInfo[key]
    if not info then return tostring(key or "") end
    return (continentNames and continentNames[key]) or info.fallback
end

function WT.GetZoneDisplayName(zone)
    if not zone then return "Zona desconocida" end
    if zone.worldMapAreaID and GetMapNameByID then
        local localizedName = GetMapNameByID(zone.worldMapAreaID)
        if localizedName and localizedName ~= "" then
            zone.displayName = localizedName
        end
    end
    return zone.displayName or zone.name or zone.key
end

-- Creature names: use Spanish for Spanish clients and the supplied English
-- alias for other client locales. Additional languages can be added as data
-- becomes available; no unsupported translation is fabricated.
function WT.GetCreatureDisplayName(creature)
    if not creature then return "" end
    local locale = GetLocale and GetLocale() or "esES"
    if locale == "esES" or locale == "esMX" then
        return creature.name or creature.englishName or ""
    end
    return creature.englishName or creature.name or ""
end
