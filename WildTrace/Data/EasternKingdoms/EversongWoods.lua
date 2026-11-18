local WT = WildTrace

WT.RegisterZone({
    key = "EversongWoods",
    name = "Bosque Canción Eterna",
    worldMapAreaID = 94,
    continent = "EasternKingdoms",
    continentID = 2,
    mapFile = "EversongWoods",
    creatures = {

        {
            id = "NPC-16855",
            name = "Tregla",
            englishName = "Tregla",
            level = 10,
            kind = "Raro",
            creatureType = "Humanoide",
            creatureSubtype = "Trol Amani",
            tameable = false,
            notes = "Un feroz guerrero Amani que patrulla los senderos cercanos al lago Elrendar. Su carácter agresivo y su experiencia en combate lo convierten en una amenaza para los aventureros.",
            locations = {
                {62.0,78.6},{62.2,78.4},{62.4,79.8},{63.0,79.2},{63.2,79.8},
                {63.4,77.0},{63.4,78.0},{63.6,77.4},{63.6,78.0},{63.6,78.8},
                {63.6,80.2},{64.8,77.4},{64.8,77.8},{65.0,78.8},{65.4,67.4},
                {65.4,67.8},{65.4,69.2},{65.6,68.0},{66.0,78.2},{66.2,69.0},
                {66.2,70.0},{66.4,79.0},{66.6,68.8},{66.8,70.2},{66.8,79.2},
                {66.8,79.6},{67.0,71.4},{67.4,71.6},{67.6,71.6},{67.6,79.4},
                {67.6,79.6},{68.2,71.2},{68.4,72.8},{68.4,81.2},{68.6,81.2},
                {69.0,73.0},{69.0,82.0},{69.2,72.4},{69.2,79.6},{69.2,82.6},
                {69.4,74.0},{69.4,74.8},{69.4,75.8},{69.4,78.4},{69.4,78.8},
                {69.6,72.8},{69.6,73.8},{69.6,78.0},{69.6,79.4},{69.8,82.0},
                {70.0,72.4},{70.0,76.2},{70.4,75.2},{70.4,76.8},{70.8,75.2},
                {70.8,75.8},{70.8,77.2},
            },
        },

        {
            id = "NPC-16854",
            name = "Eldinarcus",
            englishName = "Eldinarcus",
            level = 11,
            kind = "Raro",
            creatureType = "Elemental",
            creatureSubtype = "Elemental arcano",
            tameable = false,
            notes = "Una entidad elemental de naturaleza arcana que merodea cerca de la Aguja Ocaso. Atraída por las energías mágicas del entorno, representa un peligro para quienes exploran sus alrededores.",
            locations = {
                {68.2,45.4},{68.4,45.8},{68.4,46.6},{68.6,45.4},{68.6,45.8},
                {69.2,48.0},{69.2,51.0},{69.4,47.2},{69.4,49.2},{69.4,49.6},
                {69.4,52.8},{69.6,46.2},{69.6,49.0},{69.8,49.8},{70.0,47.4},
                {70.2,50.8},{70.4,47.6},{70.6,47.4},{70.8,47.8},
            },
        },

    },
})
