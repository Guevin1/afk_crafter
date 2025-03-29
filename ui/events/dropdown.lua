--- @param event EventData.on_gui_value_changed
function dropdown(event)
    local player = game.get_player(event.player_index)
    local tags = event.element.tags
    if player ~= nil and tags["parent"] == "afkCrafter" then
        local action = tags["action"]
        local groupID = tags["groupID"]
        local recipeID = tags["recipeID"]
        local needID = tags["needID"]
        local recipe = playerTable.getRecipe(groupID,recipeID)
        local val = event.element.selected_index
        local MainFrame = player.gui.screen.afkCrafter
        local RecipeFrame = nil
        if MainFrame ~= nil then
            RecipeFrame = MainFrame.content.RecipeScroll.RecipeFrame
        end
        local nameRecipe = nil
        local FrameRecipe = nil
        if recipeID ~= nil then
            FrameRecipe = RecipeFrame[recipeID]
        end
        if action=="dropBlack" then
            if needID ~= nil then
                recipe["needed"][needID].type = event.element.get_item(val)
            end
        end
    end
end
script.on_event(defines.events.on_gui_selection_state_changed,dropdown)