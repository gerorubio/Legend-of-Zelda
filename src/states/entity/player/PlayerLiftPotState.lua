PlayerLiftPotState = Class{__includes = BaseState}

function PlayerLiftPotState:init(player, obj)
	self.player = player
	local direction = self.player.direction

	self.player:changeAnimation('lift-' .. direction)
end

function PlayerLiftPotState:enter(params)
	self.player.currentAnimation:refresh()
end

function PlayerLiftPotState:update(dt)
	if self.player.currentAnimation.timesPlayed > 0 then
        self.player.currentAnimation.timesPlayed = 0
        self.player:changeState('idle-pot')
    end
end

function PlayerLiftPotState:render()
	local anim = self.player.currentAnimation
	love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.player.x - self.player.offsetX), math.floor(self.player.y - self.player.offsetY))
end