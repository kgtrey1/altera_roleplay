
ARP = nil

TriggerEvent('arp_framework:FetchObject', function(object)
	ARP = object
end)

ARP.RegisterServerCallback('arp_bank:Balance', function(source, cb)
	local Alter = ARP.GetPlayerById(source)

	cb(Alter.money.GetBank(), Alter.money.GetBankname())
end)

ARP.RegisterServerCallback('arp_bank:Deposit', function(source, cb, amount)
	local Alter = ARP.GetPlayerById(source)

	amount = tonumber(amount)
	if (amount == nil or amount <= 0 or amount > Alter.money.GetCash()) then
		TriggerClientEvent('arp_bank:Result', source, "error", "Montant invalide.")
	else
		Alter.money.RemoveCash(amount)
		Alter.money.AddBank(amount)
		TriggerClientEvent('arp_bank:Result', source, "success", "Dépot effectué.")
		cb(Alter.money.GetBank())
	end
end)

ARP.RegisterServerCallback('arp_bank:Withdraw', function(source, cb, amount)
	local Alter = ARP.GetPlayerById(source)

	amount = tonumber(amount)
	if (amount == nil or amount <= 0 or amount > Alter.money.GetBank()) then
		TriggerClientEvent('arp_bank:Result', source, "error", "Montant invalide.")
	else
		Alter.money.RemoveBank(amount)
		Alter.money.AddCash(amount)
		TriggerClientEvent('arp_bank:Result', source, "success", "Retrait effectué.")
		cb(Alter.money.GetBank())
	end
end)