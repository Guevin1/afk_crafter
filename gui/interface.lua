local guiFunctions = {}

function guiFunctions.buildInterface(player)
    local playerI = game.players[player.index]
    local screen_element = player.gui.screen
    local main_frame = screen_element.add{type="frame",name="afkc_interface",direction="vertical"}
    local titleBar = main_frame.add{type="flow",name="afkc_flow",style="afkc_titlebar_flow"}
    titleBar.add{type="label",name="afkc_interface_name",style="frame_title",caption="AFK crafting"}
    titleBar.add{type="empty-widget",name="afkc_empty_widget",style="afkc_empty_widget"}.drag_target = main_frame
    titleBar.add{type="sprite-button",name="afkc_interface_close",vertical_align="center", auto_toggle=false,style="close_button",sprite="utility/close_white"}
    
    local content = main_frame.add{type="frame",name="afkc_frame",direction="vertical",style="inside_shallow_frame_with_padding"}
    if global.players ~= nil and global.players[player.index] ~= nil and global.players[player.index]["queue"] ~= nil then
        for key, value in pairs(global.players[player.index]["queue"]) do
            local itemFrame = content.add{type="table",name="afkc_item_table"..key,column_count=4, direction="horizontal"}
            guiFunctions.item_add(itemFrame,value)
        end
    end
    local position = 0
    local childrens = content.children
    if #childrens > 0 then
        position = guiFunctions.index(childrens[#childrens].name)
    end
    local i = position + 1
    local itemFrame = content.add{type="table",name="afkc_item_table"..i,column_count=4, direction="horizontal"}
    guiFunctions.item_add(itemFrame,nil)
    main_frame.auto_center = true
end
function guiFunctions.item_add(itemFrame,item_name)
    local isEnabled = false
    local recipeName = nil
    local count = 0 
    local maxCount = 100
    if item_name ~= nil then
        recipeName = item_name.name
        maxCount = tonumber(game.item_prototypes[game.recipe_prototypes[item_name.name].main_product.name].stack_size)
        count = tonumber(item_name.count)
        isEnabled = true
    end
    
    itemFrame.add{type="choose-elem-button",name="afkc_choose_elem",recipe=recipeName,vertical_align="center",elem_type="recipe"}
    itemFrame.add{type="slider",name="afkc_slider",minimum_value=1,value_step=1, maximum_value=maxCount,vertical_align="center",value=count,enabled=isEnabled}
    itemFrame.add{type="textfield", name="afkc_text_box", text=count, numeric=true,vertical_align="center", enabled=isEnabled, allow_decimal=false, allow_negative=false, style="afkc_text_box"}
    itemFrame.add{type="sprite-button", name="afkc_elem_reset",auto_toggle=false,style="mini_button",sprite="utility/reset", vertical_align="center"}

end
function guiFunctions.deleteEmpty(content_frame)
    for _, item_frame in pairs(content_frame.children) do
        local elem = item_frame.children[1]
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
return guiFunctions