--
-- ALTERA PROJECT, 2020
-- ARP_Skin
-- File description:
-- FX Manifest.
--

fx_version      'bodacious'
game            'gta5'
description     'Skin management'
version         '0.4'

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'server/main.lua'
}

client_scripts {
    'config.lua',
    'client/main.lua'
}

dependency {
    'skinchanger',
    'arp_framework',
}