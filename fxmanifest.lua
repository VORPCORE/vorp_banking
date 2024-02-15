fx_version "adamant"
game 'rdr3'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

author 'VORP edit by RobiZona#0001'
description 'Bank system VORP'

client_scripts {
    'client/client.lua'
}

shared_scripts {
    'shared/language.lua',
    'config.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/services.lua',
    'server/server.lua',
}

--dont touch
version '1.7'
vorp_checker 'yes'
vorp_name '^4Resource version Check^3'
vorp_github 'https://github.com/VORPCORE/vorp_banking'
