fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'GaDGeT#8987 & EmeraldCeat#6886'
description 'FiveM drugs system inspired by esx_illeagal (esx_drugs)'
version '1.0.0'

client_script {
    'client/main.lua',
    'client/modules/**/*.lua'
};

server_script {
    'server/main.lua',
    'server/modules/**/*.lua'
};

shared_script {
    '@ox_lib/init.lua',

    'config/config.lua',
    'config/lang.lua'
};

dependency {
    'ox_lib',
};