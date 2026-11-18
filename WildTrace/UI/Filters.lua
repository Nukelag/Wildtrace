local WT = WildTrace

WT.SelectedContinent = "EasternKingdoms"
WT.SelectedZone = "DunMorogh"

function WT.LoadFilters()
    if not WT.Zones[WT.SelectedZone] then
        local keys = WT.GetZoneKeys(WT.SelectedContinent)
        WT.SelectedZone = keys[1]
    end
end

function WT.SetContinent(continentKey)
    WT.SelectedContinent = continentKey
    local keys = WT.GetZoneKeys(continentKey)
    WT.SelectedZone = keys[1]
    WT.ListPage = 1
    if WT.RefreshDropdowns then WT.RefreshDropdowns() end
    if WT.RefreshList then WT.RefreshList() end
end

function WT.SetZone(zoneKey)
    if WT.Zones[zoneKey] then
        WT.SelectedZone = zoneKey
        WT.ListPage = 1
        WT.RefreshDropdowns()
        WT.RefreshList()
    end
end
