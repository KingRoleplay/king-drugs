local Lang = Config.Languages[Config.Language];

local BuyDrugs = function()

end

local SellDrugs = function()
    
end

---@param data table
---@return table
local FormateDealerMenu = function(data)
    local buyContextData, buyContextEnabled = nil, true;
    if type(data.buyPrices) == 'table' then
        buyContextData, buyContextEnabled = {}, false;
        for index, value in pairs(data.buyPrices) do
            if Config.ContextType == 'ox' then
                buyContextData[index] = {
                    title = Lang[value.item]..' - '..value.price..'$',
                    icon = 'fas fa-cannabis'
                };
            end
        end
    end
    -- Sell Menu --
    local sellContextData, sellContextEnabled = nil, true;
    if type(data.buyPrices) == 'table' then
        sellContextData, sellContextEnabled = {}, false;
        for index, value in pairs(data.sellPrices) do
            if Config.ContextType == 'ox' then
                sellContextData[index] = {
                    title = Lang[value.item]..' - '..value.price..'$',
                    icon = 'fas fa-cannabis'
                };
            end
        end
    end
    return { enabled = { sell = sellContextEnabled, buy = buyContextEnabled }, data = { sell = sellContextData, buy = buyContextData } };
end

---@param dealerIndex number
---@param data table
OpenDealerMenu = function(dealerIndex, data)
    local menuData = FormateDealerMenu(data);
    if Config.ContextType == 'ox' then
        lib.registerContext({
            id = 'king_drugs_dealer_menu_'..dealerIndex,
            title = Lang.DealerContextHeader,
            options = {
                {
                    title = 'Buy Drugs',
                    icon = 'fas fa-shopping-cart',
                    onSelect = function(args)
                        lib.registerContext({
                            id = 'king_drugs_dealer_buy_menu_'..dealerIndex,
                            title = Lang.DealerBuyContextHeader,
                            disabled = menuData.enabled.buy,
                            options = menuData.data.buy,
                            onSelect = function()
                                BuyDrugs();
                            end
                        });
                        lib.showContext('king_drugs_dealer_buy_menu_'..dealerIndex);
                    end
                },
                {
                    title = 'Sell Drugs',
                    icon = 'fas fa-shopping-cart',
                    onSelect = function(args)
                        lib.registerContext({
                            id = 'king_drugs_dealer_sell_menu_'..dealerIndex,
                            title = Lang.DealerSellContextHeader,
                            disabled = menuData.enabled.sell,
                            options = menuData.data.sell,
                            onSelect = function()
                                SellDrugs();
                            end
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