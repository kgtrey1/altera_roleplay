--
-- ALTERA PROJECT, 2020
-- arp_cardealer
-- File description:
-- main client side script
--

ARP = nil
Blips = {}

TriggerEvent('arp_framework:FetchObject', function(Obj)
	ARP = Obj
end)

AddEventHandler('arp_framework:PlayerReady', function(playerData)
    ARP.Player = playerData
    
    for _, enterprise in pairs(Config.Enterprises) do -- Register enterprise, either for sale or for blip.
        TriggerEvent('arp_enterprise:RegisterEnterpriseStatus', {name = enterprise.name, bpos = enterprise.shared.bpos, sale = enterprise.shared.sale, blipsetting = Config.Blip})
    end
end)