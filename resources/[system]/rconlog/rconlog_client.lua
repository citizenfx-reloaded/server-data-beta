AddEventHandler('rlUpdateNames', function()
    local names = {}

    for i = 0, 31 do
        if IsNetworkPlayerActive(i) then
            names[GetPlayerNetID(i)] = { id = i, name = GetPlayerName(i, _s) }
        end
    end

    TriggerServerEvent('rlUpdateNamesResult', names)
end)
