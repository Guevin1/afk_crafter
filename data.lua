local styles = data.raw["gui-style"].default
styles["afkc_interface"] = {
    
    type = "frame_style",
    height = 600
}
styles["afkc_content_frame"] = {
    type = "frame_style",
    parent = "inside_shallow_frame_with_padding"
}
styles["afkc_choose_elem"] = {
    type = "button_style",
    parent = "slot_button",
}
styles["afkc_text_box"] = {
    type = "textbox_style",
    width = 36
}
styles["afkc_titlebar_flow"] = {
    type = "horizontal_flow_style",
    horizontal_spacing = 8
}
styles["afkc_empty_widget"] = {
    type = "empty_widget_style",
    parent = "draggable_space",
    horizontally_stretchable = "on",
    height = 24,
    left_margin = 4,
    right_margin = 4
}
styles["afkc_buttons"] = {
    type="button_style",
    parent="tool_button_red"
}
styles["afkc_buttons_check"] = {
    type="checkbox_style"
}
styles["afkc_content_scrollbar"] = {
    type="vertical_scrollbar_style",
    height=400
}
