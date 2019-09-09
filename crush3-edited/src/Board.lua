--[[
   CMPE40032
    Candy Crush Clone (Match 3 Game)

    -- Board Class --



    The Board is our arrangement of Tiles with which we must try to find matching
    sets of three horizontally or vertically.
]]

Board = Class{}

function Board:init(x, y, level)
    self.x = x
    self.y = y
    self.matches = {}

    self.level = level
    
    self:initializeTiles()
end

function Board:initializeTiles()
    self.tiles = {}

    for tileY = 1, 8 do

        -- empty table that will serve as a new row
        table.insert(self.tiles, {})
        
        for tileX = 1, 8 do
            -- create a new tile at X,Y with a random color and variety...
            if self.level > 0 and self.level < 3 then
                table.insert(self.tiles[tileY], Tile(tileX, tileY, math.random(1, 8), math.random(1)))
            elseif self.level > 2 and self.level < 5 then
                table.insert(self.tiles[tileY], Tile(tileX, tileY, math.random(11, 18), math.random(2)))
            elseif self.level > 4 and self.level < 7 then
                table.insert(self.tiles[tileY], Tile(tileX, tileY, math.random(1, 9), math.random(3)))
            elseif self.level > 6 and self.level < 9 then
                table.insert(self.tiles[tileY], Tile(tileX, tileY, math.random(10, 18), math.random(4)))
            elseif self.level > 8 and self.level < 11 then
                table.insert(self.tiles[tileY], Tile(tileX, tileY, math.random(1, 10), math.random(5)))
            elseif self.level > 10 and self.level < 13 then
                table.insert(self.tiles[tileY], Tile(tileX, tileY, math.random(9, 18), math.random(6)))
            elseif self.level > 12 and self.level < 15 then
                table.insert(self.tiles[tileY], Tile(tileX, tileY, math.random(1, 11), math.random(6)))
            elseif self.level > 14 and self.level < 17 then
                table.insert(self.tiles[tileY], Tile(tileX, tileY, math.random(8, 18), math.random(6)))
            elseif self.level > 16 and self.level < 19 then
                table.insert(self.tiles[tileY], Tile(tileX, tileY, math.random(5, 16), math.random(6)))
            elseif self.level > 18 and self.level < 21 then
                table.insert(self.tiles[tileY], Tile(tileX, tileY, math.random(2, 13), math.random(6)))
            elseif self.level > 20 then
                table.insert(self.tiles[tileY], Tile(tileX, tileY, math.random(1, 12), math.random(6)))
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

    --  color blocks in a row 
    local matchNum = 1

    -- horizontal matches first
    for y = 1, 8 do
        
        -- check if tile is shiny
        local shinyMatch = false

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
                        if self.tiles[y][x2].shiny then
                            shinyMatch = true
                        end
                    end

                    -- shiny match, add tiles to match in the row 
                    if shinyMatch then
                        for rowX = 1, 8 do
                            table.insert(match, self.tiles[y][rowX])
                        end
                    else
                        -- go backwards from here by matchNum
                        for x2 = x - 1, x - matchNum, -1 do
                            -- add each tile to the match that's in that match
                            table.insert(match, self.tiles[y][x2])
                        end
                    end

                    -- add this match to our total matches table
                    table.insert(matches, match)
                end

                matchNum = 1

                -- don't need to check last two if they won't be in a match
                if x >= 7 then
                    break
                end
            end
        end

        -- account for the last row ending with a match
        if matchNum >= 3 then
           local match = {}
        -- go backwards from end of last row by matchNum
            for x = 8, 8 - matchNum + 1, -1 do
                --checking if shiny tiles match
                if self.tiles[y][x].shiny then
                    shinyMatch = true
                end
            end
            
            -- shiny match, add tiles to match  in the row
            if shinyMatch then
                for rowX = 1, 8 do
                    table.insert(match, self.tiles[y][rowX])
                end
            else
                -- go backwards from end of last row by matchNum
                for x = 8, 8 - matchNum + 1, -1 do
                    table.insert(match, self.tiles[y][x])
                end
            end

            table.insert(matches, match)
        end
    end

    -- vertical matches
    for x = 1, 8 do
        local shinyMatch = false
        
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
                        if self.tiles[y2][x].shiny then
                            shinyMatch = true
                        end
                    end

                   -- shiny match , add tiles to match in a column
                    if shinyMatch then
                        for columnY = 1, 8 do
                            table.insert(match, self.tiles[columnY][x])
                        end
                    else
                        for y2 = y - 1, y - matchNum, -1 do
                            table.insert(match, self.tiles[y2][x])
                        end
                    end
                    ------------------------------------------------------
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

            for y = 8, 8 - matchNum, -1 do
                if self.tiles[y][x].shiny then
                    shinyMatch = true
                end
            end
            
            -- shiny match, add tiles to match in a column
            if shinyMatch then
                for columnY = 1, 8 do
                    table.insert(match, self.tiles[columnY][x])
                end
            else
                -- go backwards from end of last row by matchNum
                for y = 8, 8 - matchNum, -1 do
                    table.insert(match, self.tiles[y][x])
                end
            end

            table.insert(matches, match)
        end
    end

    -- store matches for later reference
    self.matches = matches

    -- return matches table if > 0, else just return false
    return #self.matches > 0 and self.matches or false
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
            
             --add tiles, for levels

            if not tile then
                
                if self.level > 0 and 3 > self.level then
                    local tile = Tile(x, y, math.random(1, 8), math.random(1))
                    tile.y = -32
                    self.tiles[y][x] = tile
                    tweens[tile] = {
                        y = (tile.gridY - 1) * 32
                    }
                elseif self.level > 2 and 5 > self.level then
                    local tile = Tile(x, y, math.random(11, 18), math.random(2))
                    tile.y = -32
                    self.tiles[y][x] = tile
                    tweens[tile] = {
                        y = (tile.gridY - 1) * 32
                    }
                elseif self.level > 4 and 7 > self.level then
                    local tile = Tile(x, y, math.random(1, 9), math.random(3))
                    tile.y = -32
                    self.tiles[y][x] = tile
                    tweens[tile] = {
                        y = (tile.gridY - 1) * 32
                    }
                elseif self.level > 6 and 9 > self.level then
                    local tile = Tile(x, y, math.random(10, 18), math.random(4))
                    tile.y = -32
                    self.tiles[y][x] = tile
                    tweens[tile] = {
                        y = (tile.gridY - 1) * 32
                    }
                elseif self.level > 8 and 11 > self.level then
                    local tile = Tile(x, y, math.random(1, 10), math.random(5))
                    tile.y = -32
                    self.tiles[y][x] = tile
                    tweens[tile] = {
                        y = (tile.gridY - 1) * 32
                    }
                elseif self.level > 10 and 13 > self.level then
                    local tile = Tile(x, y, math.random(9, 18), math.random(6))
                    tile.y = -32
                    self.tiles[y][x] = tile
                    tweens[tile] = {
                        y = (tile.gridY - 1) * 32
                    }
                elseif self.level > 12 and 15 > self.level then
                    local tile = Tile(x, y, math.random(1, 11), math.random(6))
                    tile.y = -32
                    self.tiles[y][x] = tile
                    tweens[tile] = {
                        y = (tile.gridY - 1) * 32
                    }
                elseif self.level > 14 and 17 > self.level then
                    local tile = Tile(x, y, math.random(8, 18), math.random(6))
                    tile.y = -32
                    self.tiles[y][x] = tile
                    tweens[tile] = {
                        y = (tile.gridY - 1) * 32
                    }
                elseif self.level > 16 and 19 > self.level then
                    local tile = Tile(x, y, math.random(5, 16), math.random(6))
                    tile.y = -32
                    self.tiles[y][x] = tile
                    tweens[tile] = {
                        y = (tile.gridY - 1) * 32
                    }
                elseif self.level > 18 and 21 > self.level then
                    local tile = Tile(x, y, math.random(2, 13), math.random(6))
                    tile.y = -32
                    self.tiles[y][x] = tile
                    tweens[tile] = {
                        y = (tile.gridY - 1) * 32
                    }
                elseif self.level > 20 and 23 > self.level then
                    local tile = Tile(x, y, math.random(1, 12), math.random(6))
                    tile.y = -32
                    self.tiles[y][x] = tile
                    tweens[tile] = {
                        y = (tile.gridY - 1) * 32
                    }
                end
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

-- finding matches
function Board:findMatches()
    
    local matchTable = {}

    for x = 1, 8 do
        for y = 1, 8 do
            local x2 = x
            local y2 = y

            for y2 = y - 1, y + 1, 2 do
                if y2 < 1 or y2 > 8 then
                    break
                end

                local testBoard = Class.clone(self)
                local tile = testBoard.tiles[y][x]
                local newTile = testBoard.tiles[y2][x]

                newTile = testBoard.tiles[newTile.gridY][newTile.gridX]

                tempTile = testBoard.tiles[tile.gridY][tile.gridX]

                testBoard.tiles[tile.gridY][tile.gridX] = newTile
                testBoard.tiles[newTile.gridY][newTile.gridX] = tempTile

                local matches = testBoard:calculateMatches()

                if type(matches) == 'table' then
                    table.insert(matchTable, {x..","..y, x..","..y2})
                end
            end

            y2 = y

            for x2 = x - 1, x + 1, 2 do
                if x2 < 1 or x2 > 8  then
                    break
                end

                local testBoard = Class.clone(self)
                local tile = testBoard.tiles[y][x]
                local newTile = testBoard.tiles[y][x2]

                newTile = testBoard.tiles[newTile.gridY][newTile.gridX]

                tempTile = testBoard.tiles[tile.gridY][tile.gridX]

                testBoard.tiles[tile.gridY][tile.gridX] = newTile
                testBoard.tiles[newTile.gridY][newTile.gridX] = tempTile

                if type(matches) == 'table' then
                    table.insert(matchTable, {x..","..y, x2..","..y})
                end
            end
        end
    end

    return matchTable
end

function Board:check()
    local matches = self:findMatches()
    print_r(matches)
    
end

--after a swap and just revert back if there is no match!
function Board:matchesAvailable()    
    print("called")
    for y = 1, #self.tiles do
        for x = 1, #self.tiles[1] do
            -- print(self.tiles[y][x].color)

            -- if we have at least one tile on the left
            if x > 1 then
                -- swap tile left
                local newTile = self.tiles[y][x-1]
                self.tiles[y][x-1] = self.tiles[y][x]
                self.tiles[y][x] = newTile
                -- calculate matches
                local matches = self:calculateMatches()
                -- revert tiles to the original position
                newTile = self.tiles[y][x-1]
                self.tiles[y][x-1] = self.tiles[y][x]
                self.tiles[y][x] = newTile
                -- if there is at least one match
                if matches ~= false then
                    print("Match available: LEFT")      
                    return true
                end
            -- if we have at least one tile on the right
            elseif x < 8 then
                -- swap tile right
                local newTile = self.tiles[y][x+1]
                self.tiles[y][x+1] = self.tiles[y][x]
                self.tiles[y][x] = newTile
                -- calculate matches
                local matches = self:calculateMatches()
                -- revert tiles to the original position
                newTile = self.tiles[y][x+1]
                self.tiles[y][x+1] = self.tiles[y][x]
                self.tiles[y][x] = newTile
                -- if there is at least one match
                if matches ~= false then
                    print("Match available: RIGHT")
                    return true
                end
            end
        end

    end
    
    return false
end

function Board:update(dt)
    for y = 1, #self.tiles do
        for x = 1, #self.tiles[1] do
            self.tiles[y][x]:update(dt)
        end
    end
end
