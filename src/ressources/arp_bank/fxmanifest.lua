--
-- ALTERA PROJECT, 2020
-- ARP_banking (forked from NewWayRP/new_banking)
-- File description:
-- FX Manifest.
--

fx_version      'bodacious'
game            'gta5'
description     'Altera banking system'
version         '0.0.5'

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'server/main.lua'
}

client_script {
    'config.lua',
    'client/main.lua'
}

dependency {
    'arp_framework'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/js/index.js',
    'html/css/style.css',
    'html/css/Bariol_Regular.otf',
    'html/css/Vision-Black.otf',
    'html/css/Vision-Bold.otf',
    'html/css/Vision-Heavy.otf',
    'html/img/graph.png',
    'html/img/fleeca/circle-fleeca.png',
    'html/img/fleeca/curve-fleeca.png',
    'html/img/fleeca/fingerprint-fleeca.jpg',
    'html/img/fleeca/logo-big-fleeca.png',
    'html/img/fleeca/logo-top-fleeca.png',
    'html/img/maze/circle-maze.png',
    'html/img/maze/curve-maze.png',
    'html/img/maze/fingerprint-maze.jpg',
    'html/img/maze/logo-big-maze.png',
    'html/img/maze/logo-top-maze.png'
}