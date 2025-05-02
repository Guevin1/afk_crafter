commands.add_command("itemChoose",nil, function (p1)
    functionsGui.ElemChooseItem(game.get_player(p1.player_index),"group1","recipe1")
end)
--- comment
--- @param player LuaPlayer
---@param groupID string
---@param recipeID string
function functionsGui.ElemChooseItem(player,groupID, recipeID)
    local screen = player.gui.screen
    MainFrame = screen.afkCrafterChooseElement
    if MainFrame == nil then
        MainFrame = screen.add{
            type="frame",
            name="afkCrafterChooseElement",
            direction="vertical",
        }
    end
    MainFrame.clear()

    panelAdd(MainFrame,"Set Recipe","afkCrafterChooseElement")
    
    local tabbed = MainFrame.add{
        type="tabbed-pane",
        style="filter_tabbed_pane"
    }
    tabbed.style.horizontally_stretchable=true
    local ItemsSubGroup = {}
    for key, item in pairs(player.force.recipes) do
        if item.enabled and not item.hidden and item.category ~= "parameters" then
            local SubGroup = ItemsSubGroup[item.subgroup.name]
            if SubGroup ~= nil then
                table.insert(SubGroup,item)
            else
                ItemsSubGroup[item.subgroup.name] = {
                    item
                }
            end
        end

    end
    -- tabbed.children[1].style.padding = 0
    for key, value in pairs(prototypes.item_group) do
        local tab = tabbed.add{
            type = "tab",
            name = key,
            tooltip = value.localised_name,
            style="filter_group_tab"
        }
        tab.add{
            type='sprite',
            sprite="item-group/"..key
        }

        local scrollItems = tabbed.add{
            type="scroll-pane",
            vertical_scroll_policy="auto-and-reserve-space",
            style="deep_slots_scroll_pane"
        }
    
        tabbed.add_tab(tab,scrollItems)  
        scrollItems.style.maximal_height=420
        local items = scrollItems.add{
            type = "table",
            column_count=10,
            style="filter_slot_table"
        }

        items.style.minimal_height=1480
        local countItemsInCategory = 0
        for key, subgroup in pairs(value.subgroups) do
            local sub =  ItemsSubGroup[subgroup.name]
            if sub ~= nil then
                for _, item in pairs(sub) do
                    items.add{
                        type="sprite-button",
                        sprite="recipe/"..item.name,
                        tags={
                            parent="afkCrafter",
                            action="recipeChange",
                            recipeID=recipeID,
                            groupID=groupID,
                            name=item.name
                        }
                    }
                    countItemsInCategory = countItemsInCategory + 1
                end
            end
        end  
        if countItemsInCategory == 0 then
            tabbed.remove_tab(tab)
        end
    end
    local widthTab = 424/table_size(tabbed.tabs)
    for _,tab in pairs(tabbed.tabs) do
        tab.tab.style.width = widthTab
    end
    local Setting = MainFrame.add{
        type="frame",
        style="inside_shallow_frame_with_padding",
        name="settings"
    }
    local CountBox = Setting.add{
        type="flow",
        name="CountBox"
    }
    CountBox.style.vertical_align="center"
    local stack_size = 100
    local recipe = playerTable.getRecipe(groupID,recipeID)
    local slider_minmax = discrete_slider.get_slider_min_max(stack_size)
    local slider_value = discrete_slider.count_to_slider_value(recipe["rs"]["max"], stack_size)
    CountBox.add{
        type="textfield",
        text=tostring(0),
        name="min",
        style="afkCrafter.numeric.large",
        numeric=true,
        tags={
            parent="afkCrafterChooseElement",
            action="newmaxRecipeCount",
            recipeID=recipeID,
            groupID=groupID
        },
    }
    local slider = CountBox.add{
        type="slider",
        minimum_value = slider_minmax.min,
        value_step = 1,
        maximum_value = slider_minmax.max,
        value = slider_value,
        tags = {
            parent="afkCrafterChooseElement",
            action="newcount",
            recipeID=recipeID,
            groupID=groupID
        }
    }
    slider.style.horizontally_stretchable = true
    CountBox.add{
        type="textfield",
        text=tostring(slider_value),
        name="max",
        style="afkCrafter.numeric.large",
        numeric=true,
        tags={
            parent="afkCrafterChooseElement",
            action="newmaxRecipeCount",
            recipeID=recipeID,
            groupID=groupID
        },
    }

end