--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

GAME_OBJECT_DEFS = {
    ['switch'] = {
        type = 'switch',
        texture = 'switches',
        frame = 2,
        width = 16,
        height = 16,
        solid = false,
        defaultState = 'unpressed',
        collidable = false,
        consumable = false,
        states = {
            ['unpressed'] = {
                frame = 2
            },
            ['pressed'] = {
                frame = 1
            }
        }
    },
    ['pot'] = {
        -- TODO
        type = 'pot',
        texture = 'tiles',
        frame = 16,
        width = 16,
        height = 16,
        solid = true,
        defaultState = 'available',
        collidable = true,
        consumable = false,
        states = {
            ['available'] = {
                frame = 16
            },
            ['thrown'] = {
                frame = 54
            }
        }
    },
    ['heart'] = {
        -- TODO
        type = 'heart',
        texture = 'hearts',
        frame = 5,
        width = 16,
        height = 16,
        solid = false,
        collidable = true,
        consumable = true,
        defaultState = 'available',
        states = {
            ['available'] = {
                frame = 5
            },
        }
    }
}