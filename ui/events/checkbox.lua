
---@param event EventData.on_gui_checked_state_changed
function checkbox(event)
    local player = game.get_player(event.player_index)
    local tags = event.element.tags
    if player ~= nil and tags["parent"] == "afkCrafter" then
        local action = tags["action"]
        local groupID = tags["groupID"]
        local recipeID = tags["recipeID"]
        local recipe = playerTable.getRecipe(groupID,recipeID)
        local val = event.element.state
        local MainFrame = player.gui.screen.afkCrafter
        local RecipeFrame = nil
        if MainFrame ~= nil then
            RecipeFrame = MainFrame.content.RecipeScroll.RecipeFrame
        end
        local nameRecipe = nil
        local FrameRecipe = nil
        if recipeID ~= nil then
            FrameRecipe = RecipeFrame[recipeID].recipe
        end
        if action == "toggle_recipe" then
            if recipeID ~= nil then
                recipe["enabled"] = val
                local elements = FrameRecipe.children
                if recipeID ~= nil then
                    while #elements > 0 do
                        value = table.remove(elements,1) 
                        if value.name ~=  "buttons" then
                            value.enabled = val
                            if value.children ~= nil then
                                    
                                print(#value.children)
                                for k,v in pairs(value.children) do table.insert(elements,v) end
                            end
                        end
                        
                    end
                end
            else
                event.element.state = true
            end
            
            
        end 
    end
end
script.on_event(defines.events.on_gui_checked_state_changed, checkbox)
