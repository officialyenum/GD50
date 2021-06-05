--[[
    GD50
    Match-3 Remake

    -- Board Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The Board is our arrangement of Tiles with which we must try to find matching
    sets of three horizontally or vertically.
]]

Board = Class{}

function Board:init(x, y, level)
    self.x = x
    self.y = y
    self.matches = {}
    -- Assignment solution 2 add level here
    self.level = level

    self:initializeTiles()
end

function Board:initializeTiles()
    print()
    self.tiles = {}

    if self.level == nil then
        self.level = 1
    end

    for tileY = 1, 8 do
        
        -- empty table that will serve as a new row
        table.insert(self.tiles, {})

        for tileX = 1, 8 do
            -- create a new tile at X,Y with a random color and variety based on level
            if self.level == 1 then
                table.insert(self.tiles[tileY], Tile(tileX, tileY, math.random(18), 1))
            else
                table.insert(self.tiles[tileY], Tile(tileX, tileY, math.random(18), math.random(6)))
            end
        end
    end

    while self:calculateMatches() do
        -- recursively initialize if matches were returned so we always have
        -- a matchless board on start
        self:initializeTiles()
    end
end

--[[
    Goes left to right, top to bottom in the board, calculating matches by counting consecutive
    tiles of the same color. Doesn't need to check the last tile in every row or column if the 
    last two haven't been a match.
]]
function Board:calculateMatches()
    local matches = {}

    -- how many of the same color blocks in a row we've found
    local matchNum = 1

    -- horizontal matches first
    for y = 1, 8 do
        local colorToMatch = self.tiles[y][1].color

        matchNum = 1
        
        -- every horizontal tile
        for x = 2, 8 do
            -- if this is the same color as the one we're trying to match...
            if self.tiles[y][x].color == colorToMatch then
                matchNum = matchNum + 1
            else
                -- set this as the new color we want to watch for
                colorToMatch = self.tiles[y][x].color

                -- if we have a match of 3 or more up to now, add it to our matches table
                if matchNum >= 3 then
                    local match = {}

                    -- go backwards from here by matchNum
                    for x2 = x - 1, x - matchNum, -1 do
                        -- add each tile to the match that's in that match
                        table.insert(match, self.tiles[y][x2])
                    end

                    -- add this match to our total matches table
                    table.insert(matches, match)
                end

                -- don't need to check last two if they won't be in a match
                if x >= 7 then
                    break
                end

                matchNum = 1
            end
        end

        -- account for the last row ending with a match
        if matchNum >= 3 then
            local match = {}
            
            -- go backwards from end of last row by matchNum
            for x = 8, 8 - matchNum + 1, -1 do
                table.insert(match, self.tiles[y][x])
            end

            table.insert(matches, match)
        end
    end

    -- vertical matches
    for x = 1, 8 do
        local colorToMatch = self.tiles[1][x].color

        matchNum = 1

        -- every vertical tile
        for y = 2, 8 do
            if self.tiles[y][x].color == colorToMatch then
                matchNum = matchNum + 1
            else
                colorToMatch = self.tiles[y][x].color

                if matchNum >= 3 then
                    local match = {}

                    for y2 = y - 1, y - matchNum, -1 do
                        table.insert(match, self.tiles[y2][x])
                    end

                    table.insert(matches, match)
                end

                matchNum = 1

                -- don't need to check last two if they won't be in a match
                if y >= 7 then
                    break
                end
            end
        end

        -- account for the last column ending with a match
        if matchNum >= 3 then
            local match = {}
            
            -- go backwards from end of last row by matchNum
            for y = 8, 8 - matchNum, -1 do
                table.insert(match, self.tiles[y][x])
            end

            table.insert(matches, match)
        end
    end

    -- store matches for later reference
    self.matches = matches

    -- return matches table if > 0, else just return false
    return #self.matches > 0 and self.matches or false
end

function Board:checkForMatches()
    -- swap tiles from left to right and top to bottom
    -- check for matches per swap 
    -- board is 8 x 8 

    -- check column and rows for matches
    for y = 1, 7 do
        for x = 1, 7 do
            if self:swapTwoTilesAndCheckForMatch(y, x, y, x + 1) or self:swapTwoTilesAndCheckForMatch(y, x, y + 1, x) then
                return true
            end
        end
    end

    -- check last row matches
    for x = 1, 7 do
        if self:swapTwoTilesAndCheckForMatch(8, x, 8, x + 1) then
            return true
        end
    end

    -- check last column matches
    for y = 1, 7 do
        if self:swapTwoTilesAndCheckForMatch(y, 8, y + 1, 8) then
            return true
        end
    end

    -- return false
    return false
end

-- This function checks if there is a match when two tiles are swapped -- using the temporary container swapping method from earlier tutorial
function Board:swapTwoTilesAndCheckForMatch(tile1y,tile1x,tile2y,tile2x)
    -- store tiles in temporary variables
    local tempTile1 = self.tiles[tile1y][tile1x]
    local tempTile2 = self.tiles[tile2y][tile2x]

    -- store grid positions of temp tiles in temporary variables
    local tempGridX1 = self.tiles[tile1y][tile1x].gridX
    local tempGridY1 = self.tiles[tile1y][tile1x].gridY
    local tempGridX2 = self.tiles[tile2y][tile2x].gridX
    local tempGridY2 = self.tiles[tile2y][tile2x].gridY

    -- swap grid positions of temporary tiles
    tempTile1.gridX = tempGridX2
    tempTile1.gridY = tempGridY2
    tempTile2.gridX = tempGridX1
    tempTile2.gridy = tempGridy1

    -- update temporary tiles on the board table
    self.tiles[tempTile1.gridY][tempTile1.gridX] = tempTile1
    self.tiles[tempTile2.gridY][tempTile2.gridX] = tempTile2

    -- calculate match after this swap for result
    local match = false
    if self:calculateMatches() ~= false then
        match = true
    end

    -- reverse changes so tiles can return to how it was before the swap
    tempTile1.gridX = tempGridX1
    tempTile1.gridY = tempGridY1
    tempTile2.gridX = tempGridX2
    tempTile2.gridY = tempGridY2

    -- add reversed changes to the board
    self.tiles[tempTile1.gridY][tempTile1.gridX] = tempTile1
    self.tiles[tempTile2.gridY][tempTile2.gridX] = tempTile2

    -- return if it is a match or not
    return match;

    -- self.highlightedTile.gridX = newTile.gridX
    -- self.highlightedTile.gridY = newTile.gridY
    -- newTile.gridX = tempX
    -- newTile.gridY = tempY

    -- swap tiles in the tiles table
    -- self.board.tiles[self.highlightedTile.gridY][self.highlightedTile.gridX] =
    --     self.highlightedTile

    -- self.board.tiles[newTile.gridY][newTile.gridX] = newTile
end
--[[
    Remove the matches from the Board by just setting the Tile slots within
    them to nil, then setting self.matches to nil.
]]
function Board:removeMatches()
    for k, match in pairs(self.matches) do
        for k, tile in pairs(match) do
            self.tiles[tile.gridY][tile.gridX] = nil
        end
    end

    self.matches = nil
end

--[[
    Shifts down all of the tiles that now have spaces below them, then returns a table that
    contains tweening information for these new tiles.
]]
function Board:getFallingTiles()
    -- tween table, with tiles as keys and their x and y as the to values
    local tweens = {}

    -- for each column, go up tile by tile till we hit a space
    for x = 1, 8 do
        local space = false
        local spaceY = 0

        local y = 8
        while y >= 1 do
            -- if our last tile was a space...
            local tile = self.tiles[y][x]
            
            if space then
                -- if the current tile is *not* a space, bring this down to the lowest space
                if tile then
                    -- put the tile in the correct spot in the board and fix its grid positions
                    self.tiles[spaceY][x] = tile
                    tile.gridY = spaceY

                    -- set its prior position to nil
                    self.tiles[y][x] = nil

                    -- tween the Y position to 32 x its grid position
                    tweens[tile] = {
                        y = (tile.gridY - 1) * 32
                    }

                    -- set space back to 0, set Y to spaceY so we start back from here again
                    space = false
                    y = spaceY
                    spaceY = 0
                end
            elseif tile == nil then
                space = true
                
                if spaceY == 0 then
                    spaceY = y
                end
            end

            y = y - 1
        end
    end

    -- create replacement tiles at the top of the screen
    for x = 1, 8 do
        for y = 8, 1, -1 do
            local tile = self.tiles[y][x]

            -- if the tile is nil, we need to add a new one
            if not tile then
                -- local tile
                if self.level == 1 then
                    tile = Tile(x, y, math.random(18), 1)
                else
                    tile = Tile(x, y, math.random(18), math.random(6))
                end
                tile.y = -32
                self.tiles[y][x] = tile

                tweens[tile] = {
                    y = (tile.gridY - 1) * 32
                }
            end
        end
    end

    return tweens
end

function Board:getNewTiles()
    return {}
end

function Board:render()
    for y = 1, #self.tiles do
        for x = 1, #self.tiles[1] do
            self.tiles[y][x]:render(self.x, self.y)
        end
    end
end