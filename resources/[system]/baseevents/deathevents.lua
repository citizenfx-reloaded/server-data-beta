Citizen.CreateThread(function()
    local isDead = false
    local hasBeenDead = false

    while true do
        Citizen.Wait(0)

        local player = GetPlayerId()

        if(IsNetworkPlayerActive(player)) then
            local char = GetPlayerChar(player)

            if(IsCharFatallyInjured(char) and not isDead) then
                isDead = true

                local killer = FindNetworkKillerOfPlayer(player)
                local killerped = GetPlayerChar(killer)
                local killerinvehicle = false
                local killervehiclename = ''
                local killervehicleseat = 0

                if(killer ~= nil and IsNetworkPlayerActive(killer)) then
                    if(IsCharInAnyCar(killerped)) then
                        killerinvehicle = true
                        killervehiclename = GetDisplayNameFromVehicleModel(GetCarModel(GetCarCharIsUsing(killerped)))
                        killervehicleseat = GetPedVehicleSeat(killerped)
                    else
                        killerinvehicle = false
                    end
                else
                    killer = -1
                end

                local networkId = GetNetworkIdFromPed(char)
                local deathReason = GetDestroyerOfNetworkId(networkId)

                if killer == player or killer == -1 then
                    TriggerEvent('baseevents:onPlayerDied', GetPlayerServerId(player), GetCharCoordinates(char))
                    TriggerServerEvent('baseevents:onPlayerDied', GetPlayerServerId(player), GetCharCoordinates(char))
                    hasBeenDead = true
                else
                    TriggerEvent('baseevents:onPlayerKilled', GetPlayerServerId(player), {killer=GetPlayerServerId(killer), reason=deathReason, killerinveh=killerinvehicle, killervehseat=killervehicleseat, killervehname=killervehiclename, killerpos=GetCharCoordinates(char)})
                    TriggerServerEvent('baseevents:onPlayerKilled', GetPlayerServerId(player), {killer=GetPlayerServerId(killer), reason=deathReason, killerinveh=killerinvehicle, killervehseat=killervehicleseat, killervehname=killervehiclename, killerpos=GetCharCoordinates(char)})
                    hasBeenDead = true
                end
            elseif(not IsCharFatallyInjured(char)) then
                isDead = false
            end

            -- check if the player has to respawn in order to trigger an event
            if(not hasBeenDead and HowLongHasNetworkPlayerBeenDeadFor(player) > 0) then
                TriggerEvent('baseevents:onPlayerWasted', GetPlayerServerId(player), GetCharCoordinates(char))
                TriggerServerEvent('baseevents:onPlayerWasted', GetPlayerServerId(player), GetCharCoordinates(char))

                hasBeenDead = true
            elseif(hasBeenDead and HowLongHasNetworkPlayerBeenDeadFor(player) <= 0) then
                hasBeenDead = false
            end
        end
    end
end)
