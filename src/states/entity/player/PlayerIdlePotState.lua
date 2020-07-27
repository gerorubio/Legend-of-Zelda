PlayerIdlePotState = Class{__includes = EntityIdleState}

function PlayerIdlePotState:enter(params)
	-- render offset for spaced character sprite
    self.entity.offsetY = 5
    self.entity.offsetX = 0
    self.entity:changeAnimation('idle-pot-' .. self.entity.direction)
end



function PlayerIdlePotState:update(dt)

	if love.keyboard.isDown('left') or love.keyboard.isDown('right') or
       love.keyboard.isDown('up') or love.keyboard.isDown('down') then
        self.entity:changeState('walk-pot')
    end

    if love.keyboard.wasPressed('c') then
        local pot = self.entity.projectile
        pot.throw = true
        pot.direction = self.entity.direction
        pot.maxDistance = self.entity:setMaxDistance()
        self.entity.projectile = nil
        self.entity:changeState('idle')
    end
end

function PlayerIdlePotState:render()
	local anim = self.entity.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.entity.x - self.entity.offsetX), math.floor(self.entity.y - self.entity.offsetY))
end