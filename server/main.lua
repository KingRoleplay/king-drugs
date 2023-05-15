Framework = nil;
CreateThread(function()
    if Config.Framework == 'qbcore' then
        Framework = exports['qb-core']:GetCoreObject();
    elseif Config.Framework == 'esx' then
        Framework = exports['es_extended']:getSharedObject();
    end
end)

FMFunctions = {};

---@param playerId number
---@return table?
FMFunctions.GetPlayerFromId = function(playerId)
    if Config.Framework == 'qbcore' then
        return Framework.Functions.GetPlayer(playerId);
    elseif Config.Framework == 'esx' then
        return Framework.GetPlayerFromId(playerId);
    end
end

---@param playerId number
---@return number?
FMFunctions.GetPlayersCash = function(playerId)
    local xPlayer = FMFunctions.GetPlayerFromId(playerId);
    if Config.Framework == 'qbcore' then
        return xPlayer?.PlayerData.money['cash'];
    elseif Config.Framework == 'esx' then
        return xPlayer?.getMoney();
    end
end

---@param playerId number
---@param amount number
---@return nil
FMFunctions.RemovePlayersCash = function(playerId, amount)
    local xPlayer = FMFunctions.GetPlayerFromId(playerId);
    if Config.Framework == 'qbcore' then
        xPlayer?.Functions.RemoveMoney('cash', amount);
    elseif Config.Framework == 'esx' then
        xPlayer?.removeMoney(amount);
    end
end

---@param playerId number
---@param amount number
---@return nil
FMFunctions.AddPlayersCash = function(playerId, amount)
    local xPlayer = FMFunctions.GetPlayerFromId(playerId);
    if Config.Framework == 'qbcore' then
        xPlayer?.Functions.AddMoney('cash', amount);
    elseif Config.Framework == 'esx' then
        xPlayer?.addMoney(amount);
    end
end

---@param playerId number
---@param item string
---@return table?
FMFunctions.GetPlayersItem = function(playerId, item)
    local xPlayer = FMFunctions.GetPlayerFromId(playerId);
    if Config.Framework == 'qbcore' then
        return xPlayer?.PlayerData.items[item];
    elseif Config.Framework == 'esx' then
        return xPlayer?.getInventoryItem(item);
    end
end

---@param playerId number
---@param item string
---@return number?
FMFunctions.GetPlayersItemAmont = function(playerId, item)
    local itemTable = FMFunctions.GetPlayersItem(playerId, item);
    if Config.Framework == 'qbcore' then
        return itemTable?.amount;
    elseif Config.Framework == 'esx' then
        return itemTable?.count;
    end
end

---@param playerId number
---@param item string
---@param amount number
---@return nil
FMFunctions.RemovePlayersItem = function(playerId, item, amount)
    local xPlayer = FMFunctions.GetPlayerFromId(playerId);
    if Config.Framework == 'qbcore' then
        xPlayer?.Functions.RemoveItem(item, amount);
    elseif Config.Framework == 'esx' then
        xPlayer?.removeInventoryItem(item, amount);
    end
end

---@param playerId number
---@param item string
---@param amount number
---@return nil
FMFunctions.AddPlayerItem = function(playerId, item, amount)
    local xPlayer = FMFunctions.GetPlayerFromId(playerId);
    if Config.Framework == 'qbcore' then
        xPlayer?.Functions.AddItem(item, amount);
    elseif Config.Framework == 'esx' then
        xPlayer?.addInventoryItem(item, amount);
    end
end