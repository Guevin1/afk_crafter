
---comment
---@param event EventData.on_gui_click
local function GuiClick(event)
    local player = game.get_player(event.player_index)
    local tags = event.element.tags
    if player ~= nil and table_size(tags) > 0 and tags["parent"] ~= nil and string.match(tags["parent"], "^afkCrafter") then
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
            if RecipeFrame ~= nil then
                    
                FrameRecipe = RecipeFrame[recipeID]
            end
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
            player.gui.screen[tags["parent"]].destroy()
            player.opened = nil
        elseif action == "priorety" then
            if event.shift then
                val = val * 5
            end
            if event.control then
                val = val * 10
            end

            local priorety = playerTable.addRecipePriorety(groupID,recipeID,val)
            functionsGui.reloadRecipes(RecipeFrame,groupID)
            
        elseif action == "deleteRecipe" then
            playerTable.deleteRecipe(groupID,recipeID)
            if recipeID ~= nil then
                    
                FrameRecipe.destroy()
            end
        end
    end
end
script.on_event(defines.events.on_gui_click, GuiClick)
