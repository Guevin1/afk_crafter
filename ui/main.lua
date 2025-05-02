functionsGui = {}
local mod_gui = require("mod-gui")
require("events/click")
require("events/textfield")
require("events/elemchoose")
require("events/checkbox")
require("events/closegui")
require("events/slider")
require("events/dropdown")
require("ItemChoose")
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
function panelAdd(MainFrame, name,parent)
    local panel = MainFrame.add{
        type="flow",
        name="panel",
        style="afkCrafter.panel"
    }
    panel.add{
        type="label",
        name="title",
        style="frame_title",
        caption=name
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
            parent=parent,
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
    
    panelAdd(MainFrame,"AFK crafter", "afkCrafter")
    -- local TabFrame = MainFrame.add{type="flow", name="groups"}
    -- TabFrame.style.margin = 0
    local content = MainFrame.add{
        type="frame",
        name="content", 
        style="inside_shallow_frame"
    }
    local groupID = playerTable.getPlayer(player.index)["active"]
    group = playerTable.getGroup(groupID)
    local scrollPaneRecipes = content.add{
        type="scroll-pane",
        name="RecipeScroll",
        vertical_scroll_policy="always"
    }
    local recipesBox = scrollPaneRecipes.add{
        type="table",
        direction="vertical",
        name="RecipeFrame",
        column_count=1
    }
    recipesBox.style.vertically_stretchable=true
    functionsGui.reloadRecipes(recipesBox,groupID,group)
end
---comment
---@param neededList LuaGuiElement
---@param value any
---@param groupID any
---@param recipeID any
function functionsGui.reloadNeeded(neededList,valueRec,groupID,recipeID)
    neededList.clear()
    local needed = valueRec["needed"] or {}
    for need = 1, table_size(needed) + 1, 1 do
        local needID = "need"..need
        local value = needed[needID] or {}
        if table_size(value) == 0 then
            needID = nil
        end
        local l = neededList.add{
            type="flow",
            direction="horizontal"
        }
        local enabled = table_size(value) > 0
        l.style.vertical_align="center"
        l.add{
            type="choose-elem-button",
            elem_type="item",
            item=value["name"],
            enabled=table_size(valueRec) > 0,
            tags={
                parent="afkCrafter",
                action="changeBlack",
                needID=needID,
                groupID=groupID,
                recipeID=recipeID,
            },
        }
        local setNeed = {
            "!=",
            "=",
            "<",
            ">",
            ">=",
            "<=",
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
                needID=needID,
                groupID=groupID,
                recipeID=recipeID,

            },
        }
        
        list.style.width=56
        l.add{
            type="textfield",
            style="afkCrafter.numeric",
            text=value["count"] or "0",
            numeric=true,
            tags={
                parent="afkCrafter",
                action="countBlack",
                recipeID=recipeID,
                needID=needID,
                groupID=groupID,
                
            },
            enabled=enabled
        }
    end
end
---@param recipesBox LuaGuiElement
function functionsGui.reloadRecipes(recipesBox,groupID,group)
    if group ==nil then
        group = playerTable.getGroup(groupID)
    end
    recipesBox.clear()
    local keys = {}
    local oldN = 0
    for key,_ in pairs(group["recipes"]) do
        local name = tostring(key):gsub("recipe","")
        local id = tonumber(name)
        if oldN < id then
            oldN = id
        end
        table.insert(keys,id)
    end
    table.insert(keys, oldN+1)
    for _,key in pairs(keys) do
        recipeID = "recipe"..key
        value = group["recipes"][recipeID]
        local Table = recipesBox.add{
            type="frame",
            name=recipeID,
            direction="vertical",
            style="shallow_frame"
        }
        if value == nil then
            value = {}
        end
        functionsGui.ItemBuild(Table,value,groupID,recipeID)
    end
    local emptyWidget = recipesBox.add{
        type="empty-widget",
        style="entity_frame_filler"
    }
end
---comment
---@param Table LuaGuiElement
---@param value any
---@param groupID any
---@param recipeID any
function functionsGui.ItemBuild(Table,value,groupID,recipeID)
    Table.clear()
    functionsGui.ItemBuildGUI(Table,value,groupID,recipeID)
    local neededList = Table.add{   
        type="table",
        column_count=2,
        name="neededList"
    }
    functionsGui.reloadNeeded(neededList,value,groupID,recipeID)
end
function getStackSize(nameRecipe,idProduct)
    if nameRecipe ~= nil then
        
        local nameItem = prototypes.recipe[nameRecipe].products[idProduct].name
        return prototypes.item[nameItem].stack_size
    end
    return 0
end

---comment
---@param Table LuaGuiElement
function functionsGui.ItemBuildGUI(Table, value,groupID,recipeID)
    Table.clear()
    
    if type(recipeID) == "number" then
        recipeID = "recipe"..recipeID
    end
    if table_size(value) == 0 then
        recipeID = nil
    end

    local enabled = value["enabled"] 
    local isEmpty = value["name"] ~= nil
    if not isEmpty then
        enabled = true
    end
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
        state=enabled,
        vertical_align="center",
        horizontal_align="center",
        tags={
            parent="afkCrafter",
            action="toggle_recipe",
            recipeID=recipeID,
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
            recipeID=recipeID,
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
            recipeID=recipeID,
            groupID=groupID,
        }
    }
    local CountContainer = ElementGui.add{
        type="flow",
        name="count",
        enabled=IandE
    }
    CountContainer.style.vertical_align="center"
    local rsT = value["rs"] or {min=0,max=0}

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
            recipeID=recipeID,
            groupID=groupID
        },
        enabled=IandE

    }
    maxCount = getStackSize(value["name"],value["productID"])
    if maxCount == 0 then
        maxCount = 1
    end
    CountContainer.add{
        type="slider",
        minimum_value=rsT["min"],
        maximum_value=rsT["min"]+maxCount*1,
        value=rsT["max"],
        name="slider",
        value_step="1",
        tags={
            parent="afkCrafter",
            action="count",
            recipeID=recipeID,
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
            recipeID=recipeID,
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
            recipeID=recipeID,
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
            recipeID=recipeID,
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
            recipeID=recipeID,
            groupID=groupID
        },
        enabled=IandE
    }
end

return functionsGui