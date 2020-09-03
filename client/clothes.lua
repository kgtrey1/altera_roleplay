--
-- ALTERA PROJECT, 2020
-- ARP_Stylizer
-- File description:
-- Clothes script.
--

ClothMenuIsOpen = false
ClothMenu       = {
    main    = 'arp_stylizer:ClothMenu',
    buy     = 'arp_stylizer:ClothMenuBuy',
    save    = 'arp_stylizer:ClothMenuSave',
    outfit  = 'arp_stylizer:ClothMenuOutfit'
}

local function DrawBuyMenu()
    for i = 1, #Clothes, 1 do
        if (Clothes[i].restricted) then
            ARP.Menu.Item.List(Clothes[i].Component.label, Clothes[i].ListF, 1, '', {}, true, {
                onListChange = function(index, item)
                    TriggerEvent('skinchanger:change', Clothes[i].Component.name, Clothes[i].ListR[index])
                end, onSelected = function(index, item)
                    print(string.format("real offset: %d, price: %d", Clothes[i].ListR[index], Clothes[i].prices[index]))
                end
            })
        else
            ARP.Menu.Item.List(Clothes[i].Component.label, Clothes[i].List, 1, '', {}, true, {
                onListChange = function(index, item)
                    TriggerEvent('skinchanger:change', Clothes[i].Component.name, index)
                end, onSelected = function(index, item)
                    
                end
            })
        end
    end
end

function DrawClothesMenu()
    ARP.Menu.CloseAll()
    ARP.Menu.Visible(ClothMenu.main, false)
    ClothMenuIsOpen = true
    while (ClothMenuIsOpen) do
        Citizen.Wait(0)
        ARP.Menu.IsVisible(ClothMenu.buy, function()
            DrawBuyMenu()
		end, function() end, true)
        ARP.Menu.IsVisible(ClothMenu.main, function()
            ARP.Menu.Item.Button('Acheter des vêtements', '', {}, true, {}, ClothMenu.buy)
            --ARP.Menu.Item.Button('Sauvegarder la tenue', '', {}, true, {}, ClothMenu.save)
            --ARP.Menu.Item.Button('Voir les tenues sauvegardées', '', {}, true, {}, ClothMenu.outfit)
		end, function() end, false)
    end
    ClothMenuIsOpen = false
end

function RegisterClothMenus()
    ARP.Menu.RegisterMenu(ClothMenu.main, 'Vetements', "MENU D'INTERACTION")
    ARP.Menu.RegisterSubmenu(ClothMenu.buy, ClothMenu.main, 'Vetements', "MENU D'ACHAT")
    ARP.Menu.RegisterSubmenu(ClothMenu.save, ClothMenu.main, 'Vetements', "MENU DE TENUES")
    ARP.Menu.RegisterSubmenu(ClothMenu.outfit, ClothMenu.main, 'Vetements', "MENU DE TENUES")
end

Citizen.CreateThread(function()
    while (true) do
        Citizen.Wait(0)
        
    end
end)