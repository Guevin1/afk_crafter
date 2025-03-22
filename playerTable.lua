local functions = {}
function functions.isTableInit()
    return functions.getTable() ~= nil
end

function functions.getTable()
    return storage["afkCrafter"]
end

function functions.getTableGroup()
    if functions.isTableInit() ~= nil then
        return functions.getTable()["group"]    
    end
end

function functions.getPlayerGroup()
    if functions.isTableInit() ~= nil then
        return functions.getTable()["players"]    
    end
end

function functions.getGroup(id)
    group = functions.getTableGroup()[id]
    if group ~= nil then
        return group
    end
end

function functions.getRecipe(groupID, recipeID)
    group = functions.getGroup(groupID)
    if group ~= nil then
        return group[recipeID]
    end
end

function functions.getPlayer(idPlayer)
    players = functions.getPlayerGroup()
    if players ~= nil then
        return players[idPlayer]
    end
end

function functions.isGroupinPlayer(idPlayer,idGroup)
    playerTable = functions.getPlayer(idPlayer)
    if playerTable ~= nil then
        return table.contains(playerTable,idGroup)
    else
        return false
    end
end
function functions.addPlayer(idPlayer)
    playerGroup = functions.getPlayerGroup()
    if playerGroup ~= nil and playerGroup[idPlayer] == nil then
        playerGroup[idPlayer] = {}
    end 
end
function functions.addPlayerInGroup(idPlayer, idGroup)
    print(idGroup,idPlayer)
    if functions.getPlayer(idPlayer) ~= nil and not functions.isGroupinPlayer(idPlayer,idGroup) then
        playerGroup = functions.getPlayer(idPlayer)
        table.insert(playerGroup,idGroup)
    end
end

function functions.initTables()
    storage["afkCrafter"] = {
        group = {},
        players = {}
    }
end
---@param player LuaPlayer
---@param name string
function functions.createGroup(player, name)
    groups = functions.getTableGroup()
    if groups ~= nil then
        configGroup = {
            name = name,
            owner = player.index,
            recipes = {},
            surfaces = {}
        }
        
        id = table.insert(groups,configGroup)
        print(id)
        functions.addPlayerInGroup(player.index,#groups)
    end
end
function functions.addRecipe(groupID,recipe,max,min,priorety)
    group = functions.getGroup(groupID)
    print(group)
    if group ~= nil then
        recipeBody = {
            name=recipe,
            rs = {
                min = min or 0,
                max = max
            },
            blacklist = {},
            priorety = priorety or 100
        }
        table.insert(group["recipes"], recipeBody)
    end
end
function functions.addRecipePriorety(groupID,recipeID,count)
    recipe = functions.getRecipe(groupID, recipeID)
    if recipe ~= nil then
        recipe["priorety"] = recipe["priorety"] + count
    end
end
return functions