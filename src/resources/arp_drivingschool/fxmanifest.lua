fx_version 'cerulean'
game 'gta5'
author 'kgtrey1'
description 'Driving school system for Altera Roleplay (Fork from ESX_dmvschool)'
version '0.50.0'

server_scripts {
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'config.lua',
	'client/main.lua'
}

ui_page 'html/ui.html'

files {
	'html/ui.html',
	'html/logo.png',
	'html/dmv.png',
	'html/styles.css',
	'html/questions.js',
	'html/scripts.js',
	'html/debounce.min.js'
}

dependencies {
	'arp_framework',
	'arp_idcard'
}
