
---@param event EventData.on_gui_elem_changed
function Elemchange(event)
    local player = game.get_player(event.player_index)
    local tags = event.element.tags
    if player ~= nil and tags["parent"] == "afkCrafter" then
        local action = tags["action"]
        local groupID = tags["groupID"]
        local recipeID = tags["recipeID"]
        local recipe = playerTable.getRecipe(groupID,recipeID)

        local needID = tags["needID"]
        local val = event.element.elem_value
        local MainFrame = player.gui.screen.afkCrafter
        local RecipeFrame = nil
        if MainFrame ~= nil then
            RecipeFrame = MainFrame.content.RecipeScroll.RecipeFrame
        end
        
        local FrameRecipe = nil
        if recipeID ~= nil and RecipeFrame ~= nil then
            FrameRecipe = RecipeFrame[recipeID]
        end
        if action == "change_recipe" then
            if val == nil then
                playerTable.deleteRecipe(groupID, recipeID)
                FrameRecipe.destroy()
            else
                if not playerTable.recipeInGroup(groupID,val) then
                    if recipeID ~= nil then
                            
                        recipe["name"] = val
                        functionsGui.ItemBuildGUI(FrameRecipe.recipe,recipe,groupID,recipeID)
                    else
                        playerTable.addRecipe(groupID,val,1)
                        functionsGui.reloadRecipes(RecipeFrame,groupID)
                    end
                else 
                    if recipeID ~= nil then
                        event.element.elem_value = recipe["name"]
                    else
                        event.element.elem_value = nil
                    end
                end
            end
        elseif action == "changeBlack" then
            if val == nil then
                playerTable.removeNeeded(groupID,recipeID,needID)
                functionsGui.reloadNeeded(FrameRecipe.neededList,recipe,groupID,recipeID)

            else
                
                if not playerTable.needinRecipe(groupID,recipeID,val) then
                    if needID == nil then
                        playerTable.addNeeded(groupID,recipeID,val,"!=",0)
                        functionsGui.reloadNeeded(FrameRecipe.neededList,recipe,groupID,recipeID)
                    else
                        recipe["needed"][needID]["name"] = val
                    end
                else
                    if needID == nil then
                        event.element.elem_value = nil
                    else
                        event.element.elem_value = recipe["needed"][needID]["name"]
                    end
                end
            end
        end
    end
end
script.on_event(defines.events.on_gui_elem_changed, Elemchange)
