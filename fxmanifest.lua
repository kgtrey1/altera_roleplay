--
-- ALTERA PROJECT, 2020
-- ARP_banking (forked from NewWayRP/new_banking)
-- File description:
-- FX Manifest.
--

fx_version      'bodacious'
game            'gta5'
description     'Altera Framework'
version         '0.0.5'

client_script {
    'config.lua',
    'client/client.lua'
}

dependency {
    'arp_framework'
}

--[[
server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'server.lua'
}]]

--[[
-- Uncomment the desired version 
ui_page('client/html/UI-fr.html') -- French UI
--ui_page('client/html/UI-en.html') -- English UI
--ui_page('client/html/UI-de.html') -- German UI

files {
	'client/html/UI-fr.html', -- French UI
	--'client/html/UI-en.html', -- English UI
	--'client/html/UI-de.html', -- German UI
    'client/html/style.css',
    'client/html/media/font/Bariol_Regular.otf',
    'client/html/media/font/Vision-Black.otf',
    'client/html/media/font/Vision-Bold.otf',
    'client/html/media/font/Vision-Heavy.otf',
    'client/html/media/img/bg.png',
    'client/html/media/img/circle.png',
    'client/html/media/img/curve.png',
    'client/html/media/img/fingerprint.png',
    'client/html/media/img/fingerprint.jpg',
    'client/html/media/img/graph.png',
    'client/html/media/img/logo-big.png',
    'client/html/media/img/logo-top.png'
}
]]
