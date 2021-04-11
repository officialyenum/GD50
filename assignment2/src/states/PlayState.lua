--[[
    GD50 2020
    Breakout Remake

    -- PlayState Class --

    Author: Opone Chukwuyenum
    oponechukwuyenum@gmail.com

    Represents the state of the game in which we are actively playing;
    player should control the paddle, with the ball actively bouncing between
    the bricks, walls, and the paddle. If the ball goes below the paddle, then
    the player should lose one point of health and be taken either to the Game
    Over screen if at 0 health or the Serve screen otherwise.
]]

PlayState = Class{__includes = BaseState}

--[[
    We initialize what's in our PlayState via a state table that we pass between
    states as we go from playing to serving.
]]
function PlayState:enter(params)
    self.paddle = params.paddle
    self.bricks = params.bricks
    self.health = params.health
    self.score = params.score
    self.highScores = params.highScores
    -- Assignment 2 : Multiball Powerup
    -- self.ball = params.ball
    self.balls =  {params.ball}
    self.numballs = 1

    self.level = params.level
    self.bonusLevel = 5000

    -- give ball random starting velocity
    self.balls[1].dx = math.random(-200, 200)
    self.balls[1].dy = math.random(-50, -60)

    -- Assignment 2: Powerups 
    -- Keep track of whether the user has the key powerup or not
    self.powerups = {}
    self.key = false
end

-- Mine
function PlayState:update(dt)
        if self.paused then
            if love.keyboard.wasPressed('space') then
                self.paused = false
                gSounds['pause']:play()
            else
                return
            end
        elseif love.keyboard.wasPressed('space') then
            self.paused = true
            gSounds['pause']:play()
            return
        end
        -- update positions based on velocity
        self.paddle:update(dt)
        -- Assignment 2: Multiball Powerup
        -- update multiple balls
        -- self.ball:update(dt)
        for k,ball in pairs(self.balls) do
            ball:update(dt)

            -- if ball goes below bounds, revert to serve state and decrease health
            if ball.y >= VIRTUAL_HEIGHT then
                if self.numballs <= 1 then
                    self.health = self.health - 1
                    gSounds['hurt']:play()
                    
                    -- Assignment 2 : Paddle Growth
                    -- Decrease size of paddle when ball goes below paddle
                    if self.paddle.size > 1 then
                        self.paddle:resize(self.paddle.size - 1)
                    end

                    if self.health == 0 then
                        gStateMachine:change('game-over', {
                            score = self.score,
                            highScores = self.highScores
                        })
                    else
                        print("served")
                        gStateMachine:change('serve', {
                            paddle = self.paddle,
                            bricks = self.bricks,
                            health = self.health,
                            score = self.score,
                            highScores = self.highScores,
                            level = self.level,
                            bonusLevel = self.bonusLevel
                        })
                    end
                else
                    table.remove( self.balls, k)
                    self.numballs = self.numballs - 1
                end
            end

            if ball:collides(self.paddle) then
                -- raise ball above paddle in case it goes below it, then reverse dy
                ball.y = self.paddle.y - 8
                ball.dy = -ball.dy

                --
                -- tweak angle of bounce based on where it hits the paddle
                --

                -- if we hit the paddle on its left side while moving left...
                if ball.x < self.paddle.x + (self.paddle.width / 2) and self.paddle.dx < 0 then
                    ball.dx = -50 + -(8 * (self.paddle.x + self.paddle.width / 2 - ball.x))
                
                -- else if we hit the paddle on its right side while moving right...
                elseif ball.x > self.paddle.x + (self.paddle.width / 2) and self.paddle.dx > 0 then
                    ball.dx = 50 + (8 * math.abs(self.paddle.x + self.paddle.width / 2 - ball.x))
                end

                gSounds['paddle-hit']:play()
            end

            -- Assignment 2 : Power Up
            -- Updating power up and collision detection
            for k, powerup in pairs(self.powerups) do
                powerup:update(dt)
                if powerup:collides(self.paddle) then
                    gSounds['power']:play()
                    if powerup.type < 10 then
                        -- add extra ball
                        self:bonusBalls()
                    end
                    if powerup.type == 10 then
                        self.key = true
                    end
                    table.remove(self.powerups, k)
                end
                -- remove from list if it misses the paddle
                if powerup.y > VIRTUAL_HEIGHT + 16 then
                    table.remove(self.powerups, k)
                end
            end
            
            -- detect collision across all bricks with the ball
            for k, brick in pairs(self.bricks) do

                -- only check collision if we're in play
                if brick.inPlay and ball:collides(brick) then
                    -- Assignment 2: Block Unlock
                    if self.key and brick.locked then
                        self.score = self.score + 5000
                    else if brick.locked then
                        -- do nothing
                    else
                        -- add to score
                        self.score = self.score + (brick.tier * 200 + brick.color * 25)
                    end

                    
                    -- trigger the brick's hit function, which removes it from play
                    brick:hit(self.key)

                    if self.score > self.bonusLevel then
                        -- increase health by one and do not exceed three
                        self.health = math.min(3, self.health + 1)

                        -- multiply bonus Level by 2 and do not allow bonus level to go above 200000
                        self.bonusLevel = math.min(100000, self.bonusLevel * 2)

                        -- increase paddle size
                        if self.paddle.size < 4 then
                            self.paddle:resize(self.paddle.size + 1)
                        end

                        --play recover sound effect
                        gSounds['recover']:play()
                    end

                    -- Assignment 2 : Power Up
                    -- random powerup at random intervals when hitting brick

                    -- 20 % chance of getting a power up
                    if math.random(100) < 20  then
                        -- 25 % chance its a key
                        if math.random(100) < 25 then
                            powertype = 10
                        else
                            -- random powerup from 1 to 9
                            powertype = math.random(9)
                        end
                        pwr = Powerup(powertype, ball.x, ball.y)
                        -- insert powerup into powerup list
                        table.insert(self.powerups,pwr)
                    end

                    -- go to our victory screen if there are no more bricks left
                    if self:checkVictory() then
                        gSounds['victory']:play()

                        gStateMachine:change('victory', {
                            level = self.level,
                            paddle = self.paddle,
                            health = self.health,
                            score = self.score,
                            highScores = self.highScores,
                            ball = ball,
                            bonusLevel = self.bonusLevel
                        })
                    end

                    --
                    -- collision code for bricks
                    --
                    -- we check to see if the opposite side of our velocity is outside of the brick;
                    -- if it is, we trigger a collision on that side. else we're within the X + width of
                    -- the brick and should check to see if the top or bottom edge is outside of the brick,
                    -- colliding on the top or bottom accordingly 
                    --

                    -- left edge; only check if we're moving right, and offset the check by a couple of pixels
                    -- so that flush corner hits register as Y flips, not X flips
                    if ball.x + 2 < brick.x and ball.dx > 0 then
                        
                        -- flip x velocity and reset position outside of brick
                        ball.dx = -ball.dx
                        ball.x = brick.x - 8
                    
                    -- right edge; only check if we're moving left, , and offset the check by a couple of pixels
                    -- so that flush corner hits register as Y flips, not X flips
                    elseif ball.x + 6 > brick.x + brick.width and ball.dx < 0 then
                        
                        -- flip x velocity and reset position outside of brick
                        ball.dx = -ball.dx
                        ball.x = brick.x + 32
                    
                    -- top edge if no X collisions, always check
                    elseif ball.y < brick.y then
                        
                        -- flip y velocity and reset position outside of brick
                        ball.dy = -ball.dy
                        ball.y = brick.y - 8
                    
                    -- bottom edge if no X collisions or top collision, last possibility
                    else
                        
                        -- flip y velocity and reset position outside of brick
                        ball.dy = -ball.dy
                        ball.y = brick.y + 16
                    end

                    -- slightly scale the y velocity to speed up the game
                    if math.abs(ball.dy) < 150 then
                        ball.dy = ball.dy * 1.02
                    end

                    -- only allow colliding with one brick, for corners
                    break
                end
            end
            
        end
    end
    -- for rendering particle systems
    for k, brick in pairs(self.bricks) do
        brick:update(dt)
    end
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function PlayState:render()
    -- render bricks
    for k, brick in pairs(self.bricks) do
        brick:render()
    end

    -- render all particle systems
    for k, brick in pairs(self.bricks) do
        brick:renderParticles()
    end

    self.paddle:render()

    for k, ball in pairs(self.balls) do
        ball:render()
    end
    
    for k, powerup in pairs(self.powerups) do
        powerup:render()
    end

    renderScore(self.score)
    renderHealth(self.health)

    -- Assignment 2:
    -- Show key symbol if player has key powerup
    if self.key then
        love.graphics.draw(gTextures['main'], gFrames['powerups'][10],VIRTUAL_WIDTH - 116, 3, 0, 0.6)
    end

    -- pause text, if paused
    if self.paused then
        love.graphics.setFont(gFonts['large'])
        love.graphics.printf("PAUSED", 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, 'center')
    end
end

function PlayState:bonusBalls()
    if self.numballs == 1 then
        ball2 = Ball(math.random(7))
        ball3 = Ball(math.random(7))

        ball2.x = VIRTUAL_WIDTH / 2 - 8
        ball2.y = VIRTUAL_HEIGHT / 2 - 8
        ball2.dx = self.balls[1].dx
        ball2.dy = self.balls[1].dy

        ball3.x = VIRTUAL_WIDTH / 2 - 8
        ball3.y = VIRTUAL_HEIGHT / 2 - 8
        ball3.dx = self.balls[1].dx
        ball3.dy = self.balls[1].dy
        
        table.insert(self.balls, ball2)
        table.insert(self.balls, ball3)
        self.numballs = 3
    end
end

function PlayState:checkVictory()
    for k, brick in pairs(self.bricks) do
        if brick.inPlay then
            return false
        end 
    end

    return true
end