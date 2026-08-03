local wezterm = require("wezterm")
local config = wezterm.config_builder()
local act = wezterm.action

local appearance_path = wezterm.config_dir .. "/wezterm/appearance.lua"
wezterm.add_to_config_reload_watch_list(appearance_path)
local appearance = dofile(appearance_path)

for key, value in pairs(appearance) do
	config[key] = value
end

config.hyperlink_rules = wezterm.default_hyperlink_rules()
table.insert(config.hyperlink_rules, {
	regex = [["([A-Za-z]:[\\/][^"]+)"]],
	format = "file:///$1",
	highlight = 1,
})
table.insert(config.hyperlink_rules, {
	regex = [[\b([A-Za-z]:[\\/][^\s"'<>|]+)]],
	format = "file:///$1",
})

local tab_min_width = 16

wezterm.on("format-tab-title", function(tab)
	local title = tab.tab_title
	if not title or title == "" then
		title = tab.active_pane.title
	end

	title = (" %d: %s "):format(tab.tab_index + 1, title)
	return wezterm.pad_right(title, tab_min_width)
end)

config.default_prog = { "pwsh.exe", "-NoLogo" }

wezterm.on("toggle-tab-bar", function(window)
	local overrides = window:get_config_overrides() or {}
	if overrides.enable_tab_bar == false then
		overrides.enable_tab_bar = nil
	else
		overrides.enable_tab_bar = false
	end
	window:set_config_overrides(overrides)
end)

config.keys = {
	{ key = "Enter", mods = "ALT", action = "DisableDefaultAssignment" },
	{ key = "n", mods = "CTRL", action = act.SpawnTab("CurrentPaneDomain") },
	{ key = "h", mods = "CTRL", action = act.EmitEvent("toggle-tab-bar") },
	{
		key = "F11",
		mods = "NONE",
		action = act.Multiple({ act.ToggleFullScreen, act.EmitEvent("toggle-tab-bar") }),
	},
	{
		key = "F2",
		mods = "NONE",
		action = act.PromptInputLine({
			description = "重命名标签页",
			action = wezterm.action_callback(function(window, _, line)
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},

	-- Ctrl+V: 粘贴文本；Alt+V: 发送图片到当前 pi pane
	{ key = "v", mods = "CTRL", action = act.PasteFrom("Clipboard") },
	{
		key = "v",
		mods = "ALT",
		action = wezterm.action_callback(function(_, pane)
			wezterm.background_child_process({ "clipimg.exe", tostring(pane:pane_id()) })
		end),
	},

	-- Ctrl+C: 有选区则复制，否则中断命令
	{
		key = "c",
		mods = "CTRL",
		action = wezterm.action_callback(function(win, pane)
			if win:get_selection_text_for_pane(pane) == "" then
				pane:send_text("\x03")
			else
				win:perform_action(act.CopyTo("Clipboard"), pane)
			end
		end),
	},

	-- Ctrl+Alt+方向键：创建分屏
	{ key = "LeftArrow", mods = "CTRL|ALT", action = act.SplitPane({ direction = "Left", size = { Percent = 50 } }) },
	{ key = "RightArrow", mods = "CTRL|ALT", action = act.SplitPane({ direction = "Right", size = { Percent = 50 } }) },
	{ key = "UpArrow", mods = "CTRL|ALT", action = act.SplitPane({ direction = "Up", size = { Percent = 50 } }) },
	{ key = "DownArrow", mods = "CTRL|ALT", action = act.SplitPane({ direction = "Down", size = { Percent = 50 } }) },
}

config.mouse_bindings = {
	-- Ctrl+左键：打开链接；兼容启用鼠标报告的终端程序
	{
		event = { Down = { streak = 1, button = "Left" } },
		mods = "CTRL",
		action = act.Nop,
	},
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "CTRL",
		action = act.OpenLinkAtMouseCursor,
	},
	{
		event = { Down = { streak = 1, button = "Left" } },
		mods = "CTRL",
		mouse_reporting = true,
		action = act.Nop,
	},
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "CTRL",
		mouse_reporting = true,
		action = act.OpenLinkAtMouseCursor,
	},
	-- 左键选中时 WezTerm 已自动复制；右键直接粘贴
	{
		event = { Down = { streak = 1, button = "Right" } },
		mods = "NONE",
		action = act.PasteFrom("Clipboard"),
	},
}

return config
