
---@param event EventData.on_gui_elem_changed
function Elemchange(event)
    local player = game.get_player(event.player_index)
    local tags = event.element.tags
    if player ~= nil and tags["parent"] == "afkCrafter" then
        local action = tags["action"]
        local groupID = tags["groupID"]
        local recipeID = tags["recipeID"]
        local recipe = playerTable.getRecipe(groupID,recipeID)
        local val = event.element.elem_value
        local MainFrame = player.gui.screen.afkCrafter
        local RecipeFrame = nil
        if MainFrame ~= nil then
            RecipeFrame = MainFrame.content.RecipeScroll.RecipeFrame
        end
        local nameRecipe = nil
        local FrameRecipe = nil
        if recipeID ~= nil then
            nameRecipe = "recipe"..recipeID
            FrameRecipe = RecipeFrame[nameRecipe].recipe
        end
        if action == "change_recipe" then
            if val == nil then
                playerTable.deleteRecipe(groupID, recipeID)
                FrameRecipe[nameRecipe].destroy()
            else
                recipe["name"] = event.element.elem_value
            end
        elseif action == "" then
        end
    end
end
script.on_event(defines.events.on_gui_elem_changed, Elemchange)
