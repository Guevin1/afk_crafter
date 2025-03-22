local playerTable = require("playerTable")
commands.add_command("testRecipe",nil, function (p1)
    playerTable.addRecipe(1,"iron-gear-wheel",10)
end)
commands.add_command("break",nil, function (p1)
    print("Break")
end)
function initModPlayers()
    if not playerTable.isTableInit() then
        playerTable.initTables()
    end
    
    for _, player in pairs(game.players) do
        if playerTable.getPlayer(player.index) == nil then
            playerTable.addPlayer(player.index)
            playerTable.createGroup(player,"New Collection")
        end
    end
end
script.on_event(defines.events.on_player_joined_game, initModPlayers)
script.on_init(initModPlayers)
script.on_configuration_changed(initModPlayers)
script.on_event(defines.events.on_player_created, initModPlayers)

table.contains = function(tbl, value)
    for _, v in ipairs(tbl) do
        if v == value then
            return true
        end
    end
    return false
end