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
        Keys[plate] == nil
        Alter.ShowNotification(_U('drop_keys'))
    elseif (Keys[plate] == nil) then
        Keys[plate] == steamId
        Alter.ShowNotification(_U('pickup_keys'))
    else
        Alter.ShowNotification(_U('keys_taken'))
    end
    return
end

RegisterNetEvent('arp_vehiclemanager:PickupKeys')
AddEventHandler('arp_vehiclemanager:PickupKeys', PickupKeys)