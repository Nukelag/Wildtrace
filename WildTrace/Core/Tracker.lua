local WT = WildTrace

function WT.ToggleCreatureHunted(creatureID)
    if not creatureID then return end
    WildTraceCharacterDB.hunted = WildTraceCharacterDB.hunted or {}
    local current = WildTraceCharacterDB.hunted[creatureID] == true
    local creature = WT.CreaturesByID[creatureID]

    if current then
        WildTraceCharacterDB.hunted[creatureID] = nil
    else
        WildTraceCharacterDB.hunted[creatureID] = true
    end

    local action = current and "Se quitó la marca de cazada" or "Marcada como cazada"
    WT.Print(action .. (creature and (": " .. WT.GetCreatureDisplayName(creature)) or "."))

    if WT.RefreshList then WT.RefreshList() end
    if WT.RefreshCreatureMarkers then
        WT.RefreshCreatureMarkers(creatureID)
    elseif WT.RefreshMapMarkers then
        WT.RefreshMapMarkers()
    end
    if WT.UpdateContextMenu then WT.UpdateContextMenu(true) end
end
