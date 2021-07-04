local playerBlips = {}

AddEventHandler('onClientMapStart', function()
    exports.spawnmanager:setAutoSpawn(true)
    exports.spawnmanager:forceRespawn()

	--SetNetworkWalkModeEnabled(false)
end)

RegisterNetEvent('refreshPlayerBlips')
AddEventHandler('refreshPlayerBlips', function()
	local players = GetPlayers()

	for _, player in ipairs(players) do
		if(DoesBlipExist(playerBlips[GetPlayerServerId(player)])) then
			RemoveBlip(playerBlips[GetPlayerServerId(player)])
		end

		if(GetPlayerName(player) ~= GetPlayerName(GetPlayerId()) and IsNetworkPlayerActive(player)) then
			playerBlips[GetPlayerServerId(player)] = AddBlipForChar(GetPlayerChar(player))
			ChangeBlipSprite(playerBlips[GetPlayerServerId(player)], 0)
			ChangeBlipScale(playerBlips[GetPlayerServerId(player)], 0.90)
			ChangeBlipPriority(playerBlips[GetPlayerServerId(player)], 3)
			ChangeBlipColour(playerBlips[GetPlayerServerId(player)], GetPlayerColour(player))
			ChangeBlipNameFromAscii(playerBlips[GetPlayerServerId(player)], GetPlayerName(player))
		end
	end
end)

AddEventHandler('playerSpawned', function()
	Citizen.CreateThread(function()
		Wait(1200)
		TriggerServerEvent('playerSpawned')
	end)
end)

function ShowText(text, timeout)
	if(timeout == nil) then
		PrintStringWithLiteralStringNow("STRING", text, 2000, 1)
	else
		PrintStringWithLiteralStringNow("STRING", text, timeout, 1)
	end
end

Citizen.CreateThread(function()
	SetMoneyCarriedByAllNewPeds(false)
	SetPlayersDropMoneyInNetworkGame(false)

	SetSyncWeatherAndGameTime(true)
	SetTimeOfDay(13, 30)
end)