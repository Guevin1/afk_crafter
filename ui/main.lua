local functions = {}
local mod_gui = require("mod-gui")
function functions.createFlowButton(player_index)
    local player = game.get_player(player_index)
    local button_flow = mod_gui.get_button_flow(player)
    if button_flow["afkCrafter"] == nil then
        button_flow.add{type="sprite-button",
            name="afkCrafter",
            sprite="item/assembling-machine-3",
            style=mod_gui.button_style
        }
    end
    
    print(button_flow)
end
return functions