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
		RegisterTransaction('deposit', Alter.identity.GetFirstname() .. ' ' .. Alter.identity.GetLastname(), 'none', amount, Alter.money.GetBankname())
		TriggerClientEvent('arp_bank:Result', source, "success", "Dépot effectué.")
	end
	cb(Alter.money.GetBank())
end)

ARP.RegisterServerCallback('arp_bank:Withdraw', function(source, cb, amount)
	local Alter = ARP.GetPlayerById(source)

	amount = tonumber(amount)
	if (amount == nil or amount <= 0 or amount > Alter.money.GetBank()) then
		TriggerClientEvent('arp_bank:Result', source, "error", "Montant invalide.")
	else
		Alter.money.RemoveBank(amount)
		Alter.money.AddCash(amount)
		RegisterTransaction('withdraw', Alter.identity.GetFirstname() .. ' ' .. Alter.identity.GetLastname(), 'none', amount, Alter.money.GetBankname())
		TriggerClientEvent('arp_bank:Result', source, "success", "Retrait effectué.")
	end
	cb(Alter.money.GetBank())
end)

ARP.RegisterServerCallback('arp_bank:Transfer', function(source, cb, amount, iban)
	local Altera 	= ARP.GetPlayerById(source)
	local Alterb 	= nil
	local ibanObject = nil

	amount = tonumber(amount)
	if (amount == nil or amount <= 0 or amount > Altera.money.GetBank()) then
		TriggerClientEvent('arp_bank:Result', source, "error", "Montant invalide.")
	else
		ibanObject = GetPlayerRelatedToIban(iban)
		if (ibanObject == nil or ibanObject.iban == Altera.money.GetIban()) then
			TriggerClientEvent('arp_bank:Result', source, "error", "Impossible d'effectuer un transfert vers cet IBAN.")
		else
			Altera.money.RemoveBank(amount)
			Alterb = ARP.GetPlayerBySteamid(ibanObject.steamid)
			if (Alterb == nil) then
				OfflineTransfert((tonumber(ibanObject.bank) + amount), ibanObject.steamid)
			else
				OnlineTransfert(Alterb, amount)
			end
			RegisterTransaction('transfer', Altera.identity.GetFirstname() .. ' ' .. Altera.identity.GetLastname(), ibanObject.iban, amount, Altera.money.GetBankname())
			TriggerClientEvent('arp_bank:Result', source, "success", "Transfert effectué.")
		end
	end
	cb(Altera.money.GetBank())
end)

function RegisterTransaction(type, sender, receiver, amount, bankname)
	local date = os.date("%d/%m/%Y %H:%M:%S")

	MySQL.Sync.execute('INSERT INTO transaction (date, type, sender, receiver, amount, bankname) VALUES(@date, @type, @sender, @receiver, @amount, @bankname)', {
		['@date']       = date,
		['@type']       = type,
		['@sender']     = sender,
		['@receiver']   = receiver,
		['@amount']    	= amount,
		['@bankname']	= bankname
	})
end

function OnlineTransfert(Alter, amount)
	Alterb.money.AddBank(amount)
end

function OfflineTransfert(newAmount, steamid)
	MySQL.Sync.execute('UPDATE money SET `bank` = @bank WHERE steamid = @steamid', {
        ['@bank']       = newAmount,
        ['@steamid']    = steamid
    })
end

function GetPlayerRelatedToIban(iban)
	local account = MySQL.Sync.fetchAll("SELECT * FROM money WHERE iban = @iban", {
		['@iban'] = iban
	})

	if (account[1] == nil) then
		return (nil)
	end
	return (account[1])
end