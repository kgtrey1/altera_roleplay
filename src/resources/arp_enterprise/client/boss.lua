BossMenu = {
    main = 'arp_enterprise:BossMenu'
}

local MenuIsOpen = false

function RenderBossButtons(entName)
    ARP.Menu.Item.Button("Vendre l'entreprise", "Vendre l'entreprise", {}, true, {
        onSelected = function()
            TriggerServerEvent('arp_enterprise:SellEnterprise', entName)
            ARP.Menu.CloseAll()
        end
    }, nil)
end

function DrawBossMenu(entName)
    if (MenuIsOpen) then
        return
    end
    MenuIsOpen = true
    ARP.Menu.CloseAll()
    ARP.Menu.Visible(BossMenu.main, false)
    while (MenuIsOpen) do
        ARP.Menu.IsVisible(BossMenu.main, function()
            RenderBossButtons(entName)
        end, function() end, false)
        if (not ARP.Menu.GetVisibility(BossMenu.main, false)) then
			MenuIsOpen = false
		end
        Citizen.Wait(0)
    end
    MenuIsOpen = false
end

function OpenBossMenu(entName)
    print('here')
    if (MenuIsOpen) then
        return
    end
    ARP.TriggerServerCallback('arp_enterprise:OpenBossMenu', function(resp)
        if (resp == true) then
            DrawBossMenu(entName)
        end
    end, entName)
end

AddEventHandler('arp_enterprise:OpenBossMenu', OpenBossMenu)

function RegisterBossMenus()
    ARP.Menu.RegisterMenu(BossMenu.main, "Gestion Entreprise", "GESTION DE L'ENTREPRISE")
end