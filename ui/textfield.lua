

---comment
---@param event EventData.on_gui_text_changed
local function TextfieldChange(event)
    local player = game.get_player(event.player_index)
    local tags = event.element.tags
    if player ~= nil and tags["parent"] == "afkCrafter" then
        local action = tags["action"]
        local groupID = tags["groupID"]
        local recipeID = tags["recipeID"]
        local recipe = playerTable.getRecipe(groupID,recipeID)
        local val = tags["value"]
        local MainFrame = player.gui.screen.afkCrafter
        local RecipeFrame = nil
        if MainFrame ~= nil then
            RecipeFrame = MainFrame.content.RecipeScroll.RecipeFrame
        end
        local FrameRecipe = nil
        if recipeID ~= nil then
            local nameRecipe = "recipe"..recipeID
            FrameRecipe = RecipeFrame[nameRecipe].recipe
        end
        if action == "maxRecipeCount" then
            recipe["rs"]["max"] = tonumber(event.text) or 0
            FrameRecipe.count.slider.slider_value=tonumber(event.text) or 0
        elseif action == "minRecipeCount" then
            recipe["rs"]["min"] = tonumber(event.text) or 0
        elseif action == "countBlack" then
            local needID = tags["needID"]
            recipe["needed"][needID]["count"] = tonumber(event.text) or 0
        end
    end
end
script.on_event(defines.events.on_gui_text_changed, TextfieldChange)
