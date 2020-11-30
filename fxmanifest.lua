--
-- ALTERA PROJECT, 2020
-- arp_vehiclemanager
-- File description:
-- FX Manifest.
--

fx_version      'bodacious'
game            'gta5'
description     'Altera Framework - Vehicle management'
version         '0.9.0'
dependency      'arp_framework'
client_scripts {
    'config.lua',
    'client/main.lua'
}

server_scripts {
    'config.lua',
    'server/main.lua'
}