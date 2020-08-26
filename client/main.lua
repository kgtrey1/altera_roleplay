--
-- ALTERA PROJECT, 2020
-- ARP_personnalUI
-- File description:
-- Client side script
--

Config = {}

Config.Key = 166

ARP             = nil
MenuIsOpen      = false
MainMenu        = 'arp_personnalUI:Main'
InventoryMenu   = 'arp_personnalUI:Inventory'

TriggerEvent('arp_framework:FetchObject', function(obj)
    ARP = obj
end)

AddEventHandler('arp_framework:PlayerReady', function(obj)
    ARP.Player = obj
    StartMainThread()
end)

AddEventHandler('arp_framework:CloseAllMenus', function()
    MenuIsOpen = false
end)

function CreateMenuThread()
    ARP.Menu.CloseAll()
    MenuIsOpen = true
    ARP.Menu.Visible(MainMenu, false)
    while (MenuIsOpen) do
        ARP.Menu.IsVisible(InventoryMenu, function()
            ARP.Menu.Item.Button('MAITRE YODA', 'Options concernant l\'inventaire.', {}, true, {}, nil)
        end, function() end, true)
        ARP.Menu.IsVisible(MainMenu, function()
            ARP.Menu.Item.Button('Inventaire', 'Options concernant l\'inventaire.', {}, true, {}, InventoryMenu)
        end, function() end, false)
        if (not ARP.Menu.GetVisibility(MainMenu, false) and not ARP.Menu.GetVisibility(InventoryMenu, true)) then
            MenuIsOpen = false
        end
        Citizen.Wait(0)
    end
    print("exiting thread")
end

function StartMainThread()
    ARP.Menu.RegisterMenu(MainMenu, 'Menu perso', 'Choisissez une interaction')
    ARP.Menu.RegisterSubmenu(InventoryMenu, MainMenu, 'Inventaire', 'MENU INVENTAIRE')
    Citizen.CreateThread(function()
        while (true) do
            Citizen.Wait(0)
            if(IsControlJustPressed(1, Config.Key)) then
                if (MenuIsOpen) then
                    ARP.Menu.CloseAll()
                else
                    CreateMenuThread()
                end
            end
        end
    end)
end