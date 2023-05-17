CreateThread(function()
    for index, value in pairs(Config.LaundryLocations) do
        if value.getIn.interaction.type == 'target' then
            AddLaudryEnter_ExitTarget(index, value);
        end
        if value.blip then value.blip.id = AddBlip(value); end
    end
end)