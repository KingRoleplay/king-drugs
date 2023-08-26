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
            if not message then
                return;
            end
            lib.showTextUI(message);
        elseif action == 'hide' then
            lib.hideTextUI();
        end
    elseif interaction == 'custom' then
        CustomTextUI(action, message);
    end
end

---@param zoneData table
---@param controlData table
---@param action function
---@param canInteract function?
AddControlInteraction = function(zoneData, controlData, action, canInteract)
    if Config.ZoneType == 'ox' then
        lib.zones.box({
            coords = zoneData.coords,
            size = zoneData.size,
            debug = zoneData.debug,
            rotation = zoneData.heading,
            inside = function()
                if IsControlJustPressed(0, controlData.control) then
                    if canInteract then
                        if canInteract() then
                            action();
                            return;
                        end
                    end
                    action();
                end
            end,
            onEnter = function()
                if Config.ControlInteraction ~= '3DText' then
                    TextUI('show', '['..controlData.label..'] '..controlData.text);
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

---@param targetLabel string
---@param icon string
---@param name string
---@param data table
---@param onSelect function
---@param canInteract function?
AddTargetInteraction = function(targetLabel, icon, name, data, onSelect, canInteract)
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
        if canInteract then
            targetData.options[1].canInteract = canInteract;
        end
        exports[Config.TargetType]:addBoxZone(targetData);
    elseif Config.TargetType == 'qtarget' or Config.TargetType == 'qb-target' or Config.TargetType == 'bt-target' then
        targetData.distance = 1.5;
        if Config.TargetType == 'qtarget' or Config.TargetType == 'qb-target' then
            targetData.options[1].action = onSelect;
            if canInteract then
                targetData.options[1].canInteract = canInteract;
            end
        elseif Config.TargetType == 'bt-target' then
            targetData.options[1].event = 'king-drugs:client:'..name;
            ---@return nil
            AddEventHandler('king-drugs:client:'..name, function()
                if canInteract then
                    if canInteract() then
                        onSelect();
                        return;
                    end
                end
                onSelect();
            end);
        end
        exports[Config.TargetType]:AddBoxZone(name, data.coords, data.size[1], data.size[2], {
            name = name,
            heading = data.heading,
            debugPoly = data.debug,
            minZ = data.coords.z - data.size[3],
            maxZ = data.coords.z + data.size[3]
        }, targetData);
    end
end