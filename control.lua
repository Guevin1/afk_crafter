local playerTable = require("playerTable")
local gui = require("ui.main")
commands.add_command("testRecipe",nil, function (p1)
    playerTable.addRecipe(1,"iron-gear-wheel",10)
    playerTable.addRecipe(1,"copper-cable",10,0,10)
    playerTable.addRecipe(1,"iron-stick",20,10)
    playerTable.addRecipe(1,"uranium-processing",5,10)
    local recipeID = playerTable.addRecipe(1,"inserter",20)
    playerTable.addNeeded(1,recipeID or 5,"electronic-circuit","!=",0)
    playerTable.sortRecipes(1)

end)
commands.add_command("break",nil, function (p1)
    print("Break")
end)
commands.add_command("resetafkc", nil, function (p1)
    playerTable.initTables()
    initModPlayers()
    game.print("reset AFK crafter!")
    gui.createFlowButton(p1.player_index)
end)
function initModPlayers()
    if not playerTable.isTableInit() then
        playerTable.initTables()
    end
    
    for _, player in pairs(game.players) do
        if playerTable.getPlayer(player.index) == nil then
            playerTable.addPlayer(player.index)
            playerTable.createGroup(player,"New Collection")
            gui.createFlowButton(player.index)
        end

    end
end
function crafting()
    
    for _, player in pairs(game.players) do
        local playerInfo = playerTable.getPlayer(player.index)
        if playerInfo["active"] > 0 and player.character ~= nil then
                
            local crafting_queue = player.crafting_queue
            local group = playerTable.getGroup(playerInfo["active"])
            if (#group["surfaces"] == 0 or table.contains(group["surfaces"],player.surface_index)) and (crafting_queue == nil or #crafting_queue == 0) then
                if (#group["recipes"] > 0) then
                    for _, recipe in pairs(group["recipes"]) do
                        local createRecipe = recipe["enabled"]
                        local nameRecipe = recipe["name"]
                        local force = player.force
                        local recipeForce = force.recipes[nameRecipe]
                        local product = nameRecipe
                        if recipeForce then
                            product = recipeForce.products[recipe["productID"]].name
                        end
                        local craftWithNeed = true
                        if #recipe["needed"] > 0 then
                            for _, need in pairs(recipe["needed"]) do
                                itemsCount = player.get_item_count(need["name"])
                                if not playerTable.equals2var(itemsCount,need["type"], need["count"]) then
                                    craftWithNeed = false
                                end
                            end
                        end
                        

                        local countsInInventory = player.get_item_count(product)
                        local rsRecipe = recipe["rs"]
                        local craftRecipe = countsInInventory < rsRecipe["max"]
                        if rsRecipe["min"] > 0 then
                            if rsRecipe["min"] >= countsInInventory then
                                rsRecipe["enabled"] = true
                            end
                            if rsRecipe["max"] <= countsInInventory then
                                rsRecipe["enabled"] = false
                            end
                            craftRecipe = rsRecipe["enabled"]
                        end
                        
                        if craftRecipe and createRecipe and craftWithNeed then
                            local craftSize = 1
                            local itemCountCraft = player.begin_crafting{count=craftSize,recipe=nameRecipe,silent=true}
                            if itemCountCraft ~= 0 then
                                break
                            end

                        end
                    end                   
                end
            end 
        end
    end
   
end


script.on_nth_tick(10,crafting)
script.on_event(defines.events.on_player_joined_game, initModPlayers)
script.on_init(initModPlayers)
script.on_configuration_changed(initModPlayers)
script.on_event(defines.events.on_player_created, initModPlayers)

table.contains = function(tbl, value)
    for _, v in ipairs(tbl) do
        if v == value then
            return true
        end
    end
    return false
end