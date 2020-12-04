BossMenu = {
    main = 'arp_enterprise:BossMenu'
}

function OpenBossMenu(entName)
    ARP.TriggerServerCallback('arp_enterprise:IsPlayerBoss', function(resp)
        if (resp == true) then
            DrawBossMenu(entName)
        end
    end, entName)
end

AddEventHandler('arp_enterprise:OpenBossMenu', OpenBossMenu)

function RegisterBossMenus()
    ARP.Menu.RegisterMenu(BossMenu.main, "Gestion Entreprise", "GESTION DE L'ENTREPRISE")
end