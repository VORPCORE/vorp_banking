fx_version "cerulean"
game "rdr3"
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

author '@outsider | Inital Author : RobiZona#0001'

description 'Bank system VORP'
lua54 'yes'

shared_scripts {
    'shared/language.lua',
    'config.lua'
}

client_scripts {
    'client/client.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/services.lua',
    'server/server.lua',
}

--dont touch
version '1.9'
vorp_checker 'yes'
vorp_name '^4Resource version Check^3'
vorp_github 'https://github.com/VORPCORE/vorp_banking'
