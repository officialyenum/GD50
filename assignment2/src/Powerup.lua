--[[
    GD50
    Breakout Remake

    -- Powerup Class --

    Author: Opone Chukwuyenum
    oponechukwuyenum@gmail.com

    Represents a Powerup that adds special features to gameplay, 
    creating duplicate balls
    health increase
    paddle increase etc.
]]

Powerup = Class{}

--[[
    Our Powerup will initialize at different spot every time a brick hit condition is met, 
    and it drops toward the bottom, if the paddle collides with it it activates the powerup type.
]]

function Powerup:init(type, x, y)
    -- starting dimensions
    self.width = 16
    self.height = 16

    -- x is placed in brick x position on brick hit
    self.x = x

    -- y is placed in brick y position on brick hit
    self.y = y

    -- start off with y axis velocity this allow the powerup fall downwards
    self.dy = 40
    self.dx = 0

    -- this is the type of power up
    self.type = type

    -- on initialization let playstate be true
    self.inPlay = true
end

function Powerup:collides(target)
    -- first, check to see if the left edge of either is farther to the right
    -- than the right edge of the other
    if self.x > target.x + target.width or target.x > self.x + self.width then
        return false
    end

    -- then check to see if the bottom edge of either is higher than the top
    -- edge of the other
    if self.y > target.y + target.height or target.y > self.y + self.height then
        return false
    end 

    -- if the above aren't true, they're overlapping
    return true
end

function Powerup:update(dt)
    -- allow powerup to fall down
    if self.y < VIRTUAL_HEIGHT then
        self.y = self.y + self.dy * dt
    end
end

function Powerup:render()
    if self.inPlay then
        love.graphics.draw(gTextures['main'],gFrames['powerups'][self.type],self.x,self.y)
    end
end