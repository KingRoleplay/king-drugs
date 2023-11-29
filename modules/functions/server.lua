Framework = nil;
CreateThread(function()
    if GetResourceState('qb-core'):find('start') then
        Framework, FrameworkName = exports['qb-core']:GetCoreObject(), 'qbcore';
    elseif GetResourceState('es_extended'):find('start') then
        Framework, FrameworkName = exports['es_extended']:getSharedObject(), 'esx';
    end
end)

local functions = {};

---@param playerId integer
---@return table?
functions.GetPlayerFromId = function(playerId)
    if FrameworkName == 'qbcore' then
        return Framework?.Functions.GetPlayer(playerId);
    elseif FrameworkName == 'esx' then
        return Framework?.GetPlayerFromId(playerId);
    end
end

---@param playerId integer
---@return number?
functions.GetPlayersCash = function(playerId)
    local xPlayer = functions.GetPlayerFromId(playerId);
    if FrameworkName == 'qbcore' then
        return xPlayer?.PlayerData.money['cash'];
    elseif FrameworkName == 'esx' then
        return xPlayer?.getMoney();
    end
end

---@param playerId integer
---@param amount number
---@return nil
functions.RemovePlayersCash = function(playerId, amount)
    local xPlayer = functions.GetPlayerFromId(playerId);
    if FrameworkName == 'qbcore' then
        xPlayer?.Functions.RemoveMoney('cash', amount);
    elseif FrameworkName == 'esx' then
        xPlayer?.removeMoney(amount);
    end
end

---@param playerId integer
---@param amount number
---@return nil
functions.AddPlayersCash = function(playerId, amount)
    local xPlayer = functions.GetPlayerFromId(playerId);
    if FrameworkName == 'qbcore' then
        xPlayer?.Functions.AddMoney('cash', amount);
    elseif FrameworkName == 'esx' then
        xPlayer?.addMoney(amount);
    end
end

---@param playerId integer
---@param item string
---@return table?
functions.GetPlayersItem = function(playerId, item)
    local xPlayer = functions.GetPlayerFromId(playerId);
    if FrameworkName == 'qbcore' then
        return xPlayer?.Functions.GetItemByName(item);
    elseif FrameworkName == 'esx' then
        return xPlayer?.getInventoryItem(item);
    end
end

---@param playerId integer
---@param item string
---@return number?
functions.GetPlayersItemAmont = function(playerId, item)
    local itemTable = functions.GetPlayersItem(playerId, item);
    if FrameworkName == 'qbcore' then
        return itemTable?.amount;
    elseif FrameworkName == 'esx' then
        return itemTable?.count;
    end
end

---@param playerId integer
---@param item string
---@param amount number
---@return nil
functions.RemovePlayersItem = function(playerId, item, amount)
    local xPlayer = functions.GetPlayerFromId(playerId);
    if FrameworkName == 'qbcore' then
        xPlayer?.Functions.RemoveItem(item, amount);
    elseif FrameworkName == 'esx' then
        xPlayer?.removeInventoryItem(item, amount);
    end
end

---@param playerId integer
---@param item string
---@param amount number
---@return nil
functions.AddPlayerItem = function(playerId, item, amount)
    local xPlayer = functions.GetPlayerFromId(playerId);
    if FrameworkName == 'qbcore' then
        xPlayer?.Functions.AddItem(item, amount);
    elseif FrameworkName == 'esx' then
        xPlayer?.addInventoryItem(item, amount);
    end
end

return functions;