data:extend({
    {
        type = "int-setting",
        name = "afkCrafter_interval",
        setting_type = "startup",
        default_value = 15,
        minimum_value = 1
    },
    {
        type = "int-setting",
        name = "afkCrafter_countCraft",
        setting_type = "runtime-per-user",
        default_value = 1,
        minimum_value = 0
    }
})