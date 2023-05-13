local Lang = Config.Languages[Config.Language];

local BuyDrugs = function()

end

---@param dealerIndex number
---@param data table
local OpenDealerMenu = function(dealerIndex, data)
    -- Buy Menu --
    local buyContextData = {};
    for index, value in pairs(data.buyPrices) do
        if Config.ContextType == 'ox' then
            buyContextData[index] = {
                title = Lang[value.item]..' - '..value.price..'$',
                icon = 'fas fa-cannabis'
            };
        end
    end
    -- Sell Menu --
    local sellContextData = {};
    for index, value in pairs(data.sellPrices) do
        if Config.ContextType == 'ox' then
            sellContextData[index] = {
                title = Lang[value.item]..' - '..value.price..'$',
                icon = 'fas fa-cannabis'
            };
        end
    end
    -- Context Handler --
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
                    onSelect = function(args)
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

---@param index number
---@param data table
local AddTarget = function(index, data)
    local targetData = {
        options = {
            {
                label = Lang.DealerInteract,
                icon = 'fas fa-cannabis'
            }
        }
    };

    -- Target Options Handler --
    if Config.TargetType == 'ox_target' then
        targetData.coords = data.coords;
        targetData.size = data.target.size;
        targetData.rotation = data.heading;
        targetData.debug = data.target.debug;

        targetData.options[1].name = 'king_drugs_dealer_target_'..index;
        targetData.options[1].distance = 1.5;
        targetData.options[1].onSelect = function()
            OpenDealerMenu(index, data);
        end;
    end
    exports[Config.TargetType]:addBoxZone(targetData);
end

---@param data table
local AddControl = function(data)
    
end

CreateThread(function()
    for index, value in pairs(Config.DealerLocations) do
        -- Interation --
        if value.interaction == 'target' then
            AddTarget(index, value);
        elseif value.interaction == 'control' then
            AddControl(value);
        end
        -- Ped Creation --
        if value.blip then value.blip.id = AddBlip(value); end
        if value.ped then value.ped.id = SpawnPed(value); end
    end
end)