function SafeDeposit(enterprise, item, amount)
	local _source 	= source
	local Alter		= ARP.GetPlayerById(_source)
    local Item		= ARP.Item.GetItem(item)
    local inventory = Alter.GetInventory()

	if (ENT[enterprise] == nil or not AlterCanOpenSafe(Alter, enterprise) or Item == nil or amount < 1) then
		print("illegal")
	elseif (inventory.list[item] == nil or inventory.list[item].amount < amount) then
		print("also illegal")
	elseif (not Alter.CanCarryItem(item, amount)) then
		print("No space")
    else
        if (ENT[enterprise].safe[item] == nil) then
			ENT[enterprise].safe[item] 		   	= {}
			ENT[enterprise].safe[item].name    	= Item.name
			ENT[enterprise].safe[item].label   	= Item.label
			ENT[enterprise].safe[item].amount  	= amount
        else
            ENT[enterprise].safe[item].amount = ENT[enterprise].safe[item].amount + amount
        end
		Alter.inventory.RemoveItem(item, amount)
	end
	return
end

RegisterNetEvent('arp_enterprise:DepositItem')
AddEventHandler('arp_enterprise:DepositItem', SafeDeposit)

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

ARP.RegisterServerCallback('arp_enterprise:OpenSafe', function(source, cb, enterprise)
	Alter = ARP.GetPlayerById(source)
	if (Alter.job.GetEnterprise() == enterprise and Alter.job.GetGrade() > 1) then
		cb(true, ENT[enterprise].safe)
	else
		cb(false, nil)
	end
end)