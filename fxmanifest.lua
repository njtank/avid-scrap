fx_version 'cerulean'
game 'gta5'

author 'njtank'
description 'avid-scrap'
version '1.0.0'

-- Dependencies
dependencies {
    'ox_inventory',  
    'ox_target',     
    'ox_lib'         
}

-- Shared Scripts
shared_scripts {
    '@ox_lib/init.lua'
}

-- Client Script
client_scripts {
    'client.lua'
}

-- Server Script
server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua'
}

-- Lua Version
lua54 'yes'
