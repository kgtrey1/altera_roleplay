--
-- ALTERA PROJECT, 2020
-- ARP_Enterprise
-- File description:
-- Server side script
--

ENT = {}
ARP = nil

function AlterCanOpenSafe(Alter, enterprise)
	if (Alter.job.GetEnterprise() == enterprise and Alter.job.GetGrade() > 1) then
		return (true)
	end
	return (false)
end

TriggerEvent('arp_framework:FetchObject', function(Object)
	ARP = Object
end)

function DeserializeSafe(safe)
	local newSafe 		= {}
	local Item = nil

	for k, v in pairs(safe) do
		item = ARP.Item.GetItem(k)
		if (item ~= nil) then
			newSafe[k] = {}
			newSafe[k].name   = k
			newSafe[k].label  = item.label
			newSafe[k].amount = v
		end
	end
	return (newSafe)
end

function SafeWithdrawal(enterprise, item, amount)
	local _source 	= source
	local Alter		= ARP.GetPlayerById(_source)
	local Item		= ARP.Item.GetItem(item)

	if (ENT[enterprise] == nil or not AlterCanOpenSafe(Alter, enterprise) or Item == nil or amount < 1) then
		print("illegal")
	elseif (ENT[enterprise].safe[item] == nil or ENT[enterprise].safe[item].amount < amount) then
		print("also illegal")
	else
		ENT[enterprise].safe[item].amount = ENT[enterprise].safe[item].amount - amount
		Alter.inventory.AddItem(item, amount)
	end
	return
end

RegisterNetEvent('arp_enterprise:WithdrawItem')
AddEventHandler('arp_enterprise:WithdrawItem', SafeWithdrawal)

ARP.RegisterServerCallback('arp_enterprise:GetEnterpriseData', function(source, cb, name)
	cb(ENT[name])
end)

ARP.RegisterServerCallback('arp_entreprise:OpenSafe', function(source, cb, enterprise)
	Alter = ARP.GetPlayerById(source)
	if (Alter.job.GetEnterprise() == enterprise and Alter.job.GetGrade() > 1) then
		cb(true, ENT[enterprise].safe)
	else
		cb(false, nil)
	end
end)

MySQL.ready(function()
	MySQL.Async.fetchAll('SELECT * from enterprises', {}, function(result)
        for i = 1, #result, 1 do
			ENT[result[i].name] = {}
			ENT[result[i].name].name 	 = result[i].name
			ENT[result[i].name].label	 = result[i].label
			ENT[result[i].name].money	 = result[i].money
			ENT[result[i].name].for_sale = result[i].for_sale
			ENT[result[i].name].public	 = result[i].public
			ENT[result[i].name].safe	 = DeserializeSafe(json.decode(result[i].safe))
        end
    end)
end)