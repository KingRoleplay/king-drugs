local Lang = Config.Languages[Config.Language];

---@param coords vector3
---@param heading number
local TeleportLaudry = function(coords, heading)
    ReqAnimDict('anim@heists@keycard@');
    local ped = cache?.ped or PlayerId();
    TaskPlayAnim(ped, 'anim@heists@keycard@', 'exit', 8.0, 1.0, -1, 48, 0, false, false, false);
    Wait(500);
    DoScreenFadeOut(500);
    Wait(500);
    local pId = cache?.playerId or PlayerId();
    StartPlayerTeleport(pId, coords.x, coords.y, coords.z, heading, false, true, true);
    Wait(500);
    DoScreenFadeIn(500);
end

---@param index number
---@param value table
AddLaudryEnter_ExitTarget = function(index, value)
    -- Out --
    AddTargetInteraction(Lang.GetOutLaudry, 'fas fa-door-open', 'king_drugs_money_laundry_'..index, {
        size = value.getIn.interaction.size,
        debug = value.getIn.interaction.debug,
        coords = value.getIn.interaction.goToCoords.coords,
        heading = value.getIn.interaction.goToCoords.heading
    }, function()
        local coords = value.getIn.interaction.coords;
        TeleportLaudry(coords, value.getIn.interaction.heading);
    end);
    -- In --
    AddTargetInteraction(Lang.GetInLaudry, 'fas fa-door-open', 'king_drugs_money_laundry_'..index, {
        size = value.getIn.interaction.size,
        debug = value.getIn.interaction.debug,
        coords = value.getIn.interaction.coords,
        heading = value.getIn.interaction.heading
    }, function()
        local coords = value.getIn.interaction.goToCoords.coords;
        TeleportLaudry(coords, value.getIn.interaction.goToCoords.heading);
    end, function()
        if not value.getIn.item then
            return true;
        end
        return lib.callback.await('king-drugs:server:haveLaundryItem', false, value.getIn.item);
    end);
end


---@param lIdx number
---@param lData table
---@param mIdx number
---@param mData table
AddLaundryLocation = function(lIdx, lData, mIdx, mData)
    AddTargetInteraction(Lang.InteractMoneyWash..lIdx..'.'..mIdx, 'fas fa-door-open', 'king_drugs_moneyWash_'..lIdx..'_'..mIdx, {
        size = mData.size,
        debug = mData.debug,
        coords = mData.coords,
        heading = mData.heading
    }, function()
        print("бачка майна")
    end)
end