--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

GameObject = Class{}

function GameObject:init(def, x, y)
    -- string identifying this object type
    self.type = def.type

    self.texture = def.texture
    self.frame = def.frame or 1

    -- whether it acts as an obstacle or not
    self.solid = def.solid

    self.defaultState = def.defaultState
    self.state = self.defaultState
    self.states = def.states

    -- dimensions
    self.x = x
    self.y = y
    self.width = def.width
    self.height = def.height

    -- for pots
    self.carryMode = false
    self.throwMode = false
    self.destroy = false
    self.direction = nil
    self.directionX = nil
    self.directionY = nil

    -- default empty collision callback
    self.collidable = def.collidable
    self.onCollide = function() end
    -- self.collidable = def.collidable
    -- self.consumable = def.consumable

    -- for hearts 
    self.consumable = def.consumable
    self.onConsume = function() end
    -- self.onCollide = def.onCollide
    -- self.onConsume = def.onConsume
end

function GameObject:collides(target)
    return not (target.x > self.x + self.width or self.x > target.x + target.width or
            target.y > self.y + self.height or self.y > target.y + target.height)
end

function GameObject:update(dt)
    -- throw pot object update
    if self.throwMode == true then
        --6.3 records initial tiles to ensure pot does not go further than 4 tiles away
        --once pot lands, it changes throwMode to false in order to ensure it does not go further
        if self.direction == 'left' then
            if self.initialTileX - self.x < TILE_SIZE * 4 and self.x > 0 then
                self.x = self.x - 60 * dt
            else    
                self.throwMode = false
                self.destroy = true
            end
        elseif self.direction == 'right' then
            if self.x - self.initialTileX + self.width < TILE_SIZE * 4 and self.x < VIRTUAL_WIDTH then
                self.x = self.x + 60 * dt
            else              
                self.throwMode = false
                self.destroy = true
            end
        elseif self.direction == 'up' then
            if self.initialTileY - self.y < TILE_SIZE * 4 and self.y > 0 then
                self.y = self.y - 60 * dt
            
            else              
                self.throwMode = false
                self.destroy = true
            end
        elseif self.direction == 'down' then
            if self.y - self.initialTileY + self.height < TILE_SIZE * 4 and self.y < VIRTUAL_HEIGHT then
                self.y = self.y + 60 * dt
            else              
                self.throwMode = false
                self.destroy = true
            end
        end
    end  
end

function GameObject:render(adjacentOffsetX, adjacentOffsetY)
    love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.states[self.state].frame or self.frame],
        self.x + adjacentOffsetX, self.y + adjacentOffsetY)
end