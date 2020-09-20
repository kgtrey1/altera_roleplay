--
-- ALTERA PROJECT, 2020
-- arp_vehiclemanager
-- File description:
-- Main client script.
--

ARP = nil

TriggerEvent('arp_framework:FetchObject', function(obj)
    ARP = obj
end)

AddEventHandler('arp_framework:PlayerReady', function(data)
    ARP.Player = data
end)