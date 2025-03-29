functionsGui = {}
local mod_gui = require("mod-gui")
require("click")
require("textfield")
require("elemchoose")
require("checkbox")
function functionsGui.createFlowButton(player_index)
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
--- comment
--- @param player LuaPlayer
function functionsGui.initScreen(player)
    local screen = player.gui.screen
    
    local MainFrame = screen.add{
        type="frame",
        name="afkCrafter",
        direction="vertical",
        style="afkCrafter.frame"
    }
    MainFrame.auto_center = true
    
    panelAdd(MainFrame)
    -- local TabFrame = MainFrame.add{type="flow", name="groups"}
    -- TabFrame.style.margin = 0
    local content = MainFrame.add{
        type="flow",
        name="content"
    }
    local groupID = 1
    group = playerTable.getGroup(groupID)
    local scrollPaneRecipes = content.add{
        type="scroll-pane",
        name="RecipeScroll",
        vertical_scroll_policy="auto-and-reserve-space"
    }
    local recipesBox = scrollPaneRecipes.add{
        type="frame",
        style="inside_shallow_frame_with_padding",
        direction="vertical",
        name="RecipeFrame",

    }
    print(group["recipes"])
    for key, value in pairs(group["recipes"]) do
        local Table = recipesBox.add{
            type="frame",
            name="recipe"..key,
            direction="vertical"
        }
        ItemBuildGUI(Table,value,groupID,key)
        local BlackList = Table.add{
            type="flow"
        }
        local needed = value["needed"]
        for need = 1, #needed+1, 1 do
            local value = needed[need] or {}

            local l = BlackList.add{
                type="flow",
                direction="horizontal"
            }
            local enabled = table_size(value) > 0
            l.style.vertical_align="center"
            l.add{
                type="choose-elem-button",
                elem_type="item",
                item=value["name"],
                tags={
                    parent="afkCrafter",
                    action="changeBlack",
                    needID=need,
                    groupID=groupID
                },
            }
            local setNeed = {
                "!=",
                "=",
                "<",
                ">"
            }
            local iK = 1
            for key,val in pairs(setNeed) do
                if value["type"] == val then
                    iK = key
                    break 
                end
            end

            local list = l.add{
                type="drop-down",
                items=setNeed,
                selected_index=iK,
                enabled=enabled,
                tags={
                    parent="afkCrafter",
                    action="dropBlack",
                    needID=need,
                    groupID=groupID
                },
            }
            
            list.style.width=56
            l.add{
                type="textfield",
                style="afkCrafter.numeric",
                text=value["count"] or 0,
                numeric=true,
                tags={
                    parent="afkCrafter",
                    action="countBlack",
                    recipeID=key,
                    needID=need,
                    groupID=groupID
                },
                enabled=enabled
            }
        end
    end
end


function getStackSize(nameRecipe,idProduct)
    local nameItem = prototypes.recipe[nameRecipe].products[idProduct].name
    return prototypes.item[nameItem].stack_size
end

---comment
---@param Table LuaGuiElement
function ItemBuildGUI(Table, value,groupID,key)
    local enabled = value["enabled"]
    local isEmpty = value["name"] ~= nil
    local IandE= enabled and isEmpty
    local ElementGui = Table.add{
        type="flow",
        direction="horizontal",
        name="recipe"
    }
    ElementGui.style.vertical_align="center"
    ElementGui.style.padding=4
    local ButtonsRecipe = ElementGui.add{
        type="flow",
        direction="vertical",
        name="buttons"
    }
    ButtonsRecipe.add{
        type="checkbox",
        state=value["enabled"],
        vertical_align="center",
        horizontal_align="center",
        tags={
            parent="afkCrafter",
            action="toggle_recipe",
            recipeID=key,
            groupID=groupID,
        }
    }
    ButtonsRecipe.add{
        type="sprite-button",
        auto_toggle=false,
        vertical_centering=true,
        style="mini_tool_button_red",
        sprite="utility/close",
        tags={
            parent="afkCrafter",
            action="deleteRecipe",
            recipeID=key,
            groupID=groupID,
        }
    }

    ElementGui.add{
        type="choose-elem-button",
        name="recipeElem",
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
        enabled=enabled,
        recipe=value["name"],
        tags={
            parent="afkCrafter",
            action="change_recipe",
            recipeID=key,
            groupID=groupID,
        }
    }
    local CountContainer = ElementGui.add{
        type="flow",
        name="count",
        enabled=IandE
    }
    CountContainer.style.vertical_align="center"
    local rsT = value["rs"]

    CountContainer.add{
        type="textfield",
        style="afkCrafter.numeric",
        name="min",
        numeric=true,
        allow_decimal=true,
        text=rsT["min"],
        tags={
            parent="afkCrafter",
            action="minRecipeCount",
            recipeID=key,
            groupID=groupID
        },
        enabled=IandE

    }
    CountContainer.add{
        type="slider",
        minimum_value=rsT["min"],
        maximum_value=getStackSize(value["name"],value["productID"])*10,
        value=rsT["max"],
        name="slider",
        tags={
            parent="afkCrafter",
            action="count",
            recipeID=key,
            groupID=groupID
        },
        enabled=IandE

    }
    CountContainer.add{
        type="textfield",
        style="afkCrafter.numeric",
        numeric=true,
        allow_decimal=true,
        text=rsT["max"],
        name="max",
        tags={
            parent="afkCrafter",
            action="maxRecipeCount",
            recipeID=key,
            groupID=groupID
        },
        enabled=IandE

    }




    
    local PrioretyBox = ElementGui.add{
        type="flow",
        direction="horizontal",
        name="PrioretyBox",
        enabled=IandE
    }
    PrioretyBox.style.left_margin=10
    PrioretyBox.style.vertical_align="center"
    PrioretyBox.add{
        type="textfield",
        style="afkCrafter.numeric",
        numeric=true,
        allow_decimal=true,
        name="textfield",
        text=value["priorety"],
        tags={
            parent="afkCrafter",
            action="setPriorety",
            recipeID=key,
            groupID=groupID
        },
        enabled=IandE
    }
    local PrioretyArrow = PrioretyBox.add{
        type="flow",
        direction="vertical",
        name="PrioretyArrow"

    }
    PrioretyArrow.add{
        type="sprite-button",
        auto_toggle=false,
        sprite="utility/speed_up",
        style="mini_button",
        tags={
            parent="afkCrafter",
            action="priorety",
            value=-1,
            recipeID=key,
            groupID=groupID
        },
        enabled=IandE
    }
    PrioretyArrow.add{
        type="sprite-button",
        auto_toggle=false,
        sprite="utility/speed_down",
        style="mini_button",
        tags={
            parent="afkCrafter",
            action="priorety",
            value=1,
            recipeID=key,
            groupID=groupID
        },
        enabled=IandE
    }
end

return functionsGui