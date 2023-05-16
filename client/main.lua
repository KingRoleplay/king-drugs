---@param dict string
ReqAnimDict = function(dict)
    local state = GetResourceState('ox_lib');
    if state ~= 'missing' and state ~= 'stopped' then
        lib.requestAnimDict(dict);
    else
        RequestAnimDict(dict);
        while not HasAnimDictLoaded(dict) do
            Wait(10);
        end
    end
end


---@param data table
---@return vector3 coords
---@return number sprite
---@return number scale
---@return number color
---@return string label
local FormateBlipSettings = function(data)
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
AddBlip = function(data)
    local coords, sprite, scale, color, label = FormateBlipSettings(data);
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

---@param model string | number
local ReqModel = function(model)
    if type(model) == 'string' then
        model = GetHashKey(model);
    end
    -- ox_lib check --
    local state = GetResourceState('ox_lib');
    if state ~= 'missing' and state ~= 'stopped' then
        lib.requestModel(model);
    else
        RequestModel(model);
        while not HasModelLoaded(model) do
            Wait(10);
        end
    end
end

---@param data table
---@return number
SpawnPed = function(data)
    local model = GetHashKey(data.ped.model);
    ReqModel(model);
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

---@param title string
---@param msg string
---@param type string
---@param time number
Notify = function(title, msg, type, time)
    if Config.Notifications == 'ox' then
        lib.notify({
            title = title,
            description = msg,
            type = type,
            duration = time
        });
    elseif Config.Notifications == 'custom' then
        CustomNotifications(title, msg, type, time)
    else
        CustomNotifications(title, msg, type, time);
    end
end
RegisterNetEvent('king-drugs:client:notify', Notify);

---@param action string
---@param message string?
TextUI = function(action, message)
    local interaction = Config.ControlInteraction;
    if interaction == 'ox' then
        if action == 'show' then
            lib.showTextUI(message);
        elseif action == 'hide' then
            lib.hideTextUI();
        end
    elseif interaction == 'custom' then
        CustomTextUI(action, message);
    end
end

---@param targetLabel string
---@param icon string
---@param name string
---@param data table
---@param onSelect function
---@param canInteact function?
AddTargetInteraction = function(targetLabel, icon, name, data, onSelect, canInteact)
    local targetData = {
        options = {
            {
                label = targetLabel,
                icon = icon
            }
        }
    };

    -- Target Options Handler --
    if Config.TargetType == 'ox_target' then
        targetData.size = data.size;
        targetData.debug = data.debug;
        targetData.coords = data.coords;
        targetData.rotation = data.heading;
        targetData.options[1].name = name;
        targetData.options[1].distance = 1.5;
        targetData.options[1].onSelect = onSelect;
        if canInteact then
            targetData.options[1].canInteract = canInteact;
        end
        exports[Config.TargetType]:addBoxZone(targetData);
    elseif Config.TargetType == 'qtarget' or Config.TargetType == 'qb-target' then
        targetData.options[1].action = onSelect;
        if canInteact then
            targetData.options[1].canInteract = canInteact;
        end
        exports[Config.TargetType]:AddBoxZone(targetLabel, data.coords, data.size[1], data.size[2], {
            name = targetLabel,
            heading = data.Heading,
            debugPoly = data.debug,
            minZ = data.coords.z - 2,
            maxZ = data.coords.z + 2
        }, targetData)
    end
end