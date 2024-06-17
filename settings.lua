data:extend({
    {
        type = "bool-setting",
        name = "afkc_multipe_craft",
        setting_type = "runtime-per-user",
        default_value = false,
    },
    {
        type = "int-setting",
        name = "afkc_crafting_interval",
        setting_type = "startup",
        default_value = 60,
        minimum_value = 1
    }
})