---@param event EventData.on_gui_closed
function closegui(event)
    if event.element ~= nil then
        if event.element.name == "afkCrafter" then
            event.element.destroy()
        end
    end
    
end
script.on_event(defines.events.on_gui_closed,closegui)