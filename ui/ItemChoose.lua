commands.add_command("itemChoose",nil, function (p1)
    functionsGui.ElemChooseItem(game.get_player(p1.player_index),1,1)
end)
--- comment
--- @param player LuaPlayer
---@param groupID int
---@param recipeID int
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
        tab.style.horizontally_stretchable = true
        tab.style.horizontally_squashable = true
        tab.style.minimal_height = 71
        tab.add{
            type='sprite',
            sprite="item-group/"..key
        }
        tab.style.vertically_stretchable=true
        local scrollItems = tabbed.add{
            type="scroll-pane",
            vertical_scroll_policy="auto-and-reserve-space",
            style="deep_slots_scroll_pane"
        }
        scrollItems.style.maximal_height=540
        local items = scrollItems.add{
            type = "table",
            column_count=10,
            style="filter_slot_table"
        }

        items.style.minimal_height=1480
        tabbed.add_tab(tab,scrollItems)  
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
    

end