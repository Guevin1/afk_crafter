

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
            FrameRecipe = RecipeFrame[recipeID]
        end
        if action == "maxRecipeCount" then
            recipe["rs"]["max"] = tonumber(event.text) or 0
            FrameRecipe.recipe.count.slider.slider_value=tonumber(event.text) or 0
        elseif action == "minRecipeCount" then
            recipe["rs"]["min"] = tonumber(event.text) or 0
            maxCount = getStackSize(recipe["name"],recipe["productID"])
            print(maxCount)
            if maxCount == 0 then
                maxCount = 1
            end
            local minC = tonumber(event.text) or 0
            local SlVl = FrameRecipe.recipe.count.slider.slider_value
            FrameRecipe.recipe.count.slider.set_slider_minimum_maximum(minC,minC+maxCount*1)
            FrameRecipe.recipe.count.slider.slider_value = SlVl
        elseif action == "countBlack" then
            local needID = tags["needID"]
            recipe["needed"][needID]["count"] = tonumber(event.text) or 0
        end
    end
end
script.on_event(defines.events.on_gui_text_changed, TextfieldChange)
