
ARP = nil

TriggerEvent('arp_framework:FetchObject', function(object)
	ARP = object
end)

ARP.RegisterServerCallback('arp_bank:Deposit', function(source, cb, amount)
	local Alter = ARP.GetPlayerById(source)

	amount = tonumber(amount)
	if (amount == nil or amount <= 0 or amount > Alter.money.GetCash()) then
		TriggerClientEvent('arp_bank:Result', _source, "error", "Montant invalide.")
	else
		Alter.money.RemoveCash(amount)
		Alter.money.AddBank(amount)
		TriggerClientEvent('arp_bank:Result', _source, "success", "Dépot effectué.")
		cb(Alter.money.GetBank())
	end
end)

ARP.RegisterServerCallback('arp_bank:Withdraw', function(source, cb, amount)
	local Alter = ARP.GetPlayerById(source)

	amount = tonumber(amount)
	if (amount == nil or amount <= 0 or amount > Alter.money.GetBank()) then
		TriggerClientEvent('arp_bank:Result', _source, "error", "Montant invalide.")
	else
		Alter.money.RemoveBank(amount)
		Alter.money.AddCash(amount)
		TriggerClientEvent('arp_bank:Result', _source, "success", "Retrait effectué.")
		cb(Alter.money.GetBank())
	end
end)

RegisterServerEvent('bank:balance')



RegisterServerEvent('bank:transfer')
AddEventHandler('bank:transfer', function(to, amountt)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local zPlayer = ESX.GetPlayerFromId(to)
	local balance = 0

	if(zPlayer == nil or zPlayer == -1) then
		TriggerClientEvent('bank:result', _source, "error", "Destinataire introuvable.")
	else
		balance = xPlayer.getAccount('bank').money
		zbalance = zPlayer.getAccount('bank').money
		
		if tonumber(_source) == tonumber(to) then
			TriggerClientEvent('bank:result', _source, "error", "Vous ne pouvez pas faire de transfert à vous même.")
		else
			if balance <= 0 or balance < tonumber(amountt) or tonumber(amountt) <= 0 then
				TriggerClientEvent('bank:result', _source, "error", "Vous n'avez pas assez d'argent en banque.")
			else
				xPlayer.removeAccountMoney('bank', tonumber(amountt))
				zPlayer.addAccountMoney('bank', tonumber(amountt))
				TriggerClientEvent('bank:result', _source, "success", "Transfert effectué.")
			end
		end
	end
end)





