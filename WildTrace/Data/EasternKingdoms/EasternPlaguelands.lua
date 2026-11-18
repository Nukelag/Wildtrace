local WT = WildTrace

WT.RegisterZone({
    key = "EasternPlaguelands",
    name = "Tierras de la Peste del Este",
    worldMapAreaID = 23,
    continent = "EasternKingdoms",
    continentID = 2,
    mapFile = "EasternPlaguelands",
    creatures = {

        {
            id = "NPC-10828",
            name = "Alta general Abbendis",
            englishName = "High General Abbendis",
            level = 59,
            kind = "Élite raro",
            creatureType = "Humanoide",
            creatureSubtype = "Humana",
            tameable = false,
            notes = "Una poderosa comandante de la Cruzada Escarlata que permanece en las fortificaciones de Mano de Tyr. Rodeada de sus guardias defiende ferozmente los aposentos superiores del bastión.",
            locations = {
                {74.8,78.4},{82.2,79.4},{82.2,79.6},
            },
        },

        {
            id = "NPC-10817",
            name = "Duggan Martillo Salvaje",
            englishName = "Duggan Wildhammer",
            level = 55,
            kind = "Raro",
            creatureType = "Humanoide",
            creatureSubtype = "Enano Martillo Salvaje",
            tameable = false,
            notes = "Un peculiar enano afectado por la Plaga tras beber hidromiel contaminado. Deambula entre los caminos y campos abandonados mientras entona canciones sobre su desafortunado destino.",
            locations = {
                {12.2,72.2},{12.2,73.0},{16.2,58.6},{22.2,81.8},{22.4,81.4},
                {28.4,75.8},{28.6,76.2},{28.6,76.8},{37.4,62.6},{37.6,62.0},
            },
        },

        {
            id = "NPC-10825",
            name = "Gish el Inamovible",
            englishName = "Gish the Unmoving",
            level = 56,
            kind = "Raro",
            creatureType = "No-muerto",
            creatureSubtype = "Gárgola",
            tameable = false,
            notes = "Una amenazadora gárgola al servicio del Azote que recorre los cielos sobre las tierras devastadas. Sus poderosos ataques sorprenden a quienes atraviesan los caminos y ruinas cercanas.",
            locations = {
                {48.6,38.2},{50.4,46.0},{59.8,50.6},{60.2,50.4},{61.6,51.4},
                {63.4,51.2},{65.2,50.4},{67.4,51.6},
            },
        },

        {
            id = "NPC-10821",
            name = "Hed'mush el Podrido",
            englishName = "Hed'mush the Rotting",
            level = 57,
            kind = "Raro",
            creatureType = "No-muerto",
            creatureSubtype = "Ogro no-muerto",
            tameable = false,
            notes = "Un enorme ogro no-muerto de aspecto putrefacto que deambula entre las torres de vigilancia. Su descomunal fuerza y sus violentos golpes amenazan a los viajeros.",
            locations = {
                {34.0,68.6},{50.2,21.0},{50.6,20.8},{51.0,20.0},{61.2,44.2},
            },
        },

        {
            id = "NPC-10826",
            name = "Lord Hoz Oscura",
            englishName = "Lord Darkscythe",
            level = 57,
            kind = "Raro",
            creatureType = "No-muerto",
            creatureSubtype = "Esqueleto",
            tameable = false,
            notes = "Un siniestro guerrero esquelético que merodea entre los senderos y ruinas del Bosque de la Peste. Su armamento y sus ataques representan una amenaza para los exploradores.",
            locations = {
                {22.4,27.8},{22.6,28.0},{22.6,28.6},{30.8,20.2},{31.4,20.6},
                {33.6,21.8},{34.4,20.4},{34.4,21.0},{39.4,24.0},
            },
        },

        {
            id = "NPC-10827",
            name = "Portavoz de la muerte Selendre",
            englishName = "Deathspeaker Selendre",
            level = 56,
            kind = "Raro",
            creatureType = "Humanoide",
            creatureSubtype = "Humana",
            tameable = false,
            notes = "Una misteriosa hechicera del Culto de los Malditos que practica magia oscura entre los asentamientos abandonados. Aparece cerca del Valle Fúngico y la Arboleda Tóxica.",
            locations = {
                {35.0,48.0},{36.6,44.4},{36.8,44.6},{77.2,34.2},{79.6,40.2},
                {79.8,40.6},
            },
        },

        {
            id = "NPC-10823",
            name = "Ramurdimbre Zul'Brin",
            englishName = "Zul'Brin Warpbranch",
            level = 59,
            kind = "Raro",
            creatureType = "Humanoide",
            creatureSubtype = "Trol del bosque",
            tameable = false,
            notes = "Un poderoso hechicero trol que habita los campamentos de Zul'Mashar. Utiliza relámpagos y magia curativa mientras sus acompañantes alertan a los guerreros cercanos.",
            locations = {
                {64.2,12.0},{64.8,10.6},{66.0,12.2},{66.4,12.6},{66.8,9.6},
                {67.0,9.4},
            },
        },

        {
            id = "NPC-10822",
            name = "Señor de la guerra Thresh'jin",
            englishName = "Warlord Thresh'jin",
            level = 58,
            kind = "Raro",
            creatureType = "Humanoide",
            creatureSubtype = "Trol del bosque",
            tameable = false,
            notes = "Un feroz caudillo trol que dirige a sus guerreros desde las terrazas de Zul'Mashar. Utiliza devastadores ataques giratorios para defender las posiciones de su tribu.",
            locations = {
                {60.0,17.6},{60.4,17.4},{63.4,16.2},{63.6,16.2},{66.4,10.0},
                {66.6,10.0},{67.2,9.2},
            },
        },

        {
            id = "NPC-10824",
            name = "Señor forestal Lanzalcón",
            englishName = "Ranger Lord Hawkes",
            level = 60,
            kind = "Raro",
            creatureType = "Humanoide",
            creatureSubtype = "Alto elfo",
            tameable = false,
            notes = "Un veterano señor forestal alto elfo que vigila los accesos próximos a Quel'Thalas. Su experiencia militar y sus habilidades de combate lo convierten en un adversario peligroso.",
            locations = {
                {48.2,14.0},{48.2,15.0},{49.0,14.4},
            },
        },

        {
            id = "NPC-16184",
            name = "Sobrestante nerubiano",
            englishName = "Nerubian Overseer",
            level = 60,
            kind = "Élite raro",
            creatureType = "No-muerto",
            creatureSubtype = "Nerubiano",
            tameable = false,
            notes = "Un gigantesco nerubiano no-muerto que protege las posiciones del Azote. Utiliza resistentes telarañas para inmovilizar a sus enemigos y convoca pequeños insectos durante el combate.",
            locations = {
                {5.0,33.4},{5.2,34.4},{6.0,32.6},{6.6,32.8},{7.2,32.0},
                {7.6,30.6},{7.6,31.8},{8.0,29.8},{8.4,29.4},{9.0,29.2},
                {10.4,27.8},{10.6,27.2},{11.6,26.4},{11.8,25.2},{12.2,26.8},
                {12.4,27.6},{12.6,24.8},{12.6,25.8},{12.6,27.4},{13.2,28.0},
                {13.6,28.2},{14.2,28.6},{14.8,28.8},{15.8,26.6},{16.2,26.2},
            },
        },

    },
})
