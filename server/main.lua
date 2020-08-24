
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
		TriggerClientEvent('arp_bank:Result', source, "success", "Retrait effectué.")
	end
	cb(Alter.money.GetBank())
end)

ARP.RegisterServerCallback('arp_bank:Transfer', function(source, cb, amout, rib)
	local Altera 	= ARP.GetPlayerById(source)
	local Alterb 	= nil
	local ribObject = nil

	amount = tonumber(amount)
	if (amount == nil or amount <= 0 or amount > Altera.money.GetBank()) then
		TriggerClientEvent('arp_bank:Result', source, "error", "Montant invalide.")
	else
		steamid = GetPlayerRelatedToRib(rib)
		if (ribObject == nil) then
			TriggerClientEvent('arp_bank:Result', source, "error", "Impossible d'effectuer un transfert vers ce RIB.")
		else
			Altera.money.RemoveBank(amount)
			Alterb = ARP.GetPlayerBySteamid(steamid)
			if (Alterb == nil) then
				OfflineTransfert((tonumber(ribObject.bank) + amount), steamid)
			else
				OnlineTransfert(Alterb, amount)
			end
			TriggerClientEvent('arp_bank:Result', source, "success", "Transfert effectué.")
		end
	end
	cb(Alter.money.GetBank())
end)

local function OnlineTransfert(Alter, amount)
	Alterb.money.AddBank(amount)
end

local function OfflineTransfert(newAmount, steamid)
	MySQL.Sync.execute('UPDATE money SET `bank` = @bank WHERE steamid = @steamid', {
        ['@bank']       = newAmount,
        ['@steamid']    = steamid
    })
end

function GetPlayerByRib(rib)
	local account = MySQL.Sync.fetchAll("SELECT * FROM money WHERE rib = @rib", {
		['@rib'] = rib
	})

	if (account[1] == nil) then
		return (nil)
	end
	return (account[1])
end