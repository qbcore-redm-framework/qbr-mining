game 'rdr3'
fx_version 'adamant'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

author 'Infernalz'
description 'qbr-mining'
version '1.0.0'
lua54 'yes'

client_script {
    'client/*.lua'
}

server_scripts {'server/*.lua'}

shared_scripts {'@qbr-core/shared/locale.lua', 'config.lua', 'locales/*.lua' }

