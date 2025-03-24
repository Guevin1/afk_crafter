local functions = {}
local playerTable = require("playerTable")
local mod_gui = require("mod-gui")
function functions.createFlowButton(player_index)
    local player = game.get_player(player_index)
    if player ~= nil then
        local button_flow = mod_gui.get_button_flow(player)
        if button_flow["afkCrafterButton"] ~= nil then
            button_flow["afkCrafterButton"].destroy()
        end
        button_flow.add{type="sprite-button",
            name="afkCrafterButton",
            sprite="item/assembling-machine-3",
            style=mod_gui.button_style,
            tags={
                parent="afkCrafter",
                action="toggle"
            }
        }
    end
    
end
---comment
---@param MainFrame LuaGuiElement
function panelAdd(MainFrame)
    local panel = MainFrame.add{
        type="flow",
        name="panel",
        style="afkCrafter.panel"
    }
    panel.add{
        type="label",
        name="title",
        style="frame_title",
        caption="AFK crafter"
    }
    local em = panel.add{
        type="empty-widget",
        style="afkCrafter.panel.widget",
    }
    em.drag_target = MainFrame
    panel.add{
        type="sprite-button",
        name="close",
        vertical_centering=true,
        auto_toggle=false,
        style="close_button",
        sprite="utility/close",
        tags={
            parent="afkCrafter",
            action="close"
        }
    }
    
end
---comment
---@param event EventData.on_gui_click
function functions.GuiClick(event)
    local player = game.get_player(event.player_index)
    local tags = event.element.tags
    if player ~= nil and tags["parent"] == "afkCrafter" then
        local action = tags["action"]

        local MainFrame = player.gui.screen.afkCrafter
        if action == "toggle" then
            if MainFrame == nil then
                functions.initScreen(player)
                player.opened=MainFrame
            else
                MainFrame.destroy()
                player.opened = nil
            end
        elseif action == "close" then
            MainFrame.destroy()
            player.opened = nil
        end
    end
end
--- comment
--- @param player LuaPlayer
function functions.initScreen(player)
    local screen = player.gui.screen
    
    local MainFrame = screen.add{
        type="frame",
        name="afkCrafter",
        direction="vertical",
        style="afkCrafter.frame"
    }
    MainFrame.auto_center = true
    
    panelAdd(MainFrame)
    local TabFrame = MainFrame.add{type="flow", name="groups"}
    TabFrame.style.margin = 0
    local content = TabFrame.add{
        type="flow"
    }
    local groupID = 1
    group = playerTable.getGroup(groupID)
    local scrollPaneRecipes = content.add{
        type="scroll-pane"
    }
    local recipesBox = scrollPaneRecipes.add{
        type="frame",
        style="inside_shallow_frame_with_padding",
        direction="vertical",
    }
    local filtersName = {}
    for name, value in pairs(player.force.recipes) do
        if value["enabled"] then
            table.insert(filtersName,name)
            print(name)
        end
    end
    print(group["recipes"])
    for key, value in pairs(group["recipes"]) do
        local ElementGui = recipesBox.add{
            type="flow",
            direction="horizontal"
        }
        ElementGui.style.vertical_align="center"
        ElementGui.style.padding=4
        local ButtonsRecipe = ElementGui.add{
            type="flow",
            direction="vertical",
        }
        ButtonsRecipe.add{
            type="checkbox",
            state=value["enabled"],
            vertical_align="center",
            horizontal_align="center",
            tags={
                parent="afkCrafter",
                action="toggle_recipe",
                recipeId=key,
                groupId=groupID
            }
        }
        ButtonsRecipe.add{
            type="sprite-button",
            auto_toggle=false,
            vertical_centering=true,
            style="mini_tool_button_red",
            sprite="utility/close"
        }

        ElementGui.add{
            type="choose-elem-button",
            elem_type="recipe",
            elem_filters={
                {
                    filter="has-ingredient-fluid",
                    invert=true,
                    mode="and"
                },
                {
                    mode="and",
                    filter="hidden-from-player-crafting",
                    invert=true
                },
                {
                    filter="hidden",
                    invert=true,
                    mode="and",
                }
            },
            recipe=value["name"],
            tags={
                parent="afkCrafter",
                action="change_recipe",
                value=1,
                recipeId=key,
                groupId=groupID
            }
        }
        local CountContainer = ElementGui.add{
            type="flow",
        }
        CountContainer.style.vertical_align="center"
        local rsT = value["rs"]

        CountContainer.add{
            type="textfield",
            style="afkCrafter.numeric",
            numeric=true,
            allow_decimal=true,
            text=rsT["min"],
            tags={
                parent="afkCrafter",
                action="minRecipeCount",
                recipeId=key,
                groupId=groupID
            }
        }
        CountContainer.add{
            type="slider",
            minimum_value=rsT["min"],
            maximum_value=getStackSize(value["name"],value["productID"])*10,
            value=rsT["max"],
            tags={
                parent="afkCrafter",
                action="count",
                recipeId=key,
                groupId=groupID
            }
        }
        CountContainer.add{
            type="textfield",
            style="afkCrafter.numeric",
            numeric=true,
            allow_decimal=true,
            text=rsT["max"],
            tags={
                parent="afkCrafter",
                action="maxRecipeCount",
                recipeId=key,
                groupId=groupID
            }
        }




        
        local PrioretyBox = ElementGui.add{
            type="flow",
            direction="horizontal"
        }
        PrioretyBox.style.left_margin=10
        PrioretyBox.style.vertical_align="center"
        PrioretyBox.add{
            type="textfield",
            style="afkCrafter.numeric",
            numeric=true,
            allow_decimal=true,
            text=value["priorety"],
            tags={
                parent="afkCrafter",
                action="setPriorety",
                recipeId=key,
                groupId=groupID
            }
        }
        local PrioretyArrow = PrioretyBox.add{
            type="flow",
            direction="vertical"
        }
        PrioretyArrow.add{
            type="sprite-button",
            auto_toggle=false,
            sprite="utility/speed_up",
            style="mini_button",
            tags={
                parent="afkCrafter",
                action="priorety",
                value=1,
                recipeId=key,
                groupId=groupID
            }
        }
        PrioretyArrow.add{
            type="sprite-button",
            auto_toggle=false,
            sprite="utility/speed_down",
            style="mini_button",
            tags={
                parent="afkCrafter",
                action="priorety",
                value=-1,
                recipeId=key,
                groupId=groupID
            }
        }
        
    end
end
function getStackSize(nameRecipe,idProduct)
    local nameItem = prototypes.recipe[nameRecipe].products[idProduct].name
    return prototypes.item[nameItem].stack_size
end
return functions