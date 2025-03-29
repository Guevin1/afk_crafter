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
            local keys = {}
            for key,_ in pairs(group["recipes"]) do
                local name = tostring(key):gsub("recipe","")
                table.insert(keys,tonumber(name)+1)
            end
            table.sort(keys, function(a,b) return a > b end)
            local id = keys[1] or 1
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
            group["recipes"]["recipe"..id]= recipeBody
            functions.sortRecipes(groupID)
            
        end
    end
end
function functions.needinRecipe(groupID,recipeID,item)
    local recipe = functions.getRecipe(groupID,recipeID)
    if recipe ~= nil then
        for _, value in pairs(recipe["needed"]) do
            if value["name"] == item then
                return true
            end
        end
    end 
    return false

end
function functions.addNeeded(groupID, recipeID, item,type,count)
    local recipe = functions.getRecipe(groupID,recipeID)
    if recipe ~= nil then
        local keys = {}
        local isBlacklist = false
        for key, need in pairs(recipe["needed"]) do
            if need["name"] == item then
                isBlacklist = true
            end
            local name = tostring(key):gsub("need","")
            table.insert(keys,tonumber(name)+1)
        end
        if not isBlacklist then
            table.sort(keys, function(a,b) return a > b end)
            local id = keys[1] or 1

            local blacklist = {
                name=item,
                type=type,
                count=count,
            }
            recipe["needed"]["need"..id] = blacklist
        end
        
    end
end
function functions.removeNeeded(groupID,recipeID,needID)
    local recipe = functions.getRecipe(groupID,recipeID)
    if recipe ~= nil then
        recipe["needed"][needID] = nil
    end
    
end
function functions.deleteRecipe(groupID,recipeID)
    local group = functions.getGroup(groupID)
    if group ~= nil then
        group["recipes"][recipeID] = nil
    end
end

function functions.addRecipePriorety(groupID,recipeID,count)
    local recipe = functions.getRecipe(groupID, recipeID)
    local res = nil
    if recipe ~= nil then
        recipe["priorety"] = recipe["priorety"] + count
        res = recipe["priorety"]
        functions.sortRecipes(groupID)
    end
    return res
end
function functions.sortRecipes(groupID)
    local group = functions.getGroup(groupID)
    if group ~= nil then
        local recipes = group["recipes"]
        local sorted_recipes = {}
        for key, recipe in pairs(recipes) do
            table.insert(sorted_recipes, {key = key, recipe = recipe})
        end
        table.sort(sorted_recipes, function(a, b)
            local pr1 = a.recipe["priorety"] or 0
            local pr2 = b.recipe["priorety"] or 0
            return pr1 < pr2
        end)
        local tableNew = {}
        for _, entry in ipairs(sorted_recipes) do
            local key, recipe = entry.key, entry.recipe
            tableNew[key] = recipe
        end
        group["recipes"] = tableNew
    end
end

function functions.equals2var(var1,sign, var2)
    if sign == "<" then
        return var1 < var2
    elseif sign == ">" then
        return var1 > var2
    elseif sign == "!=" then
        return var1 ~= var2
    elseif sign == "<=" then
        return var1 <= var2
    elseif sign == ">=" then
        return var1 >= var2
    else
        return var1 == var2
    end

end

return functions