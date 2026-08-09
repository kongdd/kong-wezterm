local wezterm = require("wezterm")
local config_path = wezterm.config_dir .. "/wezterm/wezterm.lua"

wezterm.add_to_config_reload_watch_list(config_path)
return dofile(config_path)
