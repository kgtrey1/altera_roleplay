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
    'server/main.lua'
}

client_script {
    'client/main.lua'
}

dependency {
    'arp_framework'
}