--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Player = Class{__includes = Entity}

function Player:init(def)
    Entity.init(self, def)
    self.projectile = nil
end

function Player:update(dt)
    Entity.update(self, dt)
end

function Player:collides(target)
    local selfY, selfHeight = self.y + self.height / 2, self.height - self.height / 2
    
    return not (self.x + self.width < target.x or self.x > target.x + target.width or
                selfY + selfHeight < target.y or selfY > target.y + target.height)
end

function Player:projectileAvailable()
    for k, object in pairs(self.room.objects) do
        if object:collides(self) then
            if object.solid then
                local obj = Projectile(
                    GAME_OBJECT_DEFS['pot'],
                    false,
                    self)
                table.insert(self.room.projectiles, obj)
                table.remove(self.room.objects, k)
                return obj
            end
        end
    end
    return nil
end

function Player:setMaxDistance()
    if self.direction == 'left' then
        return math.max(32 ,self.x - (TILE_SIZE * PROJECTILE_DISTANCE))
    elseif self.direction == 'right' then
        return math.min(336 ,self.x + (TILE_SIZE * PROJECTILE_DISTANCE))
    elseif self.direction == 'up' then
        return math.max(36 ,self.y - (TILE_SIZE * PROJECTILE_DISTANCE))
    elseif self.direction == 'down' then
        return math.min(160 ,self.y + (TILE_SIZE * PROJECTILE_DISTANCE))
    end
end

function Player:render()
    Entity.render(self)
    -- love.graphics.setColor(255, 0, 255, 255)
    -- love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
    -- love.graphics.setColor(255, 255, 255, 255)
end