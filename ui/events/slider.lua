--- @param event EventData.on_gui_value_changed
function sliderEvent(event)
    local player = game.get_player(event.player_index)
    local tags = event.element.tags
    if player ~= nil and tags["parent"] == "afkCrafter" then
        local action = tags["action"]
        local groupID = tags["groupID"]
        local recipeID = tags["recipeID"]
        local recipe = playerTable.getRecipe(groupID,recipeID)
        local val = event.element.slider_value
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
        if action=="count" then
            rs = recipe["rs"]
            if val < rs["min"] then
                event.element.slider_value = rs["min"]
            end
            rs["max"] = val
            FrameRecipe.recipe.count.max.text = tostring(val)
        end
    end
end
script.on_event(defines.events.on_gui_value_changed,sliderEvent)