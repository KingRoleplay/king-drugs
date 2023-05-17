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
                local coords = value.getIn.goToCoords.coords;
                ReqAnimDict('anim@heists@keycard@');
                TaskPlayAnim(cache.ped, 'anim@heists@keycard@', 'exit', 8.0, 1.0, -1, 48, 0, false, false, false);
                Wait(500);
                DoScreenFadeOut(500);
                Wait(500);
                StartPlayerTeleport(PlayerId(), coords.x, coords.y, coords.z, 0.0, false, true, true);
                Wait(500);
                DoScreenFadeIn(500);
            end, function()
                if not value.getIn.item then
                    return true;
                end
                return lib.callback.await('king-drugs:server:haveLaundryItem', false, value.getIn.item);
            end)
            for i, v in pairs(Config.LaundryLocations) do
                if v.getIn.Washing.type == 'target' then
                    AddTargetInteraction(Lang.WashMoney, 'fas fa-door-open', 'king_drugs_money_laundry_'..i, {
                        size = v.getIn.Washing.size,
                        debug = v.getIn.Washing.debug,
                        coords = v.getIn.Washing.coords,
                        heading = v.getIn.Washing.heading
                    })
                end
            end
        end
        if value.blip then value.blip.id = AddBlip(value); end
    end
end)