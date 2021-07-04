-- triggers an event when the local network player becomes active
RegisterNetEvent('sessionInitialized')
AddEventHandler('sessionInitialized', function()
    local playerId = GetPlayerId()

    -- create a looping thread
    Citizen.CreateThread(function()
        -- wait until the player becomes active
        while not IsNetworkPlayerActive(playerId) do
            Wait(0)
        end

        -- set some defaults
        AllowGameToPauseForStreaming(true)

        SetMaxWantedLevel(6)
        SetWantedMultiplier(0.9999999)
        SetCreateRandomCops(true)
        SetDitchPoliceModels(false)

        DisplayPlayerNames(true)
        NetworkSetHealthReticuleOption(true)

        -- trigger an event on both the local client and the server
        TriggerEvent('playerActivated')
        TriggerServerEvent('playerActivated')
    end)
end)
