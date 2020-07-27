--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Projectile = Class{__includes = GameObject}

function Projectile:init(def, solid, player)
	self.type = def.type
	self.texture = def.texture
	self.frame = def.frame
	self.solid = solid
	self.defaultState = def.defaultState
	self.state = self.defaultState
	self.states = def.states
	self.x = math.floor(player.x - 1)
	self.y = math.floor(player.y - 12)
	self.width = def.width
	self.height = def.height
	self.throw = false
	self.direction = nil
	self.player = player
	self.room = player.room
	self.maxDistance = nil
	self.speed = def.speed
end

function Projectile:update(dt)
	if self.state == 'normal' then
		if self.throw then
			if self.direction == 'left' then
				self.x = self.x - (dt * self.speed)
				self:checkDistance()
			elseif self.direction == 'right' then
				self.x = self.x + (dt * self.speed)
				self:checkDistance()
			elseif self.direction == 'up' then
				self.y = self.y - (dt * self.speed)
				self:checkDistance()
			elseif self.direction == 'down' then
				self.y = self.y + (dt * self.speed)
				self:checkDistance()
			end

			if self:hitEnemy() then
				self:setBroke()
			end
		else
			self.x = self.player.x
			self.y = self.player.y - 12
		end
	end
end

function Projectile:hitEnemy(enemy)
	for k, enemy in pairs(self.room.entities) do
		if self:collides(enemy) then
			local heart = enemy:damage(1)
			if heart ~= nil then
                table.insert(self.room.objects, heart)
            end
            gSounds['hit-enemy']:play()
			return true
		end
	end
	return false
end

function Projectile:setBroke()
	self.state = 'broken'
	self.x = math.floor(self.x)
	self.y = math.floor(self.y)
	local pot = GameObject(
		GAME_OBJECT_DEFS['pot'],
		self.x,
		self.y)
	pot.state = 'broken'
	pot.solid = false
	table.insert(self.room.objects, pot)
end

function Projectile:checkDistance()
	print(self.maxDistance)
	if (self.direction == 'left' and self.x <= self.maxDistance) then
		self:setBroke()
	elseif (self.direction == 'right' and self.x >= self.maxDistance) then
		self:setBroke()
	elseif (self.direction == 'up' and self.y <= self.maxDistance) then
		self:setBroke()
	elseif (self.direction == 'down' and self.y >= self.maxDistance) then
		self:setBroke()
	end
end

function Projectile:render()
	if self.state == 'normal' then
		love.graphics.draw(gTextures[self.texture],
			gFrames[self.texture][self.states[self.state].frame or self.frame],
			self.x,
			self.y)
	end
end

