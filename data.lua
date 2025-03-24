local styles = data.raw["gui-style"].default
styles["afkCrafter.frame"] = {
    type = "frame_style",
    height = 600,
}
styles["afkCrafter.panel"] = {
    type = "horizontal_flow_style",
    horizontal_spacing = 8
}
styles["afkCrafter.panel.widget"] = {
    type = "empty_widget_style",
    parent = "draggable_space",
    horizontally_stretchable = "on",
    height = 24,
    left_margin = 4,
    right_margin = 4
}
styles["afkCrafter.numeric"] = {
    type = "textbox_style",
    width = 36
}