-- Altera Framework
-- Created by kgtrey1

fx_version      'bodacious'
game            'gta5'
description     'Altera Framework'
version         '0.0.5'

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'config.lua',
    'server/class.lua',
    'server/shared.lua',
    'server/main.lua'
}

client_scripts {
    'client/class.lua',
    'client/shared.lua',
    'client/main.lua'
}

exports         'ARPFetchObject'
server_exports  'ARPFetchObject'