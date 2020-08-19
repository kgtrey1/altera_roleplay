-- Altera Register
-- Created by kgtrey1

fx_version      'bodacious'
game            'gta5'
description     'User registrar'
version         '0.2'

ui_page         'html/index.html'

server_scripts {
    '@mysql-async/lib/MySQL.lua'
}

client_scripts {
    'nui.lua'
}

files {
    'html/bootstrap.min.css',
    'html/bootstrap.min.js',
    'html/index.html',
    'html/index.js',
    'html/index.css',
    'html/logo.png',
    'html/bg.jpg'
}