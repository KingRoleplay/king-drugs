CreateThread(function()
    for i, v in pairs(Config.Plants) do
        for index, value in pairs(v.locations) do
            CreateDrugPlantField(i, v, index, value);
            if value.blip then
                v.blipSettings.coords = value.coords;
                value.blipId = AddBlip(v.blipSettings);
                -- Radius Blip --
                local c = value.coords;
                value.radiusBlipId = AddBlipForRadius(c.x, c.y, c.z, value.radius);
                SetBlipColour(value.radiusBlipId, v.blipSettings.color);
                SetBlipAlpha(value.radiusBlipId, 128);
            end
        end
    end
end)