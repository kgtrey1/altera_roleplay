--
-- ALTERA PROJECT, 2020
-- ARP_personnalUI
-- File description:
-- Client side script
--

Config = {}

Config.Key = 166

ARP                 = nil
MenuIsOpen          = false
MainMenu            = 'arp_personnalUI:Main'

Inventory           = {
    Menu        = 'arp_personnalUI:Inventory',
    Selected    = 'arp_personnalUI:Inventory.Selected',
    Item        = nil
}

Wallet = {
    Menu = 'arp_ui:Wallet'
}

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

function RenderWallet()
    local licenses = ARP.Player.licenses.GetLicenses()

    if (licenses.idcard and licenses.hasidcard) then
        ARP.Menu.Item.Button("Voir ma carte d'identité", '', {}, true, {
            onSelected = function()
                local type = 'idcard'
                TriggerServerEvent('arp_licenses:ShowLicense', 'self', 'idcard')
            end
        }, nil)
        ARP.Menu.Item.Button("Montrer ma carte d'identité", '', {}, true, {
            onSelected = function()
                local player, distance = ARP.World.GetClosestPlayer()

                if (distance < 3) then
                    TriggerServerEvent('arp_licenses:ShowLicense', player, 'idcard')
                end
            end
        }, nil)
    else
        ARP.Menu.Item.Button("Voir ma carte d'identité", '', {RightBadge = ARP.Menu.BadgeStyle.Lock}, true, {}, nil)
        ARP.Menu.Item.Button("Montrer ma carte d'identité", '', {RightBadge = ARP.Menu.BadgeStyle.Lock}, true, {}, nil)
    end
    if (licenses.car or licenses.bike or licenses.truck and licenses.hasdriving) then
        ARP.Menu.Item.Button("Voir mon permis de conduire", '', {}, true, {
            onSelected = function()
                TriggerServerEvent('arp_licenses:ShowLicense', nil, 'driving')
            end
        }, nil)
        ARP.Menu.Item.Button("Montrer mon permis de conduire", '', {}, true, {
            onSelected = function()
                local player, distance = ARP.World.GetClosestPlayer()

                if (distance < 3) then
                    TriggerServerEvent('arp_licenses:ShowLicense', player, 'driving')
                end
            end
        }, nil)
    else
        ARP.Menu.Item.Button("Voir mon permis de conduire", '', {RightBadge = ARP.Menu.BadgeStyle.Lock}, true, {}, nil)
        ARP.Menu.Item.Button("Montrer mon permis de conduire", '', {RightBadge = ARP.Menu.BadgeStyle.Lock}, true, {}, nil)
    end
    if (licenses.firearms and licenses.hasfirearms) then
        ARP.Menu.Item.Button("Voir mon permis de port d'arme", '', {}, true, {
            onSelected = function()
                TriggerServerEvent('arp_licenses:ShowLicense', nil, 'driving')
            end
        }, nil)
        ARP.Menu.Item.Button("Montrer mon permis de port d'arme", '', {}, true, {
            onSelected = function()
                local player, distance = ARP.World.GetClosestPlayer()

                if (distance < 3) then
                    TriggerServerEvent('arp_licenses:ShowLicense', player, 'driving')
                end
            end
        }, nil)
    else
        ARP.Menu.Item.Button("Voir mon permis de port d'arme", '', {RightBadge = ARP.Menu.BadgeStyle.Lock}, true, {}, nil)
        ARP.Menu.Item.Button("Montrer mon permis de port d'arme", '', {RightBadge = ARP.Menu.BadgeStyle.Lock}, true, {}, nil)
    end
end

function GenerateIndexList(size)
    local i    = 1
    local list = {}

    while (i <= size) do
        table.insert(list, i)
        i = i + 1
    end
    return (list)
end

function OnItemSelected()
    local offsetList = GenerateIndexList(Inventory.Item.amount)

    if (Inventory.Item.usable) then
        ARP.Menu.Item.Button("Utiliser", '', {}, true, {}, nil)
    else
        ARP.Menu.Item.Button("Utiliser", '', {RightBadge = ARP.Menu.BadgeStyle.Lock}, true, {}, nil)
    end
    ARP.Menu.Item.List("Donner", offsetList, 1, '', {}, true, {
        onSelected = function()
            ARP.Menu.GoBack()
        end
    })
    ARP.Menu.Item.List("Jeter", offsetList, 1, '', {}, true, {
        onSelected = function(Index, Item)
            local coords = GetEntityCoords(GetPlayerPed(-1))
            print(json.encode(Inventory.Item))
            TriggerServerEvent('arp_framework:OnItemDrop', Inventory.Item.name, tonumber(Index), vector3(coords.x + 2, coords.y, coords.z))
            ARP.Menu.GoBack()
        end
    })
end

function GenerateInventory()
    local inventory = ARP.Player.GetInventory()
    for k, v in pairs(inventory) do
        ARP.Menu.Item.Button(string.format("%s x%d", v.label, v.amount), '', {}, true, {
            onSelected = function()
                Inventory.Item = v
            end
        }, Inventory.Selected)
    end
end

function CreateMenuThread()
    ARP.Menu.CloseAll()
    MenuIsOpen = true
    ARP.Menu.Visible(MainMenu, false)
    while (MenuIsOpen) do

        ARP.Menu.IsVisible(Wallet.Menu, function()
            RenderWallet()
        end, function() end, true)        

        ARP.Menu.IsVisible(Inventory.Selected, function()
            OnItemSelected()
        end, function() end, true)

        ARP.Menu.IsVisible(Inventory.Menu, function()
            GenerateInventory()
        end, function() end, true)

        ARP.Menu.IsVisible(MainMenu, function()
            ARP.Menu.Item.Button('Inventaire', 'Options concernant l\'inventaire.', {}, true, {}, Inventory.Menu)
            ARP.Menu.Item.Button('Portefeuille', '', {}, true, {}, Wallet.Menu)
        end, function() end, false)

        if (not ARP.Menu.GetVisibility(MainMenu, false)
        and not ARP.Menu.GetVisibility(Inventory.Menu, true)
        and not ARP.Menu.GetVisibility(Inventory.Selected, true)
        and not ARP.Menu.GetVisibility(Wallet.Menu, true)) then
            MenuIsOpen = false
        end
        Citizen.Wait(0)
    end
    print("exiting thread")
end

function StartMainThread()
    ARP.Menu.RegisterMenu(MainMenu, 'Menu perso', 'Choisissez une interaction')
    ARP.Menu.RegisterSubmenu(Inventory.Menu, MainMenu, 'Inventaire', 'MENU INVENTAIRE')
    ARP.Menu.RegisterSubmenu(Inventory.Selected, MainMenu, 'Inventaire', 'MENU OBJET')
    ARP.Menu.RegisterSubmenu(Wallet.Menu, MainMenu, 'Portefeuille', 'PORTEFEUILLE')
    Citizen.CreateThread(function()
        while (true) do
            Citizen.Wait(5)
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