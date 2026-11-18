local WT = WildTrace

WT.Zones = {}
WT.CreaturesByID = {}

function WT.RegisterZone(zone)
    if not zone or not zone.key or not zone.mapFile or not zone.creatures then return end
    WT.Zones[zone.key] = zone
    for _, creature in ipairs(zone.creatures) do
        creature.zoneKey = zone.key
        creature.zoneName = zone.name
        creature.continent = zone.continent
        creature.mapFile = zone.mapFile
        WT.CreaturesByID[creature.id] = creature
    end
end

function WT.GetZoneKeys(continentKey)
    local keys = {}
    for key, zone in pairs(WT.Zones) do
        if not continentKey or zone.continent == continentKey then
            table.insert(keys, key)
        end
    end
    table.sort(keys, function(a, b)
        return WT.GetZoneDisplayName(WT.Zones[a]) < WT.GetZoneDisplayName(WT.Zones[b])
    end)
    return keys
end

function WT.GetCreatureStatus(creatureID)
    local hunted = WildTraceCharacterDB and WildTraceCharacterDB.hunted and WildTraceCharacterDB.hunted[creatureID] == true
    return { hunted = hunted and true or false, complete = hunted and true or false }
end

function WT.GetStatusLabel(creatureID)
    local status = WT.GetCreatureStatus(creatureID)
    return status.hunted and "Cazada" or "Pendiente de caza"
end
