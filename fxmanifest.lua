fx_version 'cerulean';
game 'gta5';
lua54 'yes';

author 'GaDGeT#8987 & EmeraldCeat#6886 & AstrO#6741';
description 'FiveM drugs system inspired by esx_illeagal (esx_drugs)';
version '1.0.0';

client_scripts {
    'code/core/client.lua',
    'code/modules/**/client.lua'
};

server_scripts {
    'code/core/server.lua',
    'code/modules/**/server.lua'
};

shared_scripts {
    '@ox_lib/init.lua',

    'config/config.lua',
    'config/lang.lua'
};

dependencies {
    'ox_lib'
};