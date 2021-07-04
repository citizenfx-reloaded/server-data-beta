resource_type 'gametype' { name = 'Freeroam' }

description 'Gamemode from Dutchi.'

dependencies {
    "spawnmanager",
    "mapmanager"
}

client_script 'gameclient.lua'
client_script 'commandclient.lua'
server_script 'gameserv.lua'
server_script 'commandserv.lua'