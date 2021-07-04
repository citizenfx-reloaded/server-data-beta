function printTo(channel, data)
    SendNUIMessage({
        meta = 'print',
        channel = channel,
        data = data
    })
end

function addChannel(id, options)
    if not options.template then
        return
    end

    options.id = id

    SendNUIMessage({
        meta = 'addChannel',
        data = options
    })
end

function removeChannel(id)
    SendNUIMessage({
        meta = 'removeChannel',
        data = id
    })
end
