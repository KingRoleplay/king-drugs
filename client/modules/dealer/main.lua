CreateThread(function()
    for index, value in pairs(Config.DealerLocations) do
        -- Interation --
        if value.interaction.type == 'target' then
            AddDealerTarget(index, value);
        elseif value.interaction.type == 'control' then
            AddDealerControl(index, value);
        end
        -- Ped Creation --
        if value.blip then value.blip.id = AddBlip(value); end
        if value.ped then value.ped.id = SpawnPed(value); end
    end
end)