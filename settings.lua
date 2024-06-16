data:extend({
    {
        type = "bool-setting",
        name = "multipe_craft",
        setting_type = "runtime-per-user",
        default_value = false,
    },
    {
        type = "int-setting",
        name = "crafting_interval",
        setting_type = "startup",
        default_value = 60,
        minimum_value = 1
    }
})