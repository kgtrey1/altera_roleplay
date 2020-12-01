--
-- ALTERA PROJECT, 2020
-- arp_licenses
-- File description:
-- fxmanifest
--

fx_version 'cerulean'
game 'gta5'
author 'kgtrey1'
description 'License system for Altera Roleplay'
version '0.50.0'

ui_page 'html/index.html'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'config.lua',
	'server.lua'
}

client_scripts {
	'config.lua',
	'client.lua'
}

files {
	'html/index.html',
	'html/assets/css/*.css',
	'html/assets/js/*.js',
	'html/assets/fonts/roboto/*.woff',
	'html/assets/fonts/roboto/*.woff2',
	'html/assets/fonts/justsignature/JustSignature.woff',
	'html/assets/images/*.png'
}