fx_version 'cerulean'
games { 'gta5' }

author 'MaDHouSe'
description 'MH Screenshots - a admin tool if you want to know what your players are doeing.'
version '1.0'

shared_scripts {
    '@qb-core/shared/locale.lua',
    'locales/en.lua', -- change en to your language
    'config.lua',
}

client_scripts {
    'client/main.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
    'server/update.lua',
}

dependencies {
    'qb-core',
}

lua54 'yes'
