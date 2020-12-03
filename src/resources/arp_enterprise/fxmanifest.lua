--
-- ALTERA PROJECT, 2020
-- ARP_Enterprise
-- File description:
-- FX Manifest.
--

fx_version      'bodacious'
game            'gta5'
description     'Altera enterprise system'
version         '0.0.1'

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'server/main.lua',
    'server/acl.lua',
    'server/sale.lua',
    'server/safe.lua'
}

client_script {
    'client/sale.lua',
    'client/safe.lua',
    'client/main.lua'
}

dependency {
    'arp_framework'
}