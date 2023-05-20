local Lang = Config.Languages[Config.Language];
CreateThread(function()
    for index, value in pairs(Config.DealerLocations) do
        if value.interaction.type == 'target' then
            AddTargetInteraction(Lang.DealerInteract, 'fas fa-cannabis', 'king_drugs_dealer_target_'..index, {
                size = value.interaction.size,
                debug = value.interaction.debug,
                coords = value.interaction.coords or value.coords,
                heading = value.heading or value.interaction.heading
            }, function()
                OpenDealerMenu(index, value);
            end);
        elseif value.interaction.type == 'control' then
            AddControlInteraction({
                size = value.interaction.size,
                debug = value.interaction.debug,
                coords = value.interaction.coords or value.coords,
                heading = value.heading or value.interaction.heading
            }, {
                control = value.interaction.controlIdx,
                label = value.interaction.controlLabel,
                text = Lang.DealerInteract
            }, function()
                OpenDealerMenu(index, value);
            end);
        end
        if value.ped then value.ped.id = SpawnPed(value); end
        if value.blip then value.blip.id = AddBlip(value); end
    end
end)