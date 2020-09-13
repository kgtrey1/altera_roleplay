--
-- ALTERA PROJECT, 2020
-- ARP_Fuel
-- File description:
-- Main server side script.
--

ARP = nil

TriggerEvent('arp_framework:FetchObject', function(Object)
    ARP = Object
end)