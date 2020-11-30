BossMenu = {
    main = 'arp_enterprise:BossMenu'
}

function RegisterBossMenus()
    ARP.Menu.RegisterMenu(SafeMenu.main, "Gestion Entreprise", "GESTION DE L'ENTREPRISE")
    ARP.Menu.RegisterSubmenu(SafeMenu.deposit, SafeMenu.main, "Depot", "DEPOSER UN OBJET")
    ARP.Menu.RegisterSubmenu(SafeMenu.withdraw, SafeMenu.main, "Retrait", "RETIRER UN OBJET")
end