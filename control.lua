local mod_gui = require("mod-gui")
local interfacesMod = require("gui.interface")

function getSettings(name)
    return settings.startup["afkc_"..name].value
end
commands.add_command("break_point",nil,function (p1)
    log("break_point")
end)
commands.add_command("items_add", nil, function (command)
        parametrs = {}
        for param in command.parameter:gmatch("%S+") do
            table.insert(parametrs, param)
        end
        
        table.insert(itemsName, {name=parametrs[1],count=parametrs[2]})
        if global.players == nil then
            global.players = {}
        end
        if global.players[command.player_index] == nil then
            global.players[command.player_index] = {}
        end
        global.players[command.player_index].queue = itemsName
        game.print(parametrs[1].." success")
    end
)

local function craft()
    for _, player in pairs(game.players) do
        local itemsName = {}
        if global.players[player.index] ~= nil and global.players[player.index]["queue"] ~= nil then
            itemsName = global.players[player.index]["queue"]
        end
        local multipecraft = player.mod_settings["afkc_multipe_craft"].value
        for _,item in pairs(itemsName) do

            local recipeName = item.name
            if player.character and #recipeName > 0 and game.recipe_prototypes[recipeName] and game.item_prototypes[recipeName] then
                if player.crafting_queue_size > 0 then
                    return
                end        
                local recipe = game.recipe_prototypes[recipeName]
                local count = tonumber(item.count)
                local countInQuery = 0;
                local is_crafting = false
                local crafting_queue = player.crafting_queue;
                local countInInventory = player.get_item_count(recipe.name)
                if crafting_queue ~= nil then
                    for _,value in pairs(crafting_queue) do
                        countInQuery = value["count"]
                        if value["recipe"] == recipe.name and value["count"] <= count then
                            is_crafting = true
                        end
                        
                    end 
                end
                if not is_crafting and countInInventory+countInQuery < count then
                    local countCraft = (multipecraft and count-(countInInventory+countInQuery)) or 1
                    player.begin_crafting{count=countCraft,recipe=recipe.name,silent=true}
                    break
                end    
            end
        end
    end
end
function createButtonFlow(player)
    local button_flow = mod_gui.get_button_flow(player)
    if button_flow["afk_crafter_button"] == nil then
        button_flow.add{type="sprite-button", name="afk_crafter_button", sprite="item/assembling-machine-2",style=mod_gui.button_style}
    end    
end
function toggle_interface(player)
    local main_frame = player.gui.screen.afkc_interface
    if main_frame == nil then
        interfacesMod.buildInterface(player)
    else 
        main_frame.destroy()
    end
end

script.on_nth_tick(getSettings("crafting_interval"), craft)





script.on_event(defines.events.on_gui_click, function (event)
    local player = game.players[event.player_index]
    local buttonName = event.element.name
    if buttonName == "afk_crafter_button" then
        toggle_interface(player)
    end
    if buttonName:find("afkc_elem_reset") then
        local ParentChildren = event.element.parent.children
        ParentChildren[1].elem_value = nil
        ParentChildren[2].enabled = false
        ParentChildren[3].enabled = false
        interfacesMod.deleteEmpty(event.element.parent.parent)
        local playerGlobalData = global.players[event.player_index]
        local id = interfacesMod.index(ParentChildren.parent.name)
        if elem_value ~= nil and playerGlobalData ~= nil and playerGlobalData["queue"] ~= nil and playerGlobalData["queue"][id] ~= nil then
            global.players[event.player_index]["queue"][id] = nil
        end
        
    end
    if buttonName == "afkc_interface_close" then
        player.gui.screen.afkc_interface.destroy()
    end
end)
script.on_event(defines.events.on_gui_elem_changed, function (event)
    
    if event.element.name:find("afkc_choose_elem") then
        local player = game.players[event.player_index]
        local content_frame = player.gui.screen.afkc_interface.afkc_frame
        local GuiElement = event.element
        local parentGui = GuiElement.parent
        local slider = content_frame[parentGui.name].children[2]
        if GuiElement.elem_value ~= nil and game.item_prototypes[GuiElement.elem_value] ~= nil then
            
            slider.enabled = true
            slider.slider_value = 1 
            slider.set_slider_minimum_maximum(0,game.item_prototypes[GuiElement.elem_value].stack_size)
            content_frame[parentGui.name].children[3].enabled = true
            content_frame[parentGui.name].children[3].text = "1"
            interfacesMod.deleteEmpty(parentGui.parent)
            if global.players[event.player_index] == nil then
                global.players[event.player_index] = {}
                global.players[event.player_index].queue = {}
            end
            if global.players[event.player_index].queue == nil then
                global.players[event.player_index].queue = {}
            end

            local id = interfacesMod.index(parentGui.name)
            log(id)
            recipeCraft = global.players[event.player_index].queue[id]
            if recipeCraft == nil then
                recipeCraft = {}
            end
            recipeCraft["name"] = GuiElement.elem_value
            recipeCraft["count"] = 1;
            
            log(id)
            table.insert(global.players[player.index].queue,id,recipeCraft)
        else
            GuiElement.elem_value = nil
            content_frame[parentGui.name].children[2].enabled = false
            content_frame[parentGui.name].children[3].enabled = false
        end    
    end
    
end)
script.on_event(defines.events.on_gui_value_changed, function (event)
    if event.element.name:find("afkc_slider") then
        local GuiElement = event.element
        local slider_value = event.element.slider_value
        local ParentChildren = GuiElement.parent.children
        ParentChildren[3].text = tostring(slider_value)
        local elem_value = ParentChildren[1].elem_value
        local playerGlobalData = global.players[event.player_index]
        local id = interfacesMod.index(GuiElement.parent.name)
        if elem_value ~= nil and playerGlobalData ~= nil and playerGlobalData["queue"] ~= nil and playerGlobalData["queue"][id] ~= nil then
            global.players[event.player_index]["queue"][id]["count"] = slider_value
        end
    end
end)
script.on_event(defines.events.on_gui_text_changed, function (event)
    if event.element.name:find("afkc_text_box") then
        local GuiElement = event.element
        local value = event.element.text
        if value == nil or #value == 0 then
            value = 0
        end
        local ParentChildren = GuiElement.parent.children
        ParentChildren[2].slider_value = tonumber(value)
        local elem_value = ParentChildren[1].elem_value
        local playerGlobalData = global.players[event.player_index]
        local id = interfacesMod.index(GuiElement.parent.name)
        if elem_value ~= nil and playerGlobalData ~= nil and playerGlobalData["queue"] ~= nil and playerGlobalData["queue"][id] ~= nil then
            global.players[event.player_index]["queue"][id]["count"] = value
        end
    end
end)

function initmod()
    if global.players == nil then
        global.players = {}
    end
    for _, player in pairs(game.players) do
        if global.players[player.index] == nil then
            global.players[player.index] = {}
        end
        global.players[player.index].queue = {}
        createButtonFlow(player)
    end
end
-- ButtonFlow gui init
script.on_event(defines.events.on_player_joined_game,function (event)
    initmod()
end)
script.on_init(function (event)
    initmod()
end)

script.on_configuration_changed(function (p1) 
    initmod()
end)

script.on_event(defines.events.on_player_created, function (event)
    initmod()
end)
commands.add_command("afk_gui_reinit", nil, function (command)
    for _, player in pairs(game.players) do
        mod_gui.get_button_flow(player)["afk_crafter_button"] = nil
        createButtonFlow(player)
    end
end)
