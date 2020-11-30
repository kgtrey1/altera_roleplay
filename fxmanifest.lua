--
-- ALTERA PROJECT, 2020
-- ARP_Fuel
-- File description:
-- FX Manifest.
--

fx_version      'bodacious'
game            'gta5'
description     'Altera fuel system'
version         '0.0.1'
dependency      'arp_framework'
server_scripts  {
    'config.lua',
    'server/main.lua'
}
client_scripts  {
    'config.lua',
    'client/main.lua'
}