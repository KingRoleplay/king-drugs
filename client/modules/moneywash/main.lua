CreateThread(function()
    for index, value in pairs(Config.LaundryLocations) do
        if value.blip then value.blip.id = AddBlip(value); end
    end
end)