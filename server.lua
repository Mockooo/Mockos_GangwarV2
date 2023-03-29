ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local Gangwar = false
local Atacker = ""
local Deffender = ""
local Zone = ""

local Timer = false

local AtackerPoints = 0
local DeffenderPoints = 0

Citizen.CreateThread(function()
    while true do
        TriggerClientEvent("Gangwar:InfoToClient", -1, 1, Gangwar, Atacker, Deffender, Zone)
        Wait(60000)
    end
end)

RegisterCommand("gangwar", function(source, args, rawCommand)
    if source == 0 then
        if args[1] ~= nil then
            if args[2] ~= nil then
                if Gangwar == false then
                    Zone = args[1]
                    Atacker = args[2]
                    if Config.Fraktionen[Atacker] ~= nil then
                        if Config.Zones[Zone] ~= nil then
                            local result = MySQL.query.await('SELECT deffender FROM gangwar WHERE zone = ?', {Zone})
                            Deffender = result[1].fraktion
                            if Atacker ~= Config.BlackListedFraktionen then
                                if Atacker ~= Deffender then
                                    Gangwar = true
                                    print("Gangwar Gesartet")
                                    TriggerClientEvent("Gangwar:Announce", -1, "Die Zone "..Zone.." wird von "..Atacker.." Angegrifen", 10000)
                                    TriggerClientEvent("Gangwar:InfoToClient", -1, 1, Gangwar, Atacker, Deffender, Zone)
                                    TriggerEvent("Gangwar:Timer")
                                else
                                    Zone = ""
                                    Atacker = ""
                                    Deffender = ""
                                    print("Eingegebener Atacker ist auch Deffender") 
                                end
                            else
                                Zone = ""
                                Atacker = ""
                                Deffender = ""
                                print("Eingegebener Atacker ist auf der blacklist!") 
                            end
                        else
                            Zone = ""
                            Atacker = ""
                            print("Eingegebene Zone exestiert Nicht!") 
                        end
                    else
                        Zone = ""
                        Atacker = ""
                        print("Eingegebener Atacker exestiert Nicht!") 
                    end
                else
                    print("Momentan Läuft schon ein Gangwar!") 
                end
            else
                print("Keinen Atacker Eingegeben!") 
            end
        else
            print("Keine Zone Eingegeben!") 
        end
    else
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer.getGroup() == 'admin' or xPlayer.getGroup() == 'superadmin'then
            if args[1] ~= nil then
                if args[2] ~= nil then
                    if Gangwar == false then
                        Zone = args[1]
                        Atacker = args[2]
                        if Config.Fraktionen[Atacker] ~= nil then
                            if Config.Zones[Zone] ~= nil then
                                local result = MySQL.query.await('SELECT deffender FROM gangwar WHERE zone = ?', {Zone})
                                Deffender = result[1].deffender
                                if Atacker ~= Config.BlackListedFraktionen then
                                    if Atacker ~= Deffender then
                                        Gangwar = true
                                        TriggerClientEvent("Gangwar:Announce", -1, "Die Zone "..Zone.." wird von "..Atacker.." Angegrifen", 10000)
                                        TriggerClientEvent("Gangwar:Notify", source, "success", "Gangwar Gestartet!", 5000)
                                        TriggerClientEvent("Gangwar:InfoToClient", -1, 1, Gangwar, Atacker, Deffender, Zone)
                                        TriggerEvent("Gangwar:Timer")
                                    else
                                        Zone = ""
                                        Atacker = ""
                                        Deffender = ""
                                        TriggerClientEvent("Gangwar:Notify", source, "error", "Eingegebener Atacker ist auch Deffender", 5000) 
                                    end
                                else 
                                    Zone = ""
                                    Atacker = ""
                                    Deffender = ""
                                    TriggerClientEvent("Gangwar:Notify", source, "error", "Eingegebener Atacker ist auf der blacklist!", 5000) 
                                end
                            else  
                                Zone = ""
                                Atacker = ""  
                                TriggerClientEvent("Gangwar:Notify", source, "error", "Eingegebene Zone exestiert Nicht!", 5000) 
                            end
                        else
                            Zone = ""
                            Atacker = ""
                            TriggerClientEvent("Gangwar:Notify", source, "error", "Eingegebener Atacker exestiert Nicht!", 5000) 
                        end
                    else
                        TriggerClientEvent("Gangwar:Notify", source, "error", "Momentan Läuft schon ein Gangwar!", 5000) 
                    end
                else
                    TriggerClientEvent("Gangwar:Notify", source, "error", "Keinen Atacker Eingegeben!", 5000) 
                end
            else
                TriggerClientEvent("Gangwar:Notify", source, "error", "Keine Zone Eingegeben!", 5000) 
            end
        else
            TriggerClientEvent("Gangwar:Notify", source, "error", "Unzureichende Rechte!", 5000) 
        end
    end
end)

RegisterCommand("quitgangwar", function(source, args, rawCommand)
    if Gangwar then
        TriggerClientEvent("Gangwar:Leave", source)
    end
end)

RegisterCommand("canclegangwar", function(source, args, rawCommand)
    if Gangwar then
        if source == 0 then
            TriggerEvent("Gangwar:Cancle")
        else
            local xPlayer = ESX.GetPlayerFromId(source)
            local group = xPlayer.getGroup()
            if group == "admin" or group == "superadmin" then
                TriggerEvent("Gangwar:Cancle")
            else
                TriggerClientEvent("Gangwar:Notify", source, "error", "Du hast Nicht genug Rechte", 5000) 
            end
        end
    else
        TriggerClientEvent("Gangwar:Notify", source, "error", "Keine Gangwar gestartet Zurzeit", 5000) 
    end
end)

AddEventHandler("Gangwar:Cancle", function()
    local D = Config.Fraktionen[Deffender].name
    local A = Config.Fraktionen[Atacker].name
    local Winner = ""
    local Win = ""
    if AtackerPoints > DeffenderPoints then
        TriggerClientEvent("Gangwar:Announce", -1, D.." Konnte die Zone "..Zone.." Nicht vor "..A.." Verteidigen!", 10000)
        Winner = A
        Win = Atacker
    elseif AtackerPoints < DeffenderPoints then
        TriggerClientEvent("Gangwar:Announce", -1, D.." Konnte die Zone "..Zone.." Erfolgreich vor "..A.." Verteidigen!", 10000)
        Winner = D
        Win = Deffender
    elseif AtackerPoints == DeffenderPoints then
        TriggerClientEvent("Gangwar:Announce", -1, D.." Konnte die Zone "..Zone.." Erfolgreich vor "..A.." Verteidigen!", 10000)
        Winner = D
        Win = Deffender
    end
    TriggerClientEvent("Gangwar:WinnerJobNotify", -1, Winner, Zone)
    TriggerEvent("Gangwar:UpdateZone", Win, Zone)
    TriggerClientEvent("Gangwar:ReLoadBlips", -1)
    TriggerClientEvent("Gangwar:Leave", -1)
    TriggerClientEvent("Gangwar:InfoToClient", -1, 3)
    Gangwar = false
    Atacker = ""
    Deffender = ""
    Zone = ""
    Timer = false
    AtackerPoints = 0
    DeffenderPoints = 0
end)

AddEventHandler("Gangwar:Timer", function()
    local Time = Config.GangwarTime*60
    while Gangwar do
        if Time > 0 then
            TriggerClientEvent("Gangwar:TimertoClient", -1, Time)
            Time = Time-1
            Wait(1000)
        else
            TriggerEvent("Gangwar:Cancle")
            Gangwar = false
        end
    end
end)

RegisterNetEvent("Gangwar:RefreshPlayerinDb")
AddEventHandler("Gangwar:RefreshPlayerinDb", function(int)
    local i = GetPlayerIdentifier(source, 0)
    local upadte = MySQL.update.await('UPDATE users SET in_gangwar = ? WHERE identifier = ?', {int, i})
end)

RegisterNetEvent("Gangwar:CheckifGangwar")
AddEventHandler("Gangwar:CheckifGangwar", function()
    local source_ = source
    local i = GetPlayerIdentifier(source_, 0)
    local result = MySQL.query.await('SELECT in_gangwar FROM users WHERE identifier = ?', {i})
    local ingangwar = result[1].in_gangwar
    if ingangwar == 1 then
        TriggerClientEvent('Mocko:WasinGangwar', source_)
    end
end)

RegisterNetEvent("Gangwar:CheckJob")
AddEventHandler("Gangwar:CheckJob", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local Job = xPlayer.job.name

    if Job == Atacker then
        TriggerClientEvent("Gangwar:InfoToClient", source, 2, true, "Atacker")
    elseif Job == Deffender then
        TriggerClientEvent("Gangwar:InfoToClient", source, 2, true, "Deffender")
    else
        TriggerClientEvent("Gangwar:InfoToClient", source, 2, false, "")
    end
end)


RegisterNetEvent("Gangwar:GetZones")
AddEventHandler("Gangwar:GetZones", function(i, ii)
    local counter = ii
    local src = source
    local result = MySQL.query.await('SELECT zone, deffender FROM gangwar WHERE zone = ?', {i})
    TriggerClientEvent("Gangwar:LoadBlips", src, result[1].zone, result[1].deffender, counter)
end)

AddEventHandler("Gangwar:UpdateZone", function(i, ii)
    local upadte = MySQL.update.await('UPDATE gangwar SET deffender = ? WHERE zone = ?', {i, ii})
end)

RegisterNetEvent("Gangwar:AddPoints")
AddEventHandler("Gangwar:AddPoints", function(p1)
    if p1 == "Atacker" then
        AtackerPoints = AtackerPoints+Config.PointsperKill
    elseif p1 == "Deffender" then
        DeffenderPoints = DeffenderPoints+Config.PointsperKill
    end
    TriggerClientEvent("Gangwar:PointsToClient", -1, AtackerPoints, DeffenderPoints)
end)

RegisterNetEvent("Gangwar:ChangeDimension")
AddEventHandler("Gangwar:ChangeDimension", function(Dimension)
    SetPlayerRoutingBucket(source, Dimension)
end)