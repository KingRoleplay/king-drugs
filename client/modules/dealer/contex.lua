local Lang = Config.Languages[Config.Language];

---@param dict string
local ReqAnimDict = function(dict)
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

---@param dealerPed number
local PlayDealAnimation = function(dealerPed)
    ReqAnimDict('mp_common');
    local ped = cache?.ped or PlayerPedId();
    TaskPlayAnim(ped, 'mp_common', 'givetake1_a', 8.0, 8.0, -1, 0, 0, false, false, false);
    TaskPlayAnim(dealerPed, 'mp_common', 'givetake1_a', 8.0, 8.0, -1, 0, 0, false, false, false);
    Wait(1300);
    ClearPedTasks(ped);
    ClearPedTasks(dealerPed);
end

---@param action string
---@param drug string
---@param price number
---@param dealerPed number
---@return nil
local DrugDealerAction = function(action, drug, price, dealerPed)
    local header = string.format(Lang.AmountOfDrugsHeader, Lang[drug]);
    local context = string.format(Lang.AmountOfDrugs, Lang[drug]);
    local input = lib.inputDialog(header, {context});

    if not input or not input[1] == '' or not input[1] then
        return;
    end

    local amount = tonumber(input[1]);
    if not amount or amount < 1 then
        Notify(Lang.Dealer, Lang.InvalidAmount, 'error', 5000);
        return;
    end

    local finalPrice = price * amount;

    if action == 'buy' then
        local moneyAmount = lib.callback.await('king-drugs:server:getMoneyAmount');
        if moneyAmount < finalPrice then
            Notify(Lang.Dealer, Lang.NotEnoughMoney, 'error', 5000);
            return;
        end
        TriggerServerEvent('king-drugs:server:buyDrugs', drug, amount, finalPrice);
        PlayDealAnimation(dealerPed);
        return;
    end
    local drugAmount = lib.callback.await('king-drugs:server:getItemAmount', false, drug);
    if drugAmount < amount then
        local NotEnoughDrug = string.format(Lang.NotEnough, Lang[drug]);
        Notify(Lang.Dealer, NotEnoughDrug, 'error', 5000);
        return;
    end
    TriggerServerEvent('king-drugs:server:sellDrugs', drug, amount, finalPrice);
    PlayDealAnimation(dealerPed);
end

---@param data table
---@param ped number
---@return false | table buyContextData
---@return false | table sellContextData
local FormateDealerMenu = function(data, ped)
    local buyContextData = nil;
    if type(data.buy) ~= 'table' then
        buyContextData = false;
    elseif type(data.buy) == 'table' then
        buyContextData = {};
        for index, value in pairs(data.buy) do
            if Config.ContextType == 'ox' then
                buyContextData[index] = {
                    title = string.format(Lang.ContextMenuDrugAndPrice, Lang[value.item], value.price),
                    icon = 'fas fa-cannabis',
                    onSelect = function()
                        DrugDealerAction('buy', value.item, value.price, ped);
                    end
                };
            end
        end
    end
    -- Sell Menu --
    local sellContextData = nil;
    if type(data.sell) ~= 'table' then
        sellContextData = false;
    elseif type(data.sell) == 'table' then
        sellContextData = {};
        for index, value in pairs(data.sell) do
            if Config.ContextType == 'ox' then
                sellContextData[index] = {
                    title = string.format(Lang.ContextMenuDrugAndPrice, Lang[value.item], value.price),
                    icon = 'fas fa-cannabis',
                    onSelect = function()
                        DrugDealerAction('sell', value.item, value.price, ped);
                    end
                };
            end
        end
    end
    return buyContextData, sellContextData;
end

---@param dealerIndex number
---@param data table
OpenDealerMenu = function(dealerIndex, data)
    local buyContextData, sellContextData = FormateDealerMenu(data.prices, data.ped.id);
    if Config.ContextType == 'ox' then
        lib.registerContext({
            id = 'king_drugs_dealer_menu_'..dealerIndex,
            title = Lang.DealerContextHeader,
            options = {
                {
                    title = 'Buy Drugs',
                    icon = 'fas fa-shopping-cart',
                    disabled = type(buyContextData) == 'boolean' and not buyContextData,
                    onSelect = function()
                        lib.registerContext({
                            id = 'king_drugs_dealer_buy_menu_'..dealerIndex,
                            title = Lang.DealerBuyContextHeader,
                            options = buyContextData
                        });
                        lib.showContext('king_drugs_dealer_buy_menu_'..dealerIndex);
                    end
                },
                {
                    title = 'Sell Drugs',
                    icon = 'fas fa-shopping-cart',
                    disabled = type(sellContextData) == 'boolean' and not sellContextData,
                    onSelect = function()
                        lib.registerContext({
                            id = 'king_drugs_dealer_sell_menu_'..dealerIndex,
                            title = Lang.DealerSellContextHeader,
                            options = sellContextData
                        });
                        lib.showContext('king_drugs_dealer_sell_menu_'..dealerIndex);
                    end
                }
            }
        });
        lib.showContext('king_drugs_dealer_menu_'..dealerIndex);
    end
end
AddEventHandler('king-drugs:client:openDealerMenu', OpenDealerMenu);