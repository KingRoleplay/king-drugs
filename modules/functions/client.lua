local functions = {};

-- Notification --

RegisterNetEvent('king-drugs:client:notify', Notification);

-- Blip --

---@param data table
---@return vector3 coords
---@return number sprite
---@return number scale
---@return number color
---@return string label
local formatBlipSettings = function(data)
    local coords, sprite = data.coords, data.sprite;
    local scale, color, label = data.scale, data.color, data.label;
    if data.blip and not coords then
        coords = data.blip.coords;
    end
    if data.blip and not sprite then
        sprite = data.blip.sprite;
    end
    if data.blip and not scale then
        scale = data.blip.scale;
    end
    if data.blip and not color then
        color = data.blip.color;
    end
    if data.blip and not label then
        label = data.blip.label;
    end
    coords = coords or vector3(0.0, 0.0, 0.0);
    sprite = sprite or 1;
    scale = scale or 1.0;
    color = color or 0;
    label = label or 'Blip';
    return coords, sprite, scale, color, label;
end

---@param data table
---@return number
local addBlip = function(data)
    local coords, sprite, scale, color, label = formatBlipSettings(data);
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z);
    SetBlipSprite(blip, sprite);
    SetBlipDisplay(blip, 4);
    SetBlipScale(blip, scale);
    SetBlipColour(blip, color);
    SetBlipAsShortRange(blip, true);
    BeginTextCommandSetBlipName('STRING');
    AddTextComponentSubstringKeyboardDisplay(label);
    EndTextCommandSetBlipName(blip);
    return blip;
end
functions.addBlip = addBlip;

-- Ped --

---@param data table
---@return number
local spawnPed = function(data)
    local model = GetHashKey(data.ped.model);
    lib.requestModel(model);
    local coords = data.ped.coords or data.coords;
    local h = data.ped.heading or data.heading;
    local ped = CreatePed(1, model, coords.x, coords.y, coords.z - 1, h, true, true);
    SetPedCombatAttributes(ped, 46, true);
    SetPedFleeAttributes(ped, 0, false);
    SetBlockingOfNonTemporaryEvents(ped, true);
    SetEntityAsMissionEntity(ped, true, true);
    SetEntityInvincible(ped, true);
    FreezeEntityPosition(ped, true);
    SetPedDiesWhenInjured(ped, false);
    SetPedCanPlayAmbientAnims(ped, true);
    SetPedCanRagdollFromPlayerImpact(ped, false);
    return ped;
end
functions.spawnPed = spawnPed;

-- Control Interaction --

---@param zoneData table
---@param controlData table
---@param action function
---@param canInteract function?
local addControlInteraction = function(zoneData, controlData, action, canInteract)
    lib.points.new({
        coords = zoneData.coords,
        distance = zoneData.distance,
        onEnter = function()
            TextUI('show', ('[%s] %s'):format(controlData.label, controlData.text));
        end,
        onExit = function()
            TextUI('hide');
        end,
        nearby = function()
            if IsControlJustPressed(0, controlData.control) then
                if canInteract then
                    if canInteract() then
                        action();
                        return;
                    end
                end
                action();
            end
        end
    });
end
functions.addControlInteraction = addControlInteraction;

-- Target --

---@return 'ox_target' | 'qtarget' | 'qb-target' | 'bt-target'
local getTargetResource = function()
    local targetResource = 'ox_target';
    if GetResourceState('qb-target'):find('start') then
        targetResource = 'qb-target';
    elseif GetResourceState('qtarget'):find('start') then
        targetResource = 'qtarget';
    elseif GetResourceState('bt-target'):find('start') then
        targetResource = 'bt-target';
    end
    return targetResource;
end

---@param data table
---@param name string
---@param onSelect function
---@param canInteract function?
local handleOxTarget = function(data, targetData, name, onSelect, canInteract)
    targetData.size = data.size;
    targetData.debug = data.debug;
    targetData.coords = data.coords;
    targetData.rotation = data.heading;
    targetData.options[1].name = name;
    targetData.options[1].distance = 1.5;
    targetData.options[1].onSelect = onSelect;
    targetData.options[1].canInteract = canInteract;
    exports['ox_target']:addBoxZone(targetData);
end

---@param targetResource 'ox_target' | 'qtarget' | 'qb-target' | 'bt-target'
---@param data table
---@param name string
---@param onSelect function
---@param canInteract function?
local handleQbBtAndQTarget = function(targetResource, data, targetData, name, onSelect, canInteract)
    -- Action Handler --
    targetData.distance = 1.5;
    if targetResource == 'qtarget' or targetResource == 'qb-target' then
        targetData.options[1].action = onSelect;
        if canInteract then
            targetData.options[1].canInteract = canInteract;
        end
    elseif targetResource == 'bt-target' then
        targetData.options[1].event = ('king-drugs:client:%s'):format(name);
        AddEventHandler(('king-drugs:client:%s'):format(name), function()
            if canInteract then
                if canInteract() then
                    return onSelect();
                end
            end
            onSelect();
        end);
    end
    -- Target Export --
    exports[targetResource]:AddBoxZone(name, data.coords, data.size[1], data.size[2], {
        name = name,
        heading = data.heading,
        debugPoly = data.debug,
        minZ = data.coords.z - data.size[3],
        maxZ = data.coords.z + data.size[3]
    }, targetData);
end

---@param targetLabel string
---@param icon string
---@param name string
---@param data table
---@param onSelect function
---@param canInteract function?
local addTargetInteraction = function(targetLabel, icon, name, data, onSelect, canInteract)
    local targetResource = getTargetResource();
    local targetData = {
        options = {
            {
                label = targetLabel,
                icon = icon
            }
        }
    };
    -- Target Options Handler --
    if targetResource == 'ox_target' then
        handleOxTarget(data, targetData, name, onSelect, canInteract);
    elseif targetResource == 'qtarget' or targetResource == 'qb-target' or targetResource == 'bt-target' then
        handleQbBtAndQTarget(targetResource, data, targetData, name, onSelect, canInteract);
    end
end
functions.addTargetInteraction = addTargetInteraction;

return functions;