local ESX = exports['es_extended']:getSharedObject();
local Lang = Config.Languages[Config.Language];

---@param src number
---@return number
lib.callback.register('king-drugs:server:getMoneyAmount', function(src)
    local xPlayer = ESX.GetPlayerFromId(src);
    return xPlayer.getMoney();
end);

---@param drug string
---@param amount number
---@param price number
---@return nil
RegisterServerEvent('king-drugs:server:buyDrugs', function(drug, amount, price)
    local src = source;
    local xPlayer = ESX.GetPlayerFromId(src);
    if xPlayer.getMoney() < price then
        TriggerClientEvent('king-drugs:client:notify', src, Lang.Dealer, Lang.NotEnoughMoney, 'error', 5000);
        return;
    end
    xPlayer.removeMoney(price);
    xPlayer.addInventoryItem(drug, amount);
end)

---@param src number
---@param item string
---@return number
lib.callback.register('king-drugs:server:getItemAmount', function(src, item)
    local xPlayer = ESX.GetPlayerFromId(src);
    return xPlayer.getInventoryItem(item).count;
end)

---@param drug string
---@param amount number
---@param price number
RegisterServerEvent('king-drugs:server:sellDrugs', function(drug, amount, price)
    local src = source;
    local xPlayer = ESX.GetPlayerFromId(src);
    if xPlayer.getInventoryItem(drug).count < amount then
        local NotEnoughDrug = string.format(Lang.NotEnough, Lang[drug]);
        TriggerClientEvent('king-drugs:client:notify', src, Lang.Dealer, NotEnoughDrug, 'error', 5000);
        return;
    end
    xPlayer.removeInventoryItem(drug, amount);
    xPlayer.addMoney(price);
end)