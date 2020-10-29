--[[
    ScoreState Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    A simple state used to display the player's score before they
    transition back into the play state. Transitioned to from the
    PlayState when they collide with a Pipe.
]]

local gold = love.graphics.newImage('gold.png')
local silver = love.graphics.newImage('silver.png')
local bronze = love.graphics.newImage('bronze.png')
local ruby = love.graphics.newImage('ruby.png')

ScoreState = Class{__includes = BaseState}

--[[
    When we enter the score state, we expect to receive the score
    from the play state so we know what to render to the State.
]]

-- local imageWidth = gold:getWidth()
-- local imageHeight = gold:getHeight()

-- local imageX = VIRTUAL_WIDTH / 2 - (imageWidth/2)
-- local imageY = VIRTUAL_HEIGHT / 2 - (imageHeight/2)

function ScoreState:enter(params)
    self.score = params.score
end

function ScoreState:update(dt)
    -- go back to play if enter is pressed
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown')
    end
end

function ScoreState:render()
    -- simply render the score to the middle of the screen
    -- Assignment 1 solution Display medal
    if self.score <= 5 then
        love.graphics.setFont(flappyFont)
        love.graphics.printf('BRONZE : Oof! You lost!', 0, 64, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(mediumFont)
        love.graphics.printf('Score: ' .. tostring(self.score), 0, 100, VIRTUAL_WIDTH, 'center')
        love.graphics.draw(bronze, VIRTUAL_WIDTH/2 - 40, VIRTUAL_HEIGHT/2 - 20, 0, 0.3, 0.3)

        love.graphics.printf('Press Enter to Play Again!', 0, 200, VIRTUAL_WIDTH, 'center')

    elseif self.score <= 15 then
        love.graphics.setFont(flappyFont)
        love.graphics.printf('SILVER : Nice But you Can do better!', 0, 64, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(mediumFont)
        love.graphics.printf('Score: ' .. tostring(self.score), 0, 100, VIRTUAL_WIDTH, 'center')
        love.graphics.draw(silver, VIRTUAL_WIDTH/2 - 40, VIRTUAL_HEIGHT/2 - 20, 0, 0.3, 0.3)

        love.graphics.printf('Press Enter to Play Again!', 0, 200, VIRTUAL_WIDTH, 'center')

    elseif self.score <= 30 then
        love.graphics.setFont(flappyFont)
        love.graphics.printf('GOLD!!! :Great Job!', 0, 64, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(mediumFont)
        love.graphics.printf('Score: ' .. tostring(self.score), 0, 100, VIRTUAL_WIDTH, 'center')
        love.graphics.draw(gold, VIRTUAL_WIDTH/2 - 40, VIRTUAL_HEIGHT/2 - 20, 0, 0.3, 0.3)


        love.graphics.printf('Press Enter to Play Again!', 0, 200, VIRTUAL_WIDTH, 'center')

    elseif self.score > 30 then
        love.graphics.setFont(flappyFont)
        love.graphics.printf('RUBY!!! : Magnificient!', 0, 64, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(mediumFont)
        love.graphics.printf('Score: ' .. tostring(self.score), 0, 100, VIRTUAL_WIDTH, 'center')
        love.graphics.draw(ruby, VIRTUAL_WIDTH/2 - 40, VIRTUAL_HEIGHT/2 - 20, 0, 0.3, 0.3)
        love.graphics.printf('Press Enter to Play Again!', 0, 200, VIRTUAL_WIDTH, 'center')
    end

end