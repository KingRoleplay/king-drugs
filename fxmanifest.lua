fx_version 'cerulean';
game 'gta5';
lua54 'yes';
use_fxv2_oal 'yes';

author 'gadget2';
description 'FiveM drugs system inspired by esx_illeagal (esx_drugs)';
version '1.0.1';

client_script 'core/client.lua';
server_script 'core/server.lua';

shared_scripts {
    '@ox_lib/init.lua',

    'settings/settings.lua',
    'settings/lang.lua'
};
files {'modules/**/*.*'};

dependency 'ox_lib';