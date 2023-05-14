local Lang = Config.Languages[Config.Language];

---@param index number
---@param data table
AddDealerTarget = function(index, data)
    local targetData = {
        options = {
            {
                label = Lang.DealerInteract,
                icon = 'fas fa-cannabis'
            }
        }
    };

    -- Target Options Handler --
    if Config.TargetType == 'ox_target' then
        targetData.size = data.interaction.size;
        targetData.debug = data.interaction.debug;
        targetData.coords = data.coords or data.interaction.coords;
        targetData.rotation = data.heading or data.interaction.heading;

        targetData.options[1].name = 'king_drugs_dealer_target_'..index;
        targetData.options[1].distance = 1.5;
        targetData.options[1].onSelect = function()
            OpenDealerMenu(index, data);
        end;
    end
    exports[Config.TargetType]:addBoxZone(targetData);
end

---@param intex number
---@param data table
AddDealerControl = function(intex, data)
    
end