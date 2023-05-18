CreateThread(function()
    for index, value in pairs(Config.DealerLocations) do
        if value.interaction.type == 'target' then
            local Lang = Config.Languages[Config.Language];
            local text = Lang.DealerInteract..index;
            if Config.TargetType == 'ox_target' then
                text = Lang.DealerInteract;
            end
            AddTargetInteraction(text, 'fas fa-cannabis', 'king_drugs_dealer_target_'..index, {
                size = value.interaction.size,
                debug = value.interaction.debug,
                coords = value.interaction.coords or value.coords,
                heading = value.heading or value.interaction.heading
            }, function()
                OpenDealerMenu(index, value);
            end)
        elseif value.interaction.type == 'control' then
            AddDealerControl(index, value);
        end
        if value.ped then value.ped.id = SpawnPed(value); end
        if value.blip then value.blip.id = AddBlip(value); end
    end
end)