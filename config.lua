Config = {}

Config.Vehicle = "revolter"
Config.GangwarTime = 15 --in Min
Config.PointsperKill = 3
Config.RespawnTime = 10 --in Sec
Config.GangwarDimension = 7 --Lass es
Config.StandartDimension = 0 --Lass es

Config.WesteundMedikitziehtzeit = 5 --in sec

Config.JoinMarker = {
    Coords = vector3(-429.0662, 1110.7826, 327.6964),
    Type = 2,
    Scale = vector3(1.0, 1.0, 1.0),
    Colour = vector3(255, 0, 0),
    Alpha = 50
}

Config.VehicleMarker = {
    Type = 2,
    Scale = vector3(1.0, 1.0, 1.0),
    Alpha = 155
}

Config.JoinBlip = {
    Coords = vector3(-429.0662, 1110.7826, 327.6964),
    Color = 1,
    Type = 378,
    Size = 1.0
}

Config.Blip = {
    Type = 84,
    Size = 0.7
}

Config.Fraktionen = {
    ["lcn"] = {
        Color1 = 13,
        Color2 = 0,
        BlipColor = 40,
        name = "La Cosa Nostra"
    },
    ["sinaloa"] = {
        Color1 = 111,
        Color2 = 111,
        BlipColor = 37,
        name = "Sinaloa Kartel"
    },
}

Config.BlackListedFraktionen = {
    "police",
    "ambulance",
    "unemployed",
    "tuner"
}

Config.Weapons = {
    WeaponsNumber = 3,
    [1] = "WEAPON_HEAVYPISTOL",
    [2] = "WEAPON_ASSAULTRIFLE",
    [3] = "WEAPON_GUSENBERG"
}

Config.Zone = {
    Number = 7,
    [1] = "Ranch",
    [2] = "Baustelle",
    [3] = "Palleto",
    [4] = "MD",
    [5] = "Hafen",
    [6] = "Kortz",
    [7] = "Flugplatz"
}

Config.Zones = {
    ["Ranch"] = {
        Coords = vector3(1398.6733, 1147.4473, 114.3336),
        Radius = 150.0,
        --Atacker
        AtackerSpawn = vector3(1199.3927, 1840.7388, 78.7635),
        AtackerVehicleSpawnPoint = vector4(1198.6953, 1829.3967, 78.8659, 109.6360),
        AtackerVehicleMarker = vector3(1203.0538, 1837.6898, 78.8737),
        --Deffender
        DeffenderSpawn = vector3(852.6933, 528.9441, 125.9152),
        DeffenderVehicleSpawnPoint = vector4(859.7088, 535.5248, 125.7804, 249.1550),
        DeffenderVehicleMarker = vector3(860.7631, 526.0154, 125.7643)
    },
    ["Baustelle"] = {
        Coords = vector3(1016.4971, 2342.5164, 50.3586),
        Radius = 200.0,
        --Atacker
        AtackerSpawn = vector3(695.8964, 2333.6985, 50.4138),
        AtackerVehicleSpawnPoint = vector4(695.7983, 2343.4517, 50.1997, 93.4308),
        AtackerVehicleMarker = vector3(702.7690, 2338.8298, 50.4353),
        --Deffender
        DeffenderSpawn = vector3(1199.8408, 1840.6918, 78.7720),
        DeffenderVehicleSpawnPoint = vector4(1198.6953, 1829.3967, 78.8659, 109.6360),
        DeffenderVehicleMarker = vector3(1203.1947, 1837.5986, 78.8736)
    },
    ["Palleto"] = {
        Coords = vector3(-137.6602, 6322.8364, 31.6383),
        Radius = 180.0,
        --Atacker
        AtackerSpawn = vector3(1088.8893, 6506.4839, 21.0654),
        AtackerVehicleSpawnPoint = vector4(1086.7764, 6499.3062, 21.0637, 89.7132),
        AtackerVehicleMarker = vector3(1082.3276, 6506.6421, 21.0189),
        --Deffender
        DeffenderSpawn = vector3(-839.6040, 5402.0127, 34.6152),
        DeffenderVehicleSpawnPoint = vector4(-841.3530, 5414.7017, 34.5405, 81.6837),
        DeffenderVehicleMarker = vector3(-842.6662, 5408.0479, 34.6114)
    },
    ["MD"] = {
        Coords = vector3(-1929.3290, -357.3087, 48.0224),
        Radius = 100.0,
        --Atacker
        AtackerSpawn = vector3(-2681.5271, -26.8586, 15.7357),
        AtackerVehicleSpawnPoint = vector4(-2691.6150, -29.1027, 15.2971, 218.923),
        AtackerVehicleMarker = vector3(-2687.0745, -21.0051, 15.6664),
        --Deffender
        DeffenderSpawn = vector3(-1327.4056, -933.2236, 11.3523),
        DeffenderVehicleSpawnPoint = vector4(-1324.9567, -926.6622, 11.2021, 292.9986),
        DeffenderVehicleMarker = vector3(-1333.2026, -929.4288, 11.3522)
    },
    ["Hafen"] = {
        Coords = vector3(980.0750, -3108.4434, 5.9007),
        Radius = 250.0,
        --Atacker
        AtackerSpawn = vector3(264.4877, -2506.2349, 6.4402),
        AtackerVehicleSpawnPoint = vector4(271.1691, -2503.5061, 6.4402, 282.4801),
        AtackerVehicleMarker = vector3(266.6973, -2509.8010, 6.4401),
        --Deffender
        DeffenderSpawn = vector3(1044.3790, -2158.1252, 31.5934),
        DeffenderVehicleSpawnPoint = vector4(1054.4595, -2167.5964, 32.0530, 179.9571),
        DeffenderVehicleMarker = vector3(1044.3984, -2164.9951, 31.5261)
    },
    ["Kortz"] = {
        Coords = vector3(-2252.7815, 281.7660, 174.2140),
        Radius = 150.0,
        --Atacker
        AtackerSpawn = vector3(-1486.3708, -308.7699, 46.9705),
        AtackerVehicleSpawnPoint = vector4(-1476.6693, -309.2200, 46.4040, 320.0817),
        AtackerVehicleMarker = vector3(-1482.6273, -313.9157, 46.9142),
        --Deffender
        DeffenderSpawn = vector3(-1933.7026, 590.8293, 120.3475),
        DeffenderVehicleSpawnPoint = vector4(-1940.8278, 581.8013, 118.9493, 66.1730),
        DeffenderVehicleMarker = vector3(-1936.4148, 586.0167, 119.6093)
    },
    ["Flugplatz"] = {
        Coords = vector3(1357.6578, 3199.2273, 38.470),
        Radius = 300.0,
        --Atacker
        AtackerSpawn = vector3(2419.5615, 4020.4370, 36.8359),
        AtackerVehicleSpawnPoint = vector4(2426.1199, 4010.5847, 36.6758, 243.9139),
        AtackerVehicleMarker = vector3(2424.7549, 4024.6619, 36.7955),
        --Deffender
        DeffenderSpawn = vector3(318.0534, 2624.2498, 44.4680),
        DeffenderVehicleSpawnPoint = vector4(325.5042, 2631.1931, 44.5252, 13.1102),
        DeffenderVehicleMarker = vector3(322.9902, 2618.7468, 44.4911)
    }
}
