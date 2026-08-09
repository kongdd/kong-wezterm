return {
	color_scheme = "Gruvbox dark, medium (base16)",

	window_background_gradient = {
		colors = { "#1D261B", "#261A25" },
		orientation = { Linear = { angle = -45 } },
	},

	-- colors = {
	-- 	scrollbar_thumb = "#34354D",
	-- },
	enable_scroll_bar = true,
	min_scroll_bar_height = "3cell",

	hide_tab_bar_if_only_one_tab = false,
	tab_max_width = 25,
	switch_to_last_active_tab_when_closing_tab = true,

	default_cursor_style = "BlinkingBar",
	cursor_blink_ease_in = "Constant",
	cursor_blink_ease_out = "Constant",
	cursor_blink_rate = 700,

	adjust_window_size_when_changing_font_size = false,
	window_decorations = "INTEGRATED_BUTTONS | RESIZE",
	initial_cols = 90,
	initial_rows = 24,
	window_padding = {
		left = 5,
		right = 10,
		top = 12,
		bottom = 7,
	},
	window_close_confirmation = "AlwaysPrompt",

	window_frame = {
		font_size = 11.0,
		active_titlebar_bg = "#0F2536",
		inactive_titlebar_bg = "#0F2536",
	},
}
