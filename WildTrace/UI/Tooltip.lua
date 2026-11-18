local WT = WildTrace

function WT.ShowCreatureTooltip(owner, creature)
    if not owner or not creature then return end
    GameTooltip:SetOwner(owner, "ANCHOR_RIGHT")
    GameTooltip:AddLine(WT.GetCreatureDisplayName(creature), 1.0, 0.82, 0.0)
    GameTooltip:AddLine("Nivel " .. tostring(creature.level or "?") .. " - " .. tostring(creature.kind or "Criatura"), 0.9, 0.9, 0.9)

    local creatureType = creature.creatureType or "Tipo desconocido"
    if creature.creatureSubtype and creature.creatureSubtype ~= "" then
        creatureType = creatureType .. " (" .. creature.creatureSubtype .. ")"
    end
    GameTooltip:AddLine("Tipo: " .. creatureType, 0.85, 0.85, 0.85)

    if creature.tameable then
        GameTooltip:AddLine("Domesticable: Sí", 0.35, 1.0, 0.35)
        if creature.petFamily then
            GameTooltip:AddLine("Familia: " .. creature.petFamily, 0.65, 0.9, 1.0)
        end
    else
        GameTooltip:AddLine("Domesticable: No", 0.8, 0.8, 0.8)
    end

    GameTooltip:AddLine(WT.GetZoneDisplayName(WT.Zones[creature.zoneKey]), 0.65, 0.85, 1.0)
    local locations = creature.locations or {}
    if #locations > 0 then
        GameTooltip:AddLine("Puntos registrados: " .. tostring(#locations), 0.85, 0.85, 0.85)
        -- El tooltip de un marcador muestra su punto, no las 600+ coordenadas.
        local point = owner.location
        if point then
            local x, y = point.x or point[1], point.y or point[2]
            if type(x) == "number" and type(y) == "number" then
                GameTooltip:AddLine(string.format("Ubicación: %.1f, %.1f", x, y), 0.85, 0.85, 0.85)
            end
        elseif #locations <= 3 then
            for index, location in ipairs(locations) do
                local x, y = location.x or location[1], location.y or location[2]
                if type(x) == "number" and type(y) == "number" then
                    GameTooltip:AddLine(string.format("Ubicación %d: %.1f, %.1f", index, x, y), 0.85, 0.85, 0.85)
                end
            end
        end
    end
    if creature.referenceCoordinates then
        GameTooltip:AddLine("Referencia aproximada: " .. string.format("%.1f, %.1f", creature.referenceCoordinates.x, creature.referenceCoordinates.y), 0.7, 0.7, 0.7)
    end
    GameTooltip:AddLine("Caza: " .. WT.GetStatusLabel(creature.id), 0.7, 1.0, 0.7)
    if creature.respawn then
        GameTooltip:AddLine("Reaparición: " .. creature.respawn, 0.8, 0.8, 0.8, true)
    end
    if creature.notes then
        GameTooltip:AddLine(creature.notes, 1.0, 0.9, 0.65, true)
    end
    if creature.testOnly then
        GameTooltip:AddLine("PUNTO FICTICIO DE PRUEBA; no es un spawn real", 1.0, 0.35, 0.2, true)
    end
    GameTooltip:Show()
end
