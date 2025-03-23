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
    local group = functions.getTableGroup()[id]
    if group ~= nil then
        return group
    end
end

function functions.getRecipe(groupID, recipeID)
    local group = functions.getGroup(groupID)
    if group ~= nil then
        return group["recipes"][recipeID]
    end
end

function functions.getPlayer(idPlayer)
    local players = functions.getPlayerGroup()
    if players ~= nil then
        return players[idPlayer]
    end
end

function functions.addPlayer(idPlayer)
    local playerInfo = functions.getPlayer(idPlayer)
    if playerInfo == nil then
        local playerGroup = functions.getPlayerGroup()
        playerGroup[idPlayer] = {
            active = 0,
            groups = {}
        }
    end 
end

function functions.getGroupsByPlayer(idPlayer)
    local playerInfo = functions.getPlayer(idPlayer)
    if playerInfo ~= nil then
        return playerInfo["groups"]
    end
end

function functions.isGroupinPlayer(idPlayer,idGroup)
    local playerGroup = functions.getGroupsByPlayer(idPlayer)
    if playerGroup ~= nil then
        return table.contains(playerGroup, idGroup)
    end
end

function functions.addPlayerInGroup(idPlayer, idGroup)
    local playerGroup = functions.getGroupsByPlayer(idPlayer)
    if playerGroup ~= nil and not functions.isGroupinPlayer(idPlayer,idGroup) then
        table.insert(playerGroup,idGroup)
    end
end

function functions.setActiveGroup(idPlayer, idGroup)
    local playerInfo = functions.getPlayer(idPlayer)
    if playerInfo ~= nil and functions.isGroupinPlayer(idPlayer, idGroup) then
        playerInfo["active"] = idGroup
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
function functions.createGroup(player, name,icon)
    local groups = functions.getTableGroup()
    if groups ~= nil then
        local configGroup = {
            name = name,
            owner = player.index,
            recipes = {},
            surfaces = {},
            icon = icon or "iron-gear-wheel",
        }
        
        
        table.insert(groups,configGroup)
        local idGroup = #groups
        functions.addPlayerInGroup(player.index,idGroup)
        functions.setActiveGroup(player.index, idGroup)
    end
end
function functions.recipeInGroup(groupID,recipe)
    local group = functions.getGroup(groupID)
    if group ~= nil then
        local founded = false
        for _, value in pairs(group["recipes"]) do
            if value["name"] == recipe then
                founded = true
            end 
        end
        return founded
    end    
end
function functions.addRecipe(groupID,recipe,max,min,priorety)
    local group = functions.getGroup(groupID)
    if group ~= nil then
        if not functions.recipeInGroup(groupID,recipe) then
            local recipeBody = {
                name=recipe,
                rs = {
                    min = min or 0,
                    max = max,
                    enabled = false
                },
                priorety = priorety or 100,
                needed = {},
                enabled = true,
                productID = 1
            }
            table.insert(group["recipes"], recipeBody)
            functions.sortRecipes(groupID)
            return #group["recipes"]
        end
    end
end

function functions.addNeeded(groupID, recipeID, item,type,count)
    local recipe = functions.getRecipe(groupID,recipeID)
    if recipe ~= nil then
        for _, need in pairs(recipe["needed"]) do
            if need["name"] == item then
                return nil
            end
        end
        local blacklist = {
            name=item,
            type=type,
            count=count,
        }
        table.insert(recipe["needed"],blacklist)
    end
end

function functions.addRecipePriorety(groupID,recipeID,count)
    local recipe = functions.getRecipe(groupID, recipeID)
    if recipe ~= nil then
        recipe["priorety"] = recipe["priorety"] + count
    end
end
function functions.sortRecipes(groupID)
    local group = functions.getGroup(groupID)
    if group ~= nil then
        recipes = group["recipes"]
        table.sort(recipes,function (a, b)
            pr1 = a["priorety"]
            pr2 = b["priorety"]
            return pr1 < pr2
        end)
    end
end

function functions.equals2var(var1,sign, var2)
    if sign == "<" then
        return var1 < var2
    elseif sign == ">" then
        return var1 > var2
    elseif sign == "!=" then
        return var1 ~= var2
    else
        return var1 == var2
    end

end

return functions