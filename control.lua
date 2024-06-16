function getSettings(name)
    return settings.startup[name].value
end
local itemsName = {}

commands.add_command("items_add", nil, function (command)
        parametrs = {}
        for param in command.parameter:gmatch("%S+") do
            table.insert(parametrs, param)
        end

        table.insert(itemsName, {name=parametrs[1],count=parametrs[2]})
        game.print(parametrs[1].." success")
    end
)



local function craft()
    for _, player in pairs(game.players) do
        if player.crafting_queue_size > 0 then
            return
        end
        local inventory = player.get_inventory(defines.inventory.character_main)
        local multipecraft = player.mod_settings["multipe_craft"].value
        for _,item in pairs(itemsName) do
            local recipeName = item.name
            if player.character and inventory ~= nil and #recipeName > 0 and game.recipe_prototypes[recipeName] then
                local recipe = game.recipe_prototypes[recipeName]
                log(recipe.name)
                local count = tonumber(item.count)
                local countInQuery = 0;
                local is_crafting = false
                local crafting_queue = player.crafting_queue;
                local countInInventory = inventory.get_item_count(recipe.name)
                if crafting_queue ~= nil then
                    for _,value in pairs(crafting_queue) do
                        countInQuery = value["count"]
                        if value["recipe"] == recipe.name and value["count"] <= count then
                            is_crafting = true
                        end
                        
                    end 
                end
                if not is_crafting and countInInventory+countInQuery < count then
                    local countCraft = (multipecraft and count-(countInInventory+countInQuery)) or 1
                    game.print(getSettings("crafting_interval"))
                    player.begin_crafting{count=countCraft,recipe=recipe.name,silent=true}
                    break
                end    
            end
        end
    end
end



script.on_nth_tick(getSettings("crafting_interval"), craft)