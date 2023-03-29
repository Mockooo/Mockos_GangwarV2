fx_version 'bodacious'
game 'gta5'

author 'Mocko'
version '1.0.0'

client_script 'client.lua'
server_script 'server.lua'
server_script '@oxmysql/lib/MySQL.lua'
shared_script 'config.lua'
shared_script '@es_extended/imports.lua'
ui_page "html/ui.html"
files {
    'html/ui.html',
    'html/css/main.css',
    'html/countdown.js',
    'html/debounce.min.js',
    'html/debug.log',
    'html/script.js',
    'html/ui.js'
}