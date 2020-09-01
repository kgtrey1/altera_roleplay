-- Inventory
RegisterNetEvent('arp_framework:OnInventoryChange')
AddEventHandler('arp_framework:OnInventoryChange', function(list, weight)
    ARP.Player.inventory.list   = list
    ARP.Player.inventory.weight = weight
    print(json.encode(ARP.Player.inventory))
    TriggerEvent('arp_framework:InventoryChange')
end)

-- Money
RegisterNetEvent('arp_framework:OnCashChange')
AddEventHandler('arp_framework:OnCashChange', function(cash)
    ARP.Player.money.cash = cash
    TriggerEvent('arp_framework:CashChange')
    TriggerEvent('arp_hud:UpdatePlayerMoney', 'cash', cash)
end)

RegisterNetEvent('arp_framework:OnBankChange')
AddEventHandler('arp_framework:OnBankChange', function(bank)
    ARP.Player.money.bank = bank
    TriggerEvent('arp_framework:BankChange')
    TriggerEvent('arp_hud:UpdatePlayerMoney', 'bank', bank)
end)

RegisterNetEvent('arp_framework:OnDirtyChange')
AddEventHandler('arp_framework:OnDirtyChange', function(dirty)
    ARP.Player.money.dirty = dirty
    TriggerEvent('arp_framework:DirtyChange')
    TriggerEvent('arp_hud:UpdatePlayerMoney', 'dirty', dirty)
end)

RegisterNetEvent('arp_framework:OnBanknameChange')
AddEventHandler('arp_framework:OnBanknameChange', function(bankname)
    ARP.Player.money.bankname = bankname
end)

RegisterNetEvent('arp_framework:OnIbanChange')
AddEventHandler('arp_framework:OnIbanChange', function(iban)
    ARP.Player.money.iban = iban
end)

RegisterNetEvent('arp_framework:CmdSpawnVehicle')
AddEventHandler('arp_framework:CmdSpawnVehicle', function(model)
    local playerCoords = GetEntityCoords(GetPlayerPed(-1))
    local heading      = GetEntityHeading(GetPlayerPed(-1))

    ARP.World.SpawnVehicle(model, playerCoords, heading, function(vehicle)
        TaskWarpPedIntoVehicle(GetPlayerPed(-1), vehicle, -1)
    end)
end)

RegisterNetEvent('arp_framework:OnDropListChange')
AddEventHandler('arp_framework:OnDropListChange', function(drops, index, action)
    Drops = drops
    if (action == 'drop') then
        ARP.World.SpawnLocalObject(Drops[index].texture, {
            x = Drops[index].coords.x,
            y = Drops[index].coords.y,
            z = Drops[index].coords.z - 2.0
        }, function(newObj)
            SetEntityAsMissionEntity(newObj, true, false)
            PlaceObjectOnGroundProperly(newObj)
            Objects[index] = newObj
        end)
    else
        ARP.World.DeleteObject(Objects[index])
	    Objects[index] = nil
    end
end)