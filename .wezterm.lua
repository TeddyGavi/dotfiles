-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.font = wezterm.font("JetBrains Mono")
config.window_background_opacity = 0.9
config.color_scheme = "catppuccin-mocha"
-- Tab Bar Options
config.use_fancy_tab_bar = true
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.show_tab_index_in_tab_bar = false

-- Padding
config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }

-- and finally, return the configuration to wezterm
return config
