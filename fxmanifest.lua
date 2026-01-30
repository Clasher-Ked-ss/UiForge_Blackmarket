fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'UiForge - Ked.ss'
description 'Advanced Blackmarket System for FiveM'
version '1.0.0'
github 'https://github.com/Clasher-Ked-ss/UiForge_Blackmarket'

shared_scripts {'shared/*.lua', 'Config.lua', 'bridge/framework.lua'}

client_scripts {'client/*.lua'}

server_scripts {'@oxmysql/lib/MySQL.lua', 'server/*.lua'}

ui_page 'web/index.html'

files {'web/js/*.js', 'web/css/*.css', 'web/index.html', 'web/img/*.png', 'web/img/*.svg', 'web/audio/*.ogg'}
