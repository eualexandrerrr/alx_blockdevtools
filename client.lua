RegisterNUICallback(GetCurrentResourceName(), function(data, cb)
    TriggerServerEvent(GetCurrentResourceName())
    if cb then cb('ok') end
end)