---@param prop string | number
---@param plantsAmount number
---@param coords vector3
---@param zCoords table?
---@return table
local createPlantProps = function(prop, plantsAmount, coords, zCoords)
    local spawnedPlants = {};
    while #spawnedPlants < plantsAmount do
        
        Wait(4);
    end
    return spawnedPlants;
end

---@param drugIdx string
---@param drugData table
---@param fieldIdx number
---@param fieldData table
CreateDrugPlantField = function(drugIdx, drugData, fieldIdx, fieldData)
    local plantProps = {};
    lib.zones.sphere({
        coords = fieldData.coords,
        rotation = fieldData.heading,
        debug = fieldData.debug,
        radius = fieldData.radius,
        onEnter = function()
            plantProps = createPlantProps(drugData.prop, fieldData.plantsAmount, fieldData.coords, fieldData.zCoords);
        end,
        onExit = function ()
            for i = 1, #plantProps do
                DeleteObject(plantProps[i]);
            end
        end
    });
end