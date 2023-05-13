---@param data table
---@return number
AddBlip = function(data)
    local blip = AddBlipForCoord(data.coords.x, data.coords.y, data.coords.z);
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
    if GetResourceState('ox_lib') ~= 'missing' then
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
    local ped = CreatePed(1, model, data.coords.x, data.coords.y, data.coords.z - 1, data.heading, true, true);
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