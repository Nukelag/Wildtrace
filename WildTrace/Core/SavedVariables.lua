local WT = WildTrace

local function setDefault(tbl, key, value)
    if tbl[key] == nil then tbl[key] = value end
end

function WT.InitializeSavedVariables()
    WildTraceDB = WildTraceDB or {}
    WildTraceCharacterDB = WildTraceCharacterDB or {}

    setDefault(WildTraceDB, "showIcons", true)
    setDefault(WildTraceDB, "showPendingHunt", true)
    setDefault(WildTraceDB, "hideHunted", false)

    WildTraceCharacterDB.hunted = WildTraceCharacterDB.hunted or {}
    WildTraceCharacterDB.characterName = UnitName("player") or "Unknown"
    WildTraceCharacterDB.realmName = GetRealmName and GetRealmName() or "Unknown"
end
