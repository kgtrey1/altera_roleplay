-- Inventory
RegisterNetEvent('arp_framework:OnInventoryChange')
AddEventHandler('arp_framework:OnInventoryChange', function(list)
    ARP.Player.inventory.list = list
    print(json.encode(list))
    TriggerEvent('arp_framework:InventoryChange')
end)

-- Money
RegisterNetEvent('arp_framework:OnCashChange')
AddEventHandler('arp_framework:OnCashChange', function(cash)
    ARP.Player.money.cash = cash
    TriggerEvent('arp_framework:CashChange')
end)

RegisterNetEvent('arp_framework:OnBankChange')
AddEventHandler('arp_framework:OnBankChange', function(bank)
    ARP.Player.money.bank = bank
    TriggerEvent('arp_framework:BankChange')
end)

RegisterNetEvent('arp_framework:OnDirtyChange')
AddEventHandler('arp_framework:OnDirtyChange', function(dirty)
    ARP.Player.money.dirty = dirty
    TriggerEvent('arp_framework:DirtyChange')
end)

RegisterNetEvent('arp_framework:OnBanknameChange')
AddEventHandler('arp_framework:OnBanknameChange', function(bankname)
    ARP.Player.money.bankname = bankname
end)

RegisterNetEvent('arp_framework:OnIbanChange')
AddEventHandler('arp_framework:OnIbanChange', function(iban)
    ARP.Player.money.iban = iban
end)