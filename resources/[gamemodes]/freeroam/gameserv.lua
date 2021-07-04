-- on server

AddEventHandler('playerDropped', function()
	TriggerClientEvent('refreshPlayerBlips', -1)
end)

RegisterServerEvent('playerActivated')
AddEventHandler('playerActivated', function()
	TriggerClientEvent('refreshPlayerBlips', -1)
end)

RegisterServerEvent('playerSpawned')
AddEventHandler('playerSpawned', function()
	TriggerClientEvent('refreshPlayerBlips', -1)
end)