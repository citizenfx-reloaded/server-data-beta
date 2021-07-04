local chatSharp = clr.ChatSharp

local client = chatSharp.IrcClient('irc.rizon.net', chatSharp.IrcUser('citimate', 'mateyate'), false)

-- temporary workaround for connections that never triggered playerActivated but triggered playerDropped
local activatedPlayers = {}

client.ConnectionComplete:add(function(s : object, e : System.EventArgs) : void
	client:JoinChannel('#fourdeltaone')
end)

-- why is 'received' even misspelled here?
client.ChannelMessageRecieved:add(function(s : object, e : ChatSharp.Events.PrivateMessageEventArgs) : void
	local msg = e.PrivateMessage

	TriggerClientEvent('chatMessage', -1, msg.User.Nick, { 0, 0x99, 255 }, msg.Message)
end)

AddEventHandler('playerActivated', function()
	client:SendMessage('* ' .. GetPlayerName(source) .. '(' .. GetPlayerGuid(source) .. '@' .. GetPlayerEP(source) .. ') joined the server', '#fourdeltaone')
	table.insert(activatedPlayers, GetPlayerGuid(source))
end)

AddEventHandler('playerDropped', function()
	-- find out if this connection ever triggered playerActivated
	for index,guid in pairs(activatedPlayers) do
		if guid == playerGuid then
			-- show player dropping connection in chat
			client:SendMessage('* ' .. GetPlayerName(source) .. '(' .. GetPlayerGuid(source) .. '@' .. GetPlayerEP(source) .. ') left the server', '#fourdeltaone')
			table.remove(activatedPlayers, index)
			return
		end
	end
end)

AddEventHandler('chatMessage', function(source, name, message)
	print('hey there ' .. name)

	local displayMessage = gsub(message, '^%d', '')

	-- ignore zero-length messages
	if string.len(displayMessage) == 0 then
		return
	end

	-- ignore chat messages that are actually commands
	if string.sub(displayMessage, 1, 1) == "/" then
		return
	end

	client:SendMessage('[' .. tostring(GetPlayerName(source)) .. ']: ' .. displayMessage, '#fourdeltaone')
end)

AddEventHandler('baseevents:onPlayerKilled', function(playerId, data)
    local player = GetPlayerByServerId(playerId)
    local attacker = GetPlayerByServerId(data.killer)

    local reasonString = 'killed'

    if data.reason == 0 or data.reason == 56 or data.reason == 1 or data.reason == 2 then
        reasonString = 'meleed'
    elseif data.reason == 3 then
        reasonString = 'knifed'
    elseif data.reason == 4 or data.reason == 6 or data.reason == 18 or data.reason == 51 then
        reasonString = 'bombed'
    elseif data.reason == 5 or data.reason == 19 then
        reasonString = 'burned'
    elseif data.reason == 7 or data.reason == 9 then
        reasonString = 'pistoled'
    elseif data.reason == 10 or data.reason == 11 then
        reasonString = 'shotgunned'
    elseif data.reason == 12 or data.reason == 13 or data.reason == 52 then
        reasonString = 'SMGd'
    elseif data.reason == 14 or data.reason == 15 or data.reason == 20 then
        reasonString = 'assaulted'
    elseif data.reason == 16 or data.reason == 17 then
        reasonString = 'sniped'
    elseif data.reason == 49 or data.reason == 50 then
        reasonString = 'ran over'
    end

	client:SendMessage('* ' .. attacker.name .. ' ' .. reasonString .. ' ' .. player.name, '#fourdeltaone')
end)

client:ConnectAsync()

AddEventHandler('onResourceStop', function(name)
	if name == GetInvokingResource() then
		client:Quit('Resource stopping.')
	end
end)