--[[
    GD50
    Match-3 Remake

    -- Tile Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The individual tiles that make up our game board. Each Tile can have a
    color and a variety, with the varietes adding extra points to the matches.
]]

Tile = Class{}

function Tile:init(x, y, color, variety)
    -- board positions
    self.gridX = x
    self.gridY = y

    -- coordinate positions
    self.x = (self.gridX - 1) * 32
    self.y = (self.gridY - 1) * 32

    -- tile appearance/points
    self.color = color
    self.variety = variety

    -- 5 % chance of getting a shiny tile
    self.shine = math.random(1, 100) < 5
    print('shine status: ',self.shine)
    
end

function Tile:update(dt)

end

--[[
    Function to swap this tile with another tile, tweening the two's positions.
]]
function Tile:swap(tile)

end

function Tile:render(x, y)
    -- draw shadow
    love.graphics.setColor(34, 32, 52, 255)
    love.graphics.draw(gTextures['main'], gFrames['tiles'][self.color][self.variety],
        self.x + x + 2, self.y + y + 2)
    -- draw tile itself
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(gTextures['main'], gFrames['tiles'][self.color][self.variety],
        self.x + x, self.y + y)
    -- 10% chance of getting a shining tile
    -- render highlighted tile if it exists
    if self.shine then
        -- multiply so drawing white rect makes it brighter
        love.graphics.setBlendMode('add')

        love.graphics.setColor(255/255, 255/255, 255/255, 80/255)
        love.graphics.rectangle(
            'fill', 
            (self.gridX - 1) * 32 + (VIRTUAL_WIDTH - 272),
            (self.gridY - 1) * 32 + 16, 
            32, 
            32, 
            4
        )
        -- back to alpha
        love.graphics.setBlendMode('alpha')
    end
    
end