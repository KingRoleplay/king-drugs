local Lang = Config.Languages[Config.Language];

---@param index number
---@param value table
local AddLaundryTarget = function(index, value)
    
end

---@param index number
---@param value table
local AddLaundryControl = function(index, value)
    
end

---@param coords vector3
---@param heading number
local TeleportLaudry = function(coords, heading)
    ReqAnimDict('anim@heists@keycard@');
    local ped = cache?.ped or PlayerPedId();
    TaskPlayAnim(ped, 'anim@heists@keycard@', 'exit', 8.0, 1.0, -1, 48, 0, false, false, false);
    Wait(500);
    DoScreenFadeOut(500);
    Wait(500);
    StartPlayerTeleport(ped, coords.x, coords.y, coords.z, heading, false, true, true);
    Wait(500);
    DoScreenFadeIn(500);
end

---@param index number
---@param value table
AddLaudryEnter_ExitTarget = function(index, value)
    -- Out --
    AddTargetInteraction(Lang.GetInLaudry, 'fas fa-door-open', 'king_drugs_money_laundry_'..index, {
        size = value.getIn.interaction.size,
        debug = value.getIn.interaction.debug,
        coords = value.getIn.interaction.goToCoords.coords,
        heading = value.getIn.interaction.goToCoords.heading
    }, function()
        local coords = value.getIn.coords;
        TeleportLaudry(coords, value.getIn.heading);
    end);
    -- In --
    AddTargetInteraction(Lang.GetInLaudry, 'fas fa-door-open', 'king_drugs_money_laundry_'..index, {
        size = value.getIn.interaction.size,
        debug = value.getIn.interaction.debug,
        coords = value.getIn.interaction.coords,
        heading = value.getIn.interaction.heading
    }, function()
        local coords = value.getIn.goToCoords.coords;
        TeleportLaudry(coords, value.getIn.goToCoords.heading);
    end, function()
        if not value.getIn.item then
            return true;
        end
        return lib.callback.await('king-drugs:server:haveLaundryItem', false, value.getIn.item);
    end);
end