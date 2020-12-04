--
-- ALTERA PROJECT, 2020
-- ARP_Enterprise
-- File description:
-- Server side script
--

ENT = {}
ARP = nil

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

ARP.RegisterServerCallback('arp_enterprise:GetEnterpriseData', function(source, cb, name)
	cb(ENT[name])
end)

MySQL.ready(function()
	MySQL.Async.fetchAll('SELECT * from enterprises', {}, function(result)
        for i = 1, #result, 1 do
			ENT[result[i].name] = {}
			ENT[result[i].name].jobname	 	= result[i].jobname
			ENT[result[i].name].name 	 	= result[i].name
			ENT[result[i].name].label	 	= result[i].label
			ENT[result[i].name].money	 	= result[i].money
			ENT[result[i].name].for_sale 	= result[i].for_sale
			ENT[result[i].name].sell_price	= result[i].sale_price
			ENT[result[i].name].safe	 	= DeserializeSafe(json.decode(result[i].safe))
			ENT[result[i].name].employees 	= {}
        end
    end)
end)

ARP.RegisterServerCallback('arp_enterprise:OpenBossMenu', function(source, cb, entName)
	local Alter 			= ARP.GetPlayerById(source)
	local playerEnterprise 	= Alter.job.GetEnterprise()
	local playerGradeName 	= Alter.job.GetGradeName()

	if (playerEnterprise ~= entName and playerGradeName ~= 'boss') then
		print(string.format('ARP Enterprise> %s tried to access boss menu of enterprise %s without privilege. (Enterprise: %s ; Grade: %s)', Alter.GetSteamid(), entName, playerEnterprise, playerGradeName))
		cb(false)
	else
		cb(true)
	end
end)