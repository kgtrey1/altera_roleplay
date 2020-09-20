--
-- ALTERA PROJECT, 2020
-- arp_vehiclemanager
-- File description:
-- Main server script.
--

ARP = nil

TriggerEvent('arp_framework:FetchObject', function(obj)
    ARP = obj
end)