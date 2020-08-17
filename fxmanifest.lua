-- Altera Framework
-- Created by kgtrey1

fx_version      'adamant'
game            'gta5'
description     'Altera Framework'
version         '0.0.1'

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'config.lua',
    'server/class.lua',
    'server/main.lua'
}

client_scripts {
    'src/class.lua'
}