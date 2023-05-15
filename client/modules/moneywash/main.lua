local Lang = Config.Languages[Config.Language];

CreateThread(function()
    for index, value in pairs(Config.LaundryLocations) do
        if value.getIn.interaction.type == 'target' then
            AddTargetInteraction(Lang.GetInLaudry, 'fas fa-door-open', 'king_drugs_money_laundry_'..index, {
                size = value.getIn.interaction.size,
                debug = value.getIn.interaction.debug,
                coords = value.getIn.interaction.coords,
                heading = value.getIn.interaction.heading
            }, function()
                
            end, function()
                return lib.callback.await('king-drugs:server:haveLaundryItem', false, value.getIn.item);
            end)
        end
        if value.blip then value.blip.id = AddBlip(value); end
    end
end)