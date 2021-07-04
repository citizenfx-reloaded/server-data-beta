RegisterServerEvent('chatMessageEntered')
AddEventHandler('chatMessageEntered', function(name, color, message)
    if not name or not color or not message or #color ~= 3 then
        return
    end

    TriggerEvent('chatMessage', source, name, message)

    if not WasEventCanceled() then
        TriggerClientEvent('chatMessage', -1, name, color, message)
    end

    print('[Chat] ' .. name .. ': ' .. message)
end)

-- player join messages
RegisterServerEvent('playerActivated')
AddEventHandler('playerActivated', function()
    TriggerClientEvent('chatMessage', -1, '', { 0, 0, 0 }, '^2* ' .. GetPlayerName(source) .. ' joined.')
    print('[Join] ' .. GetPlayerName(source) .. ' (' .. source .. ') has joined the game.')
end)

AddEventHandler('playerDropped', function(reason)
    TriggerClientEvent('chatMessage', -1, '', { 0, 0, 0 }, '^2* ' .. GetPlayerName(source) ..' left (' .. reason .. ')')
end)

-- rcon command handler
RegisterServerEvent('rconCommand')
AddEventHandler('rconCommand', function(commandName, args)
    if(commandName == "say") then
        local msg = table.concat(args, ' ')

        TriggerClientEvent('chatMessage', -1, 'console', { 0, 0x99, 255 }, msg)
        RconPrint('console: ' .. msg .. "\n")

        CancelEvent()
    elseif(commandName == "tell") then
        local target = table.remove(args, 1)
        local msg = table.concat(args, ' ')

        TriggerClientEvent('chatMessage', tonumber(target), 'console', { 0, 0x99, 255 }, msg)
        RconPrint('console: ' .. msg .. "\n")

        CancelEvent()
    end
end)
