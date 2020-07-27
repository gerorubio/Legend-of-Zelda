--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerIdleState = Class{__includes = EntityIdleState}

function PlayerIdleState:enter(params)
    -- render offset for spaced character sprite
    self.entity.offsetY = 5
    self.entity.offsetX = 0
end

function PlayerIdleState:update(dt)
    if love.keyboard.isDown('left') or love.keyboard.isDown('right') or
       love.keyboard.isDown('up') or love.keyboard.isDown('down') then
        self.entity:changeState('walk')
    end

    if love.keyboard.wasPressed('space') then
        self.entity:changeState('swing-sword')
    end

    if love.keyboard.wasPressed('c') then
        local obj = nil
        
        if self.entity.direction == 'down' then
            self.entity.y = self.entity.y + 1
            obj = self.entity:projectileAvailable()
            self.entity.y = self.entity.y - 1
        elseif self.entity.direction == 'up' then
            self.entity.y = self.entity.y - 1
            obj = self.entity:projectileAvailable()
            self.entity.y = self.entity.y + 1
        elseif self.entity.direction == 'left' then
            self.entity.x = self.entity.x - 1
            obj = self.entity:projectileAvailable()
            self.entity.x = self.entity.x + 1
        elseif self.entity.direction == 'right' then
            self.entity.x = self.entity.x + 1
            obj = self.entity:projectileAvailable()
            self.entity.x = self.entity.x - 1
        end

        if obj ~= nil then
            self.entity.projectile = obj
            self.entity:changeState('lift-pot')
        end
    end
end