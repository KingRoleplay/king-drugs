---@param data table
---@return number
AddBlip = function(data)
    local coords = data.blip.coords or data.coords;
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z);
    SetBlipSprite(blip, data.blip.sprite);
    SetBlipDisplay(blip, 4);
    SetBlipScale(blip, data.blip.scale);
    SetBlipColour(blip, data.blip.color);
    SetBlipAsShortRange(blip, true);
    BeginTextCommandSetBlipName('STRING');
    AddTextComponentSubstringKeyboardDisplay(data.blip.label);
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

local Lang = Config.Languages[Config.Language];

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
AddTargetInteraction = function(targetLabel, icon, name, data, onSelect)
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
    end
    exports[Config.TargetType]:addBoxZone(targetData);
end