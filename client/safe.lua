SafeMenu			= {
	main 	 = 'arp_enterprise:SafeMenu',
	withdraw = 'arp_enterprise:SafeMenu.Withdraw',
	deposit  = 'arp_enterprise:SafeMenu.Deposit'
}
SafeMenuIsOpen		= false
SafeContent			= nil

function GenerateItemList(size)
    local i    = 1
    local list = {}

    while (i <= size) do
        table.insert(list, i)
        i = i + 1
    end
    return (list)
end

function DrawSafeMenuDeposit()

end

function DrawSafeMenuWithdrawal()
	for k, v in pairs(SafeContent) do
		if (v.amount > 0) then
			local itemList = GenerateItemList(v)

			ARP.Menu.Item.List(v.label, itemList, 1, '', {}, true, {
				onSelected = function(Index, Item)
					TriggerServerEvent('arp_enterprise:WithdrawItem', ARP.Player.job.GetEnterprise(), v.name, Index)
					ARP.Menu.CloseAll()
				end
			})
		end
    end
end

function DrawSafeMenu()
	ARP.Menu.CloseAll()
    ARP.Menu.Visible(SafeMenu.main, false)
    SafeMenuIsOpen = true
	Citizen.CreateThread(function()
        while (SafeMenuIsOpen) do
            Citizen.Wait(0)
			ARP.Menu.IsVisible(MainMenu, function()
				ARP.Menu.Item.Button('Retirer', 'Prendre des objets.', {}, true, {}, SafeMenu.withdraw)
				ARP.Menu.Item.Button('Déposer', 'Déposer des objets.', {}, true, {}, SafeMenu.deposit)
			end, function() end, false)
		end
	end)
end

AddEventHandler('arp_enterprise:OpenSafeMenu', function(enterprise)
	ARP.TriggerServerCallback('arp_enterprise:OpenSafe', function(resp, data)
		if (resp == true) then
			SafeContent = data
			DrawBossMenu()
		end
	end, enterprise)
end)