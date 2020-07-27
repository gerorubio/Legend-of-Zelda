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
        type = 'pots',
        texture = 'pots',
        frame = 1,
        width = 13,
        height = 13,
        solid = true,
        defaultState = 'normal',
        states = {
            ['normal'] = {
                frame = 1
            },
            ['broken'] = {
                frame = 3
            }
        },
        speed = 170
    },

    ['heart'] = {
        type = 'hearts',
        texture = 'hearts',
        frame = 5,
        width = 16,
        height = 16,
        solid = false,
        defaultState = 'normal',
        states = {
            ['normal'] = {
                frame = 5
            }
        },
        collidable = true,
        consumbale = true,
        onConsume = function(player, object)
            gSounds['pickup']:play()
            player.health = math.min(6, player.health + 2)
        end
    }
}