--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Entity = Class{}

function Entity:init(def)

    -- in top-down games, there are four directions instead of two
    self.direction = 'down'

    self.animations = self:createAnimations(def.animations)

    -- dimensions
    self.x = def.x
    self.y = def.y
    self.width = def.width
    self.height = def.height

    -- drawing offsets for padded sprites
    self.offsetX = def.offsetX or 0
    self.offsetY = def.offsetY or 0

    self.walkSpeed = def.walkSpeed

    self.health = def.health
    self.room = def.room

    -- flags for flashing the entity when hit
    self.invulnerable = false
    self.invulnerableDuration = 0
    self.invulnerableTimer = 0
    self.flashTimer = 0

    self.dead = false
    self.heart = true
end

function Entity:createAnimations(animations)
    local animationsReturned = {}

    for k, animationDef in pairs(animations) do
        animationsReturned[k] = Animation {
            texture = animationDef.texture or 'entities',
            frames = animationDef.frames,
            interval = animationDef.interval
        }
    end

    return animationsReturned
end

--[[
    AABB with some slight shrinkage of the box on the top side for perspective.
]]
function Entity:collides(target)
    return not (self.x + self.width < target.x or self.x > target.x + target.width or
                self.y + self.height < target.y or self.y > target.y + target.height)
end

function Entity:damage(dmg)
    self.health = self.health - dmg
    local heart = nil
    if self.health <= 0 then
        if (math.random() > 0.80 and self.heart) then
            heart = GameObject(
                GAME_OBJECT_DEFS['heart'],
                self.x,
                self.y)
        end        
        self.x = 10000
        self.y = 10000
    end
    self.heart = false
    return heart
end

function Entity:goInvulnerable(duration)
    self.invulnerable = true
    self.invulnerableDuration = duration
end

function Entity:changeState(name)
    self.stateMachine:change(name)
end

function Entity:changeAnimation(name)
    self.currentAnimation = self.animations[name]
end

function Entity:checkLeftCollitions(dt)
    local coliideObjects = self:checkObjectCollisions()

    if #coliideObjects > 0 then
        self.x = self.x + PLAYER_WALK_SPEED * dt
    end
end

function Entity:checkRightCollitions(dt)
    local coliideObjects = self:checkObjectCollisions()

    if #coliideObjects > 0 then
        self.x = self.x - PLAYER_WALK_SPEED * dt
    end
end

function Entity:checkUpCollitions(dt)
    local coliideObjects = self:checkObjectCollisions()

    if #coliideObjects > 0 then
        self.y = self.y + PLAYER_WALK_SPEED * dt
    end
end

function Entity:checkDownCollitions(dt)
    local coliideObjects = self:checkObjectCollisions()

    if #coliideObjects > 0 then
        self.y = self.y - PLAYER_WALK_SPEED * dt
    end
end

function Entity:checkObjectCollisions()
    local collideObjects = {}

    for k, object in pairs(self.room.objects) do
        if object:collides(self) then
            if object.solid then
                table.insert(collideObjects, object)
            end
        end
    end

    return collideObjects
end

function Entity:update(dt)
    if self.invulnerable then
        self.flashTimer = self.flashTimer + dt
        self.invulnerableTimer = self.invulnerableTimer + dt

        if self.invulnerableTimer > self.invulnerableDuration then
            self.invulnerable = false
            self.invulnerableTimer = 0
            self.invulnerableDuration = 0
            self.flashTimer = 0
        end
    end

    self.stateMachine:update(dt)

    if self.currentAnimation then
        self.currentAnimation:update(dt)
    end
end

function Entity:processAI(params, dt)
    self.stateMachine:processAI(params, dt)
end

function Entity:render(adjacentOffsetX, adjacentOffsetY)
    -- draw sprite slightly transparent if invulnerable every 0.04 seconds
    if self.invulnerable and self.flashTimer > 0.06 then
        self.flashTimer = 0
        love.graphics.setColor(255, 255, 255, 64)
    end

    self.x, self.y = self.x + (adjacentOffsetX or 0), self.y + (adjacentOffsetY or 0)
    self.stateMachine:render()
    love.graphics.setColor(255, 255, 255, 255)
    self.x, self.y = self.x - (adjacentOffsetX or 0), self.y - (adjacentOffsetY or 0)
end