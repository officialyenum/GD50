--[[
    GD50
    Pokemon

    Modified from A clone of BattleMenuState 

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

LevelUpMenuState = Class{__includes = BaseState}

function LevelUpMenuState:init(battleState)
    self.battleState = battleState

    -- Get old Hp, Attack, Defence and Speed
    local HP = self.battleState.player.party.pokemon[1].baseHP
    local baseAttack = self.battleState.player.party.pokemon[1].baseAttack
    local baseDefense = self.battleState.player.party.pokemon[1].baseDefense
    local baseSpeed = self.battleState.player.party.pokemon[1].baseSpeed

    print('Old HP',HP)
    print('Old ATTACK',baseAttack)
    print('Old DEFENCE',baseDefense)
    print('Old SPEED',baseSpeed)

    local newValues = {self.battleState.player.party.pokemon[1]:levelUp()}

    -- Get new Hp, Attack, Defence and Speed after level up
    local newHP = HP + newValues[1]
    local newBaseAttack = baseAttack + newValues[2]
    local newBaseDefense = baseDefense + newValues[3]
    local newBaseSpeed = baseSpeed + newValues[4]

    print('New HP',newHP)
    print('New ATTACK',newBaseAttack)
    print('New DEFENCE',newBaseDefense)
    print('New SPEED',newBaseSpeed)

    
    self.levelUpMenu = Menu {
        x = 0,
        y = VIRTUAL_HEIGHT - 128,
        width = VIRTUAL_WIDTH,
        height = 128,
        items = {
            {
                text = 'HP:' .. tostring(HP) .. ' + ' .. tostring(newValues[1]) .. ' = ' ..tostring(newHP),
                onSelect = function()
                    -- pop battle menu
                    gStateStack:pop()
                    Timer.after(0.5, function()
                        gStateStack:push(FadeInState({
                            r = 1, g = 1, b = 1
                        }, 1,
                        
                        -- pop message and battle state and add a fade to blend in the field
                        function()

                            -- resume field music
                            gSounds['field-music']:play()

                            -- pop message state
                            gStateStack:pop()

                            gStateStack:push(FadeOutState({
                                r = 1, g = 1, b = 1
                            }, 1, function()
                                -- do nothing after fade out ends
                            end))
                        end))
                    end)
                end
            },
            {
                text = 'Attack:' .. tostring(baseAttack) .. ' + ' .. tostring(newValues[2]) .. ' = ' ..tostring(newBaseAttack),
            },
            {
                text = 'Defense:' .. tostring(baseDefense) .. ' + ' .. tostring(newValues[3]) .. ' = ' ..tostring(newBaseDefense),
            },
            {
                text = 'Speed:' .. tostring(baseSpeed) .. ' + ' .. tostring(newValues[4]) .. ' = ' ..tostring(newBaseSpeed),
            },
        },
        hasCursor = false
    }
end

function LevelUpMenuState:update(dt)
    self.levelUpMenu:update(dt)
end

function LevelUpMenuState:render()
    self.levelUpMenu:render()
end