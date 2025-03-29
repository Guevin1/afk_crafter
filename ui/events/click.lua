
---comment
---@param event EventData.on_gui_click
local function GuiClick(event)
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
        local nameRecipe = nil
        if recipeID ~= nil then
            FrameRecipe = RecipeFrame[recipeID]
        end
        if action == "toggle" then
            if MainFrame == nil then
                functionsGui.initScreen(player)
                player.opened = player.gui.screen.afkCrafter
            else
                MainFrame.destroy()
                player.opened = nil
            end
        elseif action == "close" then
            MainFrame.destroy()
            player.opened = nil
        elseif action == "priorety" then
            local priorety = playerTable.addRecipePriorety(groupID,recipeID,val)
            functionsGui.reloadRecipes(RecipeFrame,groupID)
        elseif action == "deleteRecipe" then
            playerTable.deleteRecipe(groupID,recipeID)
            FrameRecipe.destroy()
        end
    end
end
script.on_event(defines.events.on_gui_click, GuiClick)
