--
-- ALTERA PROJECT, 2020
-- ARP_Enterprise
-- File description:
-- Server side sale script
--

ARP.RegisterServerCallback('arp_enterprise:GetEnterpriseSaleStatus', function(source, cb, name)
	cb(ENT[name].for_sale)
end)

AddEventHandler('arp_enterprise:BuyEnterprise', BuyEnterprise)
function BuyEnterprise(entName)
    local _source   = source
    local Alter     = ARP.GetPlayerById(_source)

    if (Alter.money.GetCash() > ENT[entName].sell_price) then
        
    else
        Alter.ShowNotification("Vous n'avez pas assez d'argent pour acheter cette entreprise.")
    end
end