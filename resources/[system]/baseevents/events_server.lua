RegisterServerEvent('baseevents:onPlayerDied')
RegisterServerEvent('baseevents:onPlayerKilled')
RegisterServerEvent('baseevents:onPlayerWasted')
RegisterServerEvent('baseevents:enteredVehicle')
RegisterServerEvent('baseevents:leftVehicle')
RegisterServerEvent('baseevents:printToServer')

AddEventHandler('baseevents:onPlayerDied', function(player, position)
    print('[Dead] Player ' .. GetPlayerName(player) .. ' died.')
end)

AddEventHandler('baseevents:onPlayerKilled', function(player, data)
    print('[Dead] Player ' .. GetPlayerName(player) .. ' got killed by ' .. GetPlayerName(data.killer) .. ' with reason ' .. tostring(data.reason) .. '.')
end)

AddEventHandler('baseevents:printToServer', function(msg)
    print(msg)
end)

-- to silence warnings
RegisterServerEvent('playerJoining')
AddEventHandler('playerJoining', function()
end)

RegisterServerEvent('sessionInitialized')
AddEventHandler('sessionInitialized', function()
end)