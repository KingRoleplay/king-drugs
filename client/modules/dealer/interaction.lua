local Lang = Config.Languages[Config.Language];

---@param intex number
---@param data table
AddDealerControl = function(intex, data)
    if Config.ZoneType == 'ox' then
        lib.zones.box({
            coords = data.coords or data.interaction.coords,
            size = data.interaction.size,
            debug = data.interaction.debug,
            rotation = data.heading or data.interaction.heading,
            inside = function()
                if IsControlJustPressed(0, data.interaction.controlIdx) then
                    OpenDealerMenu(intex, data);
                end
            end,
            onEnter = function()
                if Config.ControlInteraction ~= '3DText' then
                    TextUI('show', '['..data.interaction.controlLabel..'] '..Lang.DealerInteract);
                end
            end,
            onExit = function()
                if Config.ControlInteraction ~= '3DText' then
                    TextUI('hide');
                end
            end,
        });
    end
end