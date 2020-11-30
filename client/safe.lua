SafeMenu			= {
	main 	 = 'arp_enterprise:SafeMenu',
	withdraw = 'arp_enterprise:SafeMenu.Withdraw',
	deposit  = 'arp_enterprise:SafeMenu.Deposit'
}
SafeMenuIsOpen		= false
SafeContent			= nil
SafeHasContent      = false
InventoryHasContent = false
InventoryContent    = nil

local function DoesInventoryHasContent()
    for k, v in pairs(InventoryContent) do
        if (v.amount > 0) then
            return (true)
        end
    end
    return (false)
end

local function DoesSafeHasContent()
    for k, v in pairs(SafeContent) do
        if (v.amount > 0) then
            return (true)
        end
    end
    return (false)
end

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
    for k, v in pairs(InventoryContent) do
        if (v.amount > 0) then
            local itemList = GenerateItemList(v.amount)

			ARP.Menu.Item.List(v.label, itemList, 1, '', {}, true, {
                onSelected = function(Index, Item)
					TriggerServerEvent('arp_enterprise:DepositItem', ARP.Player.job.GetEnterprise(), v.name, Index)
					ARP.Menu.CloseAll()
				end
			})
		end
    end
end

function DrawSafeMenuWithdrawal()
	for k, v in pairs(SafeContent) do
        if (v.amount > 0) then
			local itemList = GenerateItemList(v.amount)

			ARP.Menu.Item.List(v.label, itemList, 1, '', {}, true, {
                onSelected = function(Index, Item)
                    print(v.name)
                    print(Index)
					TriggerServerEvent('arp_enterprise:WithdrawItem', ARP.Player.job.GetEnterprise(), v.name, Index)
					ARP.Menu.CloseAll()
				end
			})
		end
    end
end

function DrawSafeMenu()
    if (SafeMenuIsOpen) then
        return
    end
	ARP.Menu.CloseAll()
    ARP.Menu.Visible(SafeMenu.main, false)
    InventoryContent = ARP.Player.GetInventory()
    SafeHasContent = DoesSafeHasContent()
    InventoryHasContent = DoesInventoryHasContent()
    SafeMenuIsOpen = true
	Citizen.CreateThread(function()
        while (SafeMenuIsOpen) do
            Citizen.Wait(0)
            ARP.Menu.IsVisible(SafeMenu.withdraw, function()
                DrawSafeMenuWithdrawal()
            end, function() end, true)
            ARP.Menu.IsVisible(SafeMenu.deposit, function()
                DrawSafeMenuDeposit()
            end, function() end, true)
            ARP.Menu.IsVisible(SafeMenu.main, function()
                if (SafeHasContent) then
                    ARP.Menu.Item.Button('Retirer', 'Prendre des objets.', {}, true, {}, SafeMenu.withdraw)
                else
                    ARP.Menu.Item.Button('Retirer', 'Le coffre est vide.', {RightBadge = ARP.Menu.BadgeStyle.Lock}, false, {}, nil)
                end
                if (InventoryHasContent) then
                    ARP.Menu.Item.Button('Déposer', 'Déposer des objets.', {}, true, {}, SafeMenu.deposit)
                else
                    ARP.Menu.Item.Button('Déposer', "Votre inventaire est vide.", {RightBadge = ARP.Menu.BadgeStyle.Lock}, false, {}, nil)
                end
            end, function() end, false)
            if (not ARP.Menu.GetVisibility(SafeMenu.main, false)
            and not ARP.Menu.GetVisibility(SafeMenu.withdraw, true)
            and not ARP.Menu.GetVisibility(SafeMenu.deposit, true)) then
                SafeMenuIsOpen = false
            end
        end
        print("EXITING SafeMenu thread")
	end)
end

function RegisterSafeMenus()
    ARP.Menu.RegisterMenu(SafeMenu.main, "Coffre entreprise", "Coffre de l'entreprise")
    ARP.Menu.RegisterSubmenu(SafeMenu.deposit, SafeMenu.main, "Depot", "DEPOSER UN OBJET")
    ARP.Menu.RegisterSubmenu(SafeMenu.withdraw, SafeMenu.main, "Retrait", "RETIRER UN OBJET")
end

AddEventHandler('arp_enterprise:OpenSafeMenu', function(enterprise)
	ARP.TriggerServerCallback('arp_enterprise:OpenSafe', function(resp, data)
		if (resp == true) then
			SafeContent = data
			DrawSafeMenu()
		end
	end, enterprise)
end)