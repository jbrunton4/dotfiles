local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.font = wezterm.font("Fira Code")
config.color_scheme = "Catppuccin Mocha"

return config
