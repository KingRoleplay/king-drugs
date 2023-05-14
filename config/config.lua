Config = Config or {};

-- Main Configuration --

Config.Language = 'en'; -- en or bg
Config.ZoneType = 'ox'; -- ox (ox_lib zones), poly (bt-polyzone) or distance (fivem)
Config.ControlInteraction = 'control'; -- okokTextUI, 3DText
Config.TargetType = 'ox_target'; -- ox_target, qtarget, bt-target or qb-target
Config.ContextType = 'ox'; -- ox (ox_lib context), nh-context, zf-context or qb-menu

-- Dealer Configuration --

Config.DealerLocations = {
    [1] = {
        -- The Coords and Heading can be global for the table or for each option different
        interaction = {
            type = 'target', -- target or control
            coords = vec3(-117.7423, 6348.8779, 31.4904),
            heading = 50.7063,
            debug = false, -- Only for target
            size = vec3(1, 1, 2) -- vector3 for target number for control
        },
        prices = {
            buy = {
                [1] = { item ='heroin', price = 8 },
                [2] = { item = 'marijuana', price = 15 },
                [3] = { item = 'meth', price = 35 },
                [4] = { item = 'cocaine', price = 60 }
            },
            sell = {
                [1] = { item = 'heroin', price = 5 },
                [2] = { item = 'marijuana', price = 10 },
                [3] = { item = 'meth', price = 25 },
                [4] = { item = 'cocaine', price = 50 }
            }
        },
        ped = { -- Table or false
            model = 'g_m_y_ballaeast_01',
            coords = vec3(-117.7423, 6348.8779, 31.4904),
            heading = 50.7063
        },
        blip = { -- Table or false
            sprite = 51,
            color = 2,
            scale = 0.8,
            label = 'Dealer',
            coords = vec3(-117.7423, 6348.8779, 31.4904)
        }
    }
};