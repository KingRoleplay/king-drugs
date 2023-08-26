local Lang = Config.Languages[Config.Language];

---@param src number
---@return number
lib.callback.register('king-drugs:server:getMoneyAmount', function(src)
    return FMFunctions.GetPlayersCash(src) or 0;
end);

---@param drug string
---@param amount number
---@param price number
---@return nil
RegisterServerEvent('king-drugs:server:buyDrugs', function(drug, amount, price)
    local src = source;
    if FMFunctions.GetPlayersCash(src) < price then
        TriggerClientEvent('king-drugs:client:notify', src, Lang.Dealer, Lang.NotEnoughMoney, 'error', 5000);
        return;
    end
    FMFunctions.RemovePlayersCash(src, price);
    FMFunctions.AddPlayerItem(src, drug, amount);
end)

---@param src number
---@param item string
---@return number
lib.callback.register('king-drugs:server:getItemAmount', function(src, item)
    return FMFunctions.GetPlayersItemAmont(src, item) or 0;
end)

---@param drug string
---@param amount number
---@param price number
RegisterServerEvent('king-drugs:server:sellDrugs', function(drug, amount, price)
    local src = source;
    if FMFunctions.GetPlayersItemAmont(src, drug) < amount then
        local NotEnoughDrug = string.format(Lang.NotEnough, Lang[drug]);
        TriggerClientEvent('king-drugs:client:notify', src, Lang.Dealer, NotEnoughDrug, 'error', 5000);
        return;
    end
    FMFunctions.RemovePlayersItem(src, drug, amount);
    FMFunctions.AddPlayersCash(src, price);
end)