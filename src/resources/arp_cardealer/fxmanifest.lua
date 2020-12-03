--
-- ALTERA PROJECT, 2020
-- arp_cardealer
-- File description:
-- fxmanifest
--

fx_version 'cerulean'
game 'gta5'
author 'kgtrey1'
description 'Car dealer for Altera Roleplay'
version '0.50.0'

server_scripts {
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'config.lua',
	'client/main.lua'
}

dependencies {
	'arp_framework',
	'arp_enterprise'
}