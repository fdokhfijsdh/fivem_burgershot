--[[ FX Information ]]--
fx_version 'cerulean'
games { 'gta5' }
lua54 'yes'

--[[ Resource Information ]]--
-- name "planethope_burgershot"
author "fdokhfijsdh"
description "BurgerShot Job Functionality"
version '1.0.1'

escrow_ignore {
    'config/*'
}

shared_scripts {
    '@es_extended/imports.lua',
    'config/*'
}

client_scripts {
    'client/*'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/*'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/styles.css',
    'html/script.js',
}

dependencies { 'es_extended', 'oxmysql' }