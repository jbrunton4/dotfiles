local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.default_prog = { "wsl -d arch" }
config.font = wezterm.font("Fira Code")
config.color_scheme = "Catppuccin Mocha"
config.enable_tab_bar = false
config.window_decorations = "RESIZE"
config.window_background_opacity = 0.9
config.keys = {
	{
		key = "F4",
		mods = "CTRL",
		action = wezterm.action.CloseCurrentPane({ confirm = false }),
	},
}

return config
