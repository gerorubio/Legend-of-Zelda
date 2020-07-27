PlayerWalkPotState = Class{__includes = EntityWalkState}

function PlayerWalkPotState:init(player, dungeon)
	self.entity = player
	self.dungeon = dungeon
end

function PlayerWalkPotState:update(dt)
    
    self.entity.projectile.x = self.entity.x - 1
    self.entity.projectile.y = self.entity.y - 14

	if love.keyboard.isDown('left') then
        self.entity.direction = 'left'
        self.entity:changeAnimation('walk-pot-left')
    elseif love.keyboard.isDown('right') then
        self.entity.direction = 'right'
        self.entity:changeAnimation('walk-pot-right')
    elseif love.keyboard.isDown('up') then
        self.entity.direction = 'up'
        self.entity:changeAnimation('walk-pot-up')
    elseif love.keyboard.isDown('down') then
        self.entity.direction = 'down'
        self.entity:changeAnimation('walk-pot-down')
    else
        self.entity:changeState('idle-pot')
    end

    if love.keyboard.wasPressed('c') then
        local pot = self.entity.projectile
    	pot.throw = true
        pot.direction = self.entity.direction
        pot.maxDistance = self.entity:setMaxDistance()

        self.entity.projectile = nil
        self.entity:changeState('idle')
    end

    EntityWalkState.update(self, dt)
end