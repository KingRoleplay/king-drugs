local Lang = Config.Languages[Config.Language];

local BuyDrugs = function()

end

local SellDrugs = function()
    
end

---@param data table
---@return false | table buyContextData
---@return false | table sellContextData
local FormateDealerMenu = function(data)
    local buyContextData = nil;
    if type(data.buy) ~= 'table' then
        buyContextData = false;
    elseif type(data.buy) == 'table' then
        buyContextData = {};
        for index, value in pairs(data.buy) do
            if Config.ContextType == 'ox' then
                buyContextData[index] = {
                    title = Lang[value.item]..' - '..value.price..'$',
                    icon = 'fas fa-cannabis'
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
                    title = Lang[value.item]..' - '..value.price..'$',
                    icon = 'fas fa-cannabis'
                };
            end
        end
    end
    return buyContextData, sellContextData;
end

---@param dealerIndex number
---@param data table
OpenDealerMenu = function(dealerIndex, data)
    local buyContextData, sellContextData = FormateDealerMenu(data.prices);
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
                            options = buyContextData,
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
                    disabled = type(sellContextData) == 'boolean' and not sellContextData,
                    onSelect = function()
                        lib.registerContext({
                            id = 'king_drugs_dealer_sell_menu_'..dealerIndex,
                            title = Lang.DealerSellContextHeader,
                            options = sellContextData,
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