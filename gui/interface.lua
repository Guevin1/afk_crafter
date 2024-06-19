local guiFunctions = {}
guiFunctions.guiIndex = 2
function guiFunctions.buildInterface(player)
    local screen_element = player.gui.screen
    local main_frame = screen_element.add{type="frame",name="afkc_interface",style="afkc_interface",direction="vertical"}
    local titleBar = main_frame.add{type="flow",name="afkc_flow",style="afkc_titlebar_flow"}
    titleBar.add{type="label",name="afkc_interface_name",style="frame_title",caption="AFK crafting"}
    titleBar.add{type="empty-widget",name="afkc_empty_widget",style="afkc_empty_widget"}.drag_target = main_frame
    titleBar.add{
        type="sprite-button",
        name="afkc_interface_close",
        vertical_align="center",
        auto_toggle=false,
        style="close_button",
        sprite="utility/close_white",
        tags={
            action="afkc_interface_close"
        }
    }
    
    -- local content = main_frame.add{type="frame",name="afkc_content_frame",direction="horizontal",vertically_squashable="stretch_and_expand",style="inside_shallow_frame_with_padding"}
    local switch_button = main_frame.add{type="switch",name="afkc_switch",left_label_caption="disable",right_label_caption="enable",switch_state="right"}
    local scroll_bar = main_frame.add{type="scroll-pane",name="afkc_content_scrollbar",style="notice_scroll_pane",vertical_scroll_policy="auto-and-reserve-space"}

    scroll_bar.style.height = 524
    local items = scroll_bar.add{type="frame",name="afkc_content",direction="vertical"}
    if global.players ~= nil and global.players[player.index] ~= nil and global.players[player.index]["queue"] ~= nil then
        for key, value in pairs(global.players[player.index]["queue"]) do
            local itemFrame = items.add{type="table",name="afkc_item_table"..key,column_count=4, direction="horizontal"}
            guiFunctions.item_add(itemFrame,value)
        end
    end
    local position = 0
    local childrens = items.children
    if #childrens > 0 then
        position = guiFunctions.index(childrens[#childrens].name)
    end
    local i = position + 1
    local itemFrame = items.add{type="table",name="afkc_item_table"..i,column_count=4, direction="horizontal"}
    guiFunctions.item_add(itemFrame,nil)
    main_frame.auto_center = true
end
function guiFunctions.item_add(itemFrame,item_name)
    local isEnabled = false
    local recipeName = nil
    local count = 0 
    local maxCount = 100
    local buttonE = true
    local itemIsEmpty = item_name ~= nil
    local switch = itemFrame.parent.parent.parent.afkc_switch
    if item_name ~= nil then
        recipeName = item_name.name
        maxCount = tonumber(game.item_prototypes[item_name.name].stack_size)
        
        count = tonumber(item_name.count)
        isEnabled = true
        if item_name.enabled ~= nil then
            isEnabled = item_name.enabled 
            buttonE = item_name.enabled
        end
        if maxCount <= 1 then
            maxCount = maxCount+1
            isEnabled = false
        end
    end
    if switch.switch_state == "left" then
        buttonE = false
    end
    local buttons = itemFrame.add{type="flow",name="afkc_buttons",direction="vertical"}
    buttons.add{type="checkbox",state=buttonE,name="afkc_disable",style="afkc_buttons_check",recipe=recipeName,vertical_align="center",horizontal_align="center",elem_type="recipe",enabled=itemIsEmpty}
    buttons.add{type="sprite-button", name="afkc_elem_reset",auto_toggle=false,style="mini_tool_button_red",sprite="utility/close_white", vertical_align="center",horizontal_align="center",enabled=itemIsEmpty}

    itemFrame.add{type="choose-elem-button",enabled=buttonE,name="afkc_choose_elem",recipe=recipeName,vertical_align="center",elem_type="recipe"}
    itemFrame.add{type="slider",name="afkc_slider",minimum_value=1,value_step=1, maximum_value=maxCount,vertical_align="center",value=count,enabled=isEnabled}
    itemFrame.add{type="textfield", name="afkc_text_box", text=count, numeric=true,vertical_align="center", enabled=isEnabled, allow_decimal=false, allow_negative=false, style="afkc_text_box"}


end
function guiFunctions.deleteEmpty(content_frame)
    for _, item_frame in pairs(content_frame.children) do
        local elem = item_frame.children[guiFunctions.guiIndex]
        if elem.elem_value == nil then
            item_frame.clear()
            item_frame.destroy()
        end
        
    end
    local childrens = content_frame.children
    local position = 0
    if #childrens > 0 then
        position = guiFunctions.index(childrens[#childrens].name)
    end
    local i = position + 1
    local itemFrame = content_frame.add{type="table",name="afkc_item_table"..i,column_count=4, direction="horizontal"}
    guiFunctions.item_add(itemFrame,nil)
end
function guiFunctions.index(name)
    local digits = name:match("%d+$")
    return tonumber(digits)
end
function guiFunctions.enableInterface(isOn,player_index,tableS) 
        local id = guiFunctions.index(tableS.name)
        local playerGlobalData = global.players[player_index]
        local isGlobalPlayer = playerGlobalData ~= nil and playerGlobalData.queue ~= nil and playerGlobalData.queue[id] ~= nil

        if isOn then
            for i = guiFunctions.guiIndex, #tableS.children, 1 do
                tableS.children[i].enabled = false
            end
        else
            local onChangeElem = tableS.children[guiFunctions.guiIndex]
            onChangeElem.enabled = true
            local length = guiFunctions.guiIndex
            if onChangeElem.elem_value ~= nil then
                if game.item_prototypes[onChangeElem.elem_value].stack_size > 1 then    
                    length = #tableS.children
                end
                

            end
            for i = guiFunctions.guiIndex, length, 1 do
                tableS.children[i].enabled = true
            end
            
        end
        if isGlobalPlayer then
            global.players[player_index].queue[id].enabled = not isOn
        end
end

return guiFunctions