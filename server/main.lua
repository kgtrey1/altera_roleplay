--
-- ALTERA PROJECT, 2020
-- arp_vehiclemanager
-- File description:
-- Main server script.
--

ARP  = nil
Keys = {}

TriggerEvent('arp_framework:FetchObject', function(obj)
    ARP = obj
end)

function PickupKeys(plate)
    local _source   = source
    local Alter     = ARP.GetPlayerById(_source)
    local steamId   = Alter.GetSteamid()

    if (Keys[plate] ~= nil and Keys[plate] == steamId) then
        Keys[plate] = nil
        Alter.ShowNotification("~g~Vous avez posé les clés du véhicule.~s~")
    elseif (Keys[plate] == nil) then
        Keys[plate] = steamId
        Alter.ShowNotification("~g~Vous avez prit les clés du véhicule~s~")
    else
        Alter.ShowNotification("~r~Il n'y a pas de clés dans ce véhicule~s~")
    end
    return
end

RegisterNetEvent('arp_vehiclemanager:PickupKeys')
AddEventHandler('arp_vehiclemanager:PickupKeys', PickupKeys)

ARP.RegisterServerCallback('arp_vehiclemanager:DoesPlayerHaveKey', function(source, cb, plate)
    local Alter     = ARP.GetPlayerById(source)
    local steamId   = Alter.GetSteamid()

    if (Keys[plate] ~= nil and Keys[plate] == steamId) then
        cb(true)
    else
        cb(false)
    end
    return
end)