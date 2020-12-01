local ARP = nil

TriggerEvent('arp_framework:FetchObject', function(obj)
	ARP = obj
end)

function Buy(type)
	local _source = source
	local Alter = ARP.GetPlayerById(_source)

    if (Config.Prices[type] == nil) then
        return
    end
	if (Alter == nil) then
		return
	elseif (Alter.money.GetCash() >= Config.Prices[type]) then
        Alter.money.RemoveCash(Config.Prices[type])
        TriggerClientEvent('arp_drivingschool:StartTest', _source, type)
	else
		Alter.ShowNotification("Vous n'avez pas assez d'argent.")
	end
	return
end

RegisterNetEvent('arp_drivingschool:Buy')
AddEventHandler('arp_drivingschool:Buy', Buy)