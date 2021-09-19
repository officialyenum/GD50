--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerCarryIdleState = Class{__includes = BaseState}

function PlayerCarryIdleState:init(player, dungeon)
    self.dungeon = dungeon
    self.player = player
        -- render offset for spaced character sprite
    self.player.offsetY = 5
    self.player.offsetX = 0

    local direction = self.player.direction
    
    local potDirection
    --self.player:changeAnimation('pot-lift-' .. tostring(self.player.direction))
    
    --if self.player.currentAnimation.timesPlayed > 1 then
        --self.player.currentAnimation.timesPlayed = 0
    self.player:changeAnimation('pot-idle-'.. tostring(self.player.direction))
    --end
end

--[[function PlayerCarryIdleState:enter(params) 
    --self.player.currentAnimation:refresh()
end]]

function PlayerCarryIdleState:update(dt)

    if love.keyboard.isDown('left') or love.keyboard.isDown('right') or
        love.keyboard.isDown('up') or love.keyboard.isDown('down') then
        self.player:changeState('carry')
    end


    local potIndex
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
    --6.3 thow pot: checks which pot is currently being lifted inorder to change boolean to thrown
        for k, object in pairs(self.dungeon.currentRoom.objects) do
            if object.carryMode == true then
                potIndex = k
            end
        end
        
        potDirection = self.player.direction
        self.dungeon.currentRoom.objects[potIndex].throwMode = true
        self.dungeon.currentRoom.objects[potIndex].carryMode = false
        self.dungeon.currentRoom.objects[potIndex].direction = potDirection
        self.dungeon.currentRoom.objects[potIndex].initialTileX = self.player.x
        self.dungeon.currentRoom.objects[potIndex].initialTileY = self.player.y
        self.player:changeState('idle')
    end

    --[[if self.player.currentAnimation.timesPlayed == 1 then
        --self.player.currentAnimation.timesPlayed = 0
        self.player:changeAnimation('carry-idle-'.. tostring(self.player.direction))
    end]]

end

function PlayerCarryIdleState:render()
    local anim = self.player.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.player.x - self.player.offsetX), math.floor(self.player.y - self.player.offsetY))
end