ESX = nil

CreateThread(function() 
    while ESX == nil do  
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Wait(1)
    end 
end)

TriggerEvent('chat:addSuggestion', '/gangwar', 'Gangwar', {{ name="Zone", help="A Zone"}, { name="Atacker", help="job Name of Atacker"}})

RegisterNetEvent("Gangwar:Notify")
AddEventHandler("Gangwar:Notify", function(type, msg, time)
    TriggerEvent('b_notify', tpye, "Mockos Gangwar", msg, time)
end)

RegisterNetEvent("Gangwar:Announce")
AddEventHandler("Gangwar:Announce", function(msg, time)
    TriggerEvent('b_announce', msg, time, "Mockos Gangwar")
end)

DoScreenFadeIn(1)

local Gangwar = false
local inGangwar = false
local Atacker = ""
local Deffender = ""
local Zone = ""
local RightJob = false
local Job = ""
local zoneblip = {}

local Vehicle = 0

local SavedWeapons = {}
local SavedAmmo = {}

RegisterNetEvent("Gangwar:WinnerJobNotify")
AddEventHandler("Gangwar:WinnerJobNotify", function(p3, p4)
    local Winner = p3
    local Zon = p4
    if inGangwar then
        if Winner == Atack then
            if Job == "Atacker" then
                TriggerEvent("Gangwar:Notify", "success", "Ihr Habt Die Zone "..Zon.." Erfolgreich Gewonnen!", 5000)
            elseif Job == "Deffender" then
                TriggerEvent("Gangwar:Notify", "error", "Ihr Habt Die Zone "..Zon.." Leider Verloren!", 5000)
            end
        elseif Winner == Deffe then
            if Job == "Atacker" then
                TriggerEvent("Gangwar:Notify", "success", "Ihr Habt Die Zone "..Zon.." Leider Nicht Gewonnen", 5000)
            elseif Job == "Deffender" then
                TriggerEvent("Gangwar:Notify", "error", "Ihr Habt Die Zone "..Zon.." Erfolgreich Verteidigt", 5000)
            end
        end
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerData)
    TriggerServerEvent("Gangwar:CheckifGangwar")
end)

RegisterNetEvent("Gangwar:WasinGangwar")
AddEventHandler("Gangwar:WasinGangwar", function()
    Wait(20000)
    TriggerEvent('inventory:InvGangwar', true)
    inGangwar = true
    TriggerEvent("Gangwar:Leave")
end)


-- Getting ConfigStuff so the code looks smoother
local JoinMarker = Config.JoinMarker
local VehicleMarker = Config.VehicleMarker
local ZonesConfig = Config.Zone
local AtackerConfig = ""
local DeffenderConfig = ""
local ZoneConfig = ""

RegisterNetEvent("Gangwar:InfoToClient")
AddEventHandler("Gangwar:InfoToClient", function(type, p1, p2, p3, p4)
    if type == 1 then
        Gangwar = p1
        Atacker = p2
        Deffender = p3
        Zone = p4
        AtackerConfig = Config.Fraktionen[Atacker]
        DeffenderConfig = Config.Fraktionen[Deffender]
        ZoneConfig = Config.Zones[Zone]
    elseif type == 2 then
        RightJob = p1
        Job = p2
    elseif type == 3 then
        Gangwar = false
        Atacker = ""
        Deffender = ""
        Zone = ""
        RightJob = false
        Job = ""
    end
end)

------------Marker----------
------------Start---------------
Citizen.CreateThread(function()
    while true do
        local Player = PlayerPedId()
        local CoordsPlayer = vector3(GetEntityCoords(Player))
        local distance = GetDistanceBetweenCoords(CoordsPlayer, JoinMarker.Coords, true)
        if distance < 30 then
            if JoinMarkerLoad ~= true then
                JoinMarkerLoad = true
                TriggerEvent("Gangwar:DrawJoinMarker")
            end
            Wait(10000)
        else
            JoinMarkerLoad = false
        end
        Wait(5000)
    end
end)

Citizen.CreateThread(function(source)
    while true do
        local Player = PlayerPedId()
        local CoordsPlayer = vector3(GetEntityCoords(Player))
        local distance = GetDistanceBetweenCoords(CoordsPlayer, JoinMarker.Coords, true)
        if distance < 2 then
            ESX.ShowHelpNotification("~w~Drücke ~r~[E] ~w~um dem ~r~Gangwar ~w~beizutreten", true, true, 1000)
            if IsControlJustPressed(0, 38) then
                TriggerEvent("Gangwar:PressedJoinMarker")
            end
        end
        Wait(5)
    end
end)

AddEventHandler("Gangwar:DrawJoinMarker", function()
    while JoinMarkerLoad == true do
        DrawMarker(JoinMarker.Type, JoinMarker.Coords, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, JoinMarker.Scale, JoinMarker.Colour, JoinMarker.Alpha, false, true, 2, nil, nil, false)
        Wait(0)
    end
end)

----------------------------------------------------------------------

Citizen.CreateThread(function()
    while true do
        if inGangwar then
            local Player = PlayerPedId()
            local CoordsPlayer = vector3(GetEntityCoords(Player))
            local distance = GetDistanceBetweenCoords(CoordsPlayer, ZoneConfig.AtackerVehicleMarker, true)
            if distance < 30 then
                if AtackerMarkerLoad ~= true then
                    AtackerMarkerLoad = true
                    TriggerEvent("Gangwar:DrawAVehicleMarker")
                end
                Wait(10000)
            end
        else
            AtackerMarkerLoad = false
        end
        Wait(5000)
    end
end)

Citizen.CreateThread(function(source)
    while true do
        if inGangwar then
            local Player = PlayerPedId()
            local CoordsPlayer = vector3(GetEntityCoords(Player))
            local distance = GetDistanceBetweenCoords(CoordsPlayer, ZoneConfig.AtackerVehicleMarker, true)
            if distance < 2 then
                ESX.ShowHelpNotification("~w~Drücke ~r~[E] ~w~um dem ~r~Gangwar ~w~beizutreten", true, true, 1000)
                if IsControlJustPressed(0, 38) then
                    TriggerEvent("Gangwar:PressedVehicleMarker")
                end
            end
        end
        Wait(5)
    end
end)

AddEventHandler("Gangwar:DrawAVehicleMarker", function()
    while AtackerMarkerLoad == true do
        DrawMarker(VehicleMarker.Type, ZoneConfig.AtackerVehicleMarker, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, VehicleMarker.Scale, 255, 0, 0, VehicleMarker.Alpha, false, true, 2, nil, nil, false)
        Wait(0)
    end
end)

------------------------------------------------------------------

Citizen.CreateThread(function()
    while true do
        if inGangwar then
            local Player = PlayerPedId()
            local CoordsPlayer = vector3(GetEntityCoords(Player))
            local distance = GetDistanceBetweenCoords(CoordsPlayer, ZoneConfig.DeffenderVehicleMarker, true)
            if distance < 30 then
                if DeffenderMarkerLoad ~= true then
                    DeffenderMarkerLoad = true
                    TriggerEvent("Gangwar:DrawDVehicleMarker")
                end
                Wait(10000)
            end
        else
            DeffenderMarkerLoad = false
        end
        Wait(5000)
    end
end)

Citizen.CreateThread(function(source)
    while true do
        if inGangwar then
            local Player = PlayerPedId()
            local CoordsPlayer = vector3(GetEntityCoords(Player))
            local distance = GetDistanceBetweenCoords(CoordsPlayer, ZoneConfig.DeffenderVehicleMarker, true)
            if distance < 2 then
                ESX.ShowHelpNotification("~w~Drücke ~r~[E] ~w~um dem ~r~Gangwar ~w~beizutreten", true, true, 1000)
                if IsControlJustPressed(0, 38) then
                    TriggerEvent("Gangwar:PressedVehicleMarker")
                end
            end
        end
        Wait(5)
    end
end)

AddEventHandler("Gangwar:DrawDVehicleMarker", function()
    while DeffenderMarkerLoad == true do
        DrawMarker(VehicleMarker.Type, ZoneConfig.DeffenderVehicleMarker, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, VehicleMarker.Scale, 255, 0, 0, VehicleMarker.Alpha, false, true, 2, nil, nil, false)
        Wait(0)
    end
end)
---------End--------

--------Blip-----------
-------Start-----------
Citizen.CreateThread(function()
    local JoinBlip = AddBlipForCoord(Config.JoinBlip.Coords)

    SetBlipSprite(JoinBlip, Config.JoinBlip.Type)
    SetBlipColour(JoinBlip, Config.JoinBlip.Color)
    SetBlipScale(JoinBlip, Config.JoinBlip.Size)
    SetBlipAsShortRange(JoinBlip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName("Gangwar")
    EndTextCommandSetBlipName(JoinBlip)
end)

Citizen.CreateThread(function()
    local Number = ZonesConfig.Number
    for i = 1, Number do
        TriggerServerEvent("Gangwar:GetZones", ZonesConfig[i], i)
    end
end)

RegisterNetEvent("Gangwar:LoadBlips")
AddEventHandler("Gangwar:LoadBlips", function(p1, p2, i)
    local ZoneName = p1
    local Owner = Config.Fraktionen[p2].name
    local Color = Config.Fraktionen[p2].BlipColor
    local ZoneCoords = Config.Zones[ZoneName].Coords
    local name = "Gangwar: "..ZoneName..", Besitzer: "..Owner
    local cblip = Config.Blip

    zoneblip[i] = AddBlipForCoord(ZoneCoords)

    SetBlipSprite(zoneblip[i], cblip.Type)
    SetBlipColour(zoneblip[i], Color)
    SetBlipScale(zoneblip[i], cblip.Size)
    SetBlipAsShortRange(zoneblip[i], true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName(name)
    EndTextCommandSetBlipName(zoneblip[i])
end)

RegisterNetEvent("Gangwar:ReLoadBlips")
AddEventHandler("Gangwar:ReLoadBlips", function()
    local Number = ZonesConfig.Number
    for i = 1, Number do
        RemoveBlip(zoneblip[i])
        TriggerServerEvent("Gangwar:GetZones", ZonesConfig[i], i)
    end
end)

AddEventHandler("Gangwar:ZoneBlip", function()
    if blip ~= nil then
        RemoveBlip(blip)
    end
    blip = AddBlipForRadius(ZoneConfig.Coords, ZoneConfig.Radius)

    SetBlipColour(blip, 1)
    SetBlipAlpha(blip, 150)
    SetBlipAsShortRange(blip, true)
end)
---------------End---------------


-----------WeaponStuff-----------
-----------Start-----------------

function RemoveandSaveWeapons()
    local playerPed = PlayerPedId()
    local i = 0

    while GetBestPedWeapon(playerPed, 0) ~= -1569615261 do
        i = i+1
        SavedWeapons[i] = GetBestPedWeapon(playerPed, 0)
        SavedAmmo[i] = GetAmmoInPedWeapon(playerPed, SavedWeapons[i])
        RemoveWeaponFromPed(playerPed, SavedWeapons[i])
        while HasPedGotWeapon(playerPed, SavedWeapons[i]) do
            RemoveWeaponFromPed(playerPed, SavedWeapons[i])
            Wait(0)
        end
        Wait(0)
    end
    return
end

function GiveSavedWeapons()
    local playerPed = PlayerPedId()
    local i = 1

    while SavedWeapons[i] ~= nil do
        local Wep = SavedWeapons[i]
        local Ammo = SavedAmmo[i]   
        GiveWeaponToPed(playerPed, Wep, 0, false, false)
        SetPedAmmo(playerPed, Wep, Ammo)
        Wep = 0
        Ammo = 0
        i = i+1
        Wait(0)
    end
    return
end

function RemoveWep()
    local playerPed = PlayerPedId()
    local WeaponsNumber = Config.Weapons.WeaponsNumber

    for i = 1, WeaponsNumber do
        local weaponHash = GetHashKey(Config.Weapons[i])
        while HasPedGotWeapon(playerPed, weaponHash) do
            SetPedInfiniteAmmo(playerPed, false, weaponHash)
            RemoveWeaponFromPed(playerPed, weaponHash)
            SetPedAmmo(playerPed, weaponHash, 0)
            Wait(0)
        end
    end
    return
end

function GiveWep()
    local playerPed = PlayerPedId()
    local WeaponsNumber = Config.Weapons.WeaponsNumber

    for i = 1, WeaponsNumber do
        local weaponHash = GetHashKey(Config.Weapons[i])
        GiveWeaponToPed(playerPed, weaponHash, 250, false, false)
        SetPedInfiniteAmmo(playerPed, true, weaponHash)
    end
    return
end
---------------End----------------

-----------Distance Tracker-------
-----------Start------------------
AddEventHandler("Gangwar:CheckZoneDistance", function()
    local inZone = false
    while inGangwar do
        local Player = PlayerPedId()
        local CoordsPlayer = vector3(GetEntityCoords(Player))
        local distance = GetDistanceBetweenCoords(CoordsPlayer, ZoneConfig.Coords, true)
        if distance > ZoneConfig.Radius then
            if inZone then
                inZone = false
                TriggerEvent("Gangwar:Notify", "error", "Gangwar Zone Verlassen!", 2000)
            end
        else
            if inZone == false then
                inZone = true
                TriggerEvent("Gangwar:Notify", "success", "Gangwar Zone Betreten!", 2000)
            end
        end
        Wait(0)
    end
end)
--------------End---------------

RegisterNetEvent("Gangwar:Leave")
AddEventHandler("Gangwar:Leave", function()
    if inGangwar then
        SetDisplay(false)
        DoScreenFadeOut(250)
        RemoveWep()
        if DoesEntityExist(Vehicle) then
            DeleteVehicle(Vehicle)
        end
        Vehicle = 0
        inGangwar = false
        inZone = false
        DeffenderMarkerLoad = false
        AtackerMarkerLoad = false
        RemoveBlip(blip)
        TriggerEvent("Gangwar:Teleport", Config.JoinMarker.Coords)
        Wait(1000)
        GiveSavedWeapons()
        TriggerServerEvent("Gangwar:ChangeDimension", Config.StandartDimension)
        Wait(2000)
        TriggerEvent("esx_ambulancejob:revive", source)
        TriggerEvent("Gangwar:Notify", "success", "Gangwar Verlassen!", 5000) 
        DoScreenFadeIn(250)
        TriggerServerEvent("Gangwar:RefreshPlayerinDb", 0)
        Wait(2000)
        TriggerEvent('inventory:InvGangwar', false)
    end
end)

AddEventHandler("Gangwar:PressedVehicleMarker", function()
    if inGangwar then
        local Player = PlayerPedId()
        if DoesEntityExist(Vehicle) then
            if IsVehicleSeatFree(Vehicle, -1) then
                DeleteVehicle(Vehicle)
            end
        end
        Vehicle = 0
        local ModelHash = GetHashKey(Config.Vehicle)
        RequestModel(ModelHash)
        while not HasModelLoaded(ModelHash) do
            Citizen.Wait(10)
        end
        if Job == "Atacker" then
            Vehicle = CreateVehicle(ModelHash, ZoneConfig.AtackerVehicleSpawnPoint, true, false)
            SetVehicleColours(Vehicle, AtackerConfig.Color1, AtackerConfig.Color2)
            SetVehicleEngineOn(Vehicle, true, true, false)
            SetVehicleNumberPlateText(Vehicle, "Gangwar")
        elseif Job == "Deffender" then
            Vehicle = CreateVehicle(ModelHash, ZoneConfig.DeffenderVehicleSpawnPoint, true, false)
            SetVehicleColours(Vehicle, DeffenderConfig.Color1, DeffenderConfig.Color2)
            SetVehicleEngineOn(Vehicle, true, true, false)
            SetVehicleNumberPlateText(Vehicle, "Gangwar")
        end
        SetModelAsNoLongerNeeded(ModelHash)
        SetPedIntoVehicle(Player, Vehicle, -1)
    end
end)

AddEventHandler("Gangwar:PressedJoinMarker", function()
    if Gangwar then
        TriggerServerEvent("Gangwar:CheckJob", source)
        Wait(100)
        if RightJob then
            TriggerEvent('inventory:InvGangwar', true)
            DoScreenFadeOut(200)
            RemoveandSaveWeapons()
            inGangwar = true
            Wait(1000)
            if Job == "Atacker" then
                TriggerEvent("Gangwar:Teleport", ZoneConfig.AtackerSpawn)
            else 
                TriggerEvent("Gangwar:Teleport", ZoneConfig.DeffenderSpawn)
            end
            Wait(1000)
            TriggerEvent("Gangwar:CheckZoneDistance")
            TriggerEvent("Gangwar:Sphere")
            TriggerEvent("Gangwar:ZoneBlip")
            TriggerServerEvent("Gangwar:ChangeDimension", Config.GangwarDimension)
            TriggerEvent("Gangwar:Notify", "success", "Gangwar Beigetreten!", 5000)
            GiveWep()
            SetDisplay(true)
            DoScreenFadeIn(200)
            TriggerServerEvent("Gangwar:RefreshPlayerinDb", 1)
        else
            TriggerEvent("Gangwar:Notify", "error", "Deine Familie ist nicht am Gangwar beteiligt!", 5000) 
        end
    else
        TriggerEvent("Gangwar:Notify", "error", "Kein Gangwar zurzeit Gestartet!", 5000) 
    end
end)

AddEventHandler("Gangwar:Sphere", function()
    while inGangwar do
        DrawSphere(ZoneConfig.Coords, ZoneConfig.Radius, 255, 0, 0, 0.5)
        Wait(0)
    end
end)

AddEventHandler("Gangwar:Teleport", function(pos)
    local Player = PlayerPedId()
    SetEntityCoords(Player, pos, 0, 0, 0, false)
end)

RegisterNetEvent("Gangwar:TimertoClient")
AddEventHandler("Gangwar:TimertoClient", function(time)
    if inGangwar then
        LocalTime(time)
    end
end)

RegisterNetEvent("Gangwar:PointsToClient")
AddEventHandler("Gangwar:PointsToClient", function(p1, p2)
    Points(p2, p1)
end)

AddEventHandler("esx:onPlayerDeath", function(data)
    if Gangwar then
        if inGangwar then
            if Job == "Atacker" then
                TriggerServerEvent("Gangwar:AddPoints", "Deffender")
            elseif Job == "Deffender" then
                TriggerServerEvent("Gangwar:AddPoints", "Atacker")
            end
            RemoveWep()
            local Time = Config.RespawnTime
            while Time ~= 0 do
                TriggerEvent("Gangwar:Notify", "info", "Du wirst in "..Time.."sec Wiederbelebt!", 1500)
                Time = Time-1
                Wait(1000)
            end
            inZone = false
            if Job == "Atacker" then
                TriggerEvent("Gangwar:Teleport", ZoneConfig.AtackerSpawn)
            elseif Job == "Deffender" then
                TriggerEvent("Gangwar:Teleport", ZoneConfig.DeffenderSpawn)
            end
            if inGangwar then
                TriggerEvent("esx_ambulancejob:revive", source)
                Wait(1000)
                GiveWep()
            end
        end
    end
end)

-------LEAVE--------
function SetDisplay(bool)
    local A = AtackerConfig.name
    local D = DeffenderConfig.name
    SetNuiFocus(false, false)
    SendNUIMessage({
        type = "ui",
        status = bool,
        punkte = false,
        timer = false,
        job1 = D,
        job2 = A,
    })
end

function Points(int1, int2)
    SetNuiFocus(false, false)
    SendNUIMessage({
        type = "ui",
        status = true,
        punkte = true,
        timer = false,
        plinks = int2,
        prechts = int1,
    })
end

function LocalTime(int)
    SetNuiFocus(false, false)
    SendNUIMessage({
        type = "ui",
        status = true,
        punkte = false,
        timer = true,
        zeit = int,
    })
end

RegisterNUICallback("exit", function(data)
    SetDisplay(false)
end)

RegisterNUICallback("main", function(data)
    SetDisplay(false)
end)

RegisterNUICallback("error", function(data)
    SetDisplay(false)
end)

RegisterNUICallback("exit", function(data)
    SetDisplay(false)
end)
