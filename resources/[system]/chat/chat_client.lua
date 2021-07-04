local chatInputActive = false

RegisterNetEvent('chatMessage')
AddEventHandler('chatMessage', function(name, color, message)
    SendNUIMessage({
        name = name,
        color = color,
        message = message
    })
end)

RegisterNUICallback('chatResult', function(data, cb)
    chatInputActive = false

    SetNuiFocus(false)

    if data.message then
        local id = GetPlayerId()

        local r, g, b = GetPlayerRgbColour(id)

        TriggerServerEvent('chatMessageEntered', GetPlayerName(id), { r, g, b }, data.message)
    end

    cb('ok')
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if not chatInputActive then
            if IsGameKeyboardKeyJustPressed(21) --[[ y ]] then
                chatInputActive = true

                SendNUIMessage({
                    meta = 'openChatBox'
                })

                SetNuiFocus(true)

                NetworkSetLocalPlayerIsTyping(GetPlayerId())
            end
        end
    end
end)
