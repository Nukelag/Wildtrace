local WT = WildTrace

WT.RegisterZone({
    key = "Ghostlands",
    name = "Tierras Fantasma",
    worldMapAreaID = 95,
    continent = "EasternKingdoms",
    continentID = 2,
    mapFile = "Ghostlands",
    creatures = {

        {
            id = "NPC-22062",
            name = "Dr. Miembro Marchito",
            englishName = "Dr. Whitherlimb",
            level = 18,
            kind = "Raro",
            creatureType = "No-muerto",
            creatureSubtype = "Humano no-muerto",
            tameable = false,
            notes = "Un siniestro científico no-muerto de la Plaga que merodea por los zigurats de la Cicatriz Muerta y Ciudad de la Muerte. Utiliza peligrosos venenos y elixires experimentales para debilitar a sus enemigos, aumentar su tamaño y recuperar fuerzas durante el combate.",
            locations = {
                {29.4,88.4},{29.4,88.6},{29.6,88.4},{29.6,88.8},{29.8,87.4},
                {33.6,52.4},{34.2,48.2},{34.2,48.8},{34.2,49.6},{34.4,47.2},
                {34.6,47.6},{34.8,50.2},{35.0,86.6},{35.4,88.4},{35.4,88.6},
                {35.6,88.8},{36.0,89.6},{36.6,89.8},{39.4,49.8},{40.2,49.8},
                {40.4,49.2},{40.6,48.4},{40.6,48.6},{40.6,49.6},{41.4,47.0},
                {41.6,46.6},{41.8,46.2},{41.8,47.8},
            },
        },

    },
})
