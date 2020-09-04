--
-- ALTERA PROJECT, 2020
-- ARP_Stylizer
-- File description:
-- FX Manifest.
--

fx_version      'bodacious'
game            'gta5'
description     'Altera personnalisation script'
version         '0.0.1'
dependency      {
    'arp_framework',
    'skinchanger'
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'server/main.lua'
}

client_script {
    'config.lua',
    'client/main.lua',
    'client/clothes.lua'
}