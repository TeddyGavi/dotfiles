-- Pull in the wezterm API
local wezterm = require("wezterm")
local act = wezterm.action
local mux = wezterm.mux

local resurrect = wezterm.plugin.require("https://github.com/MLFlexer/resurrect.wezterm")
local workspace_switcher = wezterm.plugin.require("https://github.com/MLFlexer/smart_workspace_switcher.wezterm")
workspace_switcher.zoxide_path = "/opt/homebrew/bin/zoxide"

local function basename(s)
	return string.gsub(s, "(.*[/\\])(.*)", "%2")
end

-- redacted
-- resurrect.state_manager.set_encryption({
-- 	enable = true,
-- 	method = "/opt/homebrew/bin/age",
-- 	private_key = wezterm.home_dir .. "your path",
-- 	public_key = "your key",
--})

-- This table will hold the configuration.
local config = {}
config.enable_kitty_graphics = true
config.enable_kitty_keyboard = true
-- config.front_end = "OpenGL"
-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.font = wezterm.font("Monaspace Neon", { weight = "Regular" })
config.harfbuzz_features = { "calt=1", "clig=1", "liga=1" }
config.font_size = 15
-- config.window_background_opacity = 0.9
-- config.macos_window_background_blur = 20
-- config.color_scheme = "catppuccin-mocha"
-- config.color_scheme = 'Vacuous 2 (terminal.sexy)'
-- config.color_scheme = "rose-pine-dawn"
--
-- vague
config.colors = {
	foreground = "#cdcdcd",
	background = "#141415",
	cursor_bg = "#cdcdcd",
	cursor_border = "#cdcdcd",
	cursor_fg = "#141415",
	selection_bg = "#252530",
	selection_fg = "#cdcdcd",

	ansi = { "#252530", "#d8647e", "#7fa563", "#f3be7c", "#6e94b2", "#bb9dbd", "#aeaed1", "#cdcdcd" },
	brights = { "#606079", "#e08398", "#99b782", "#f5cb96", "#8ba9c1", "#c9b1ca", "#bebeda", "#d7d7d7" },
}

-- rose pine
-- config.colors = {
-- 	foreground = "#e0def4",
-- 	background = "#191724",
-- 	cursor_bg = "#e0def4",
-- 	cursor_border = "#e0def4",
-- 	cursor_fg = "#191724",
-- 	selection_bg = "#403d52",
-- 	selection_fg = "#e0def4",
--
-- 	ansi = { "#26233a", "#eb6f92", "#31748f", "#f6c177", "#9ccfd8", "#c4a7e7", "#ebbcba", "#e0def4" },
-- 	brights = { "#6e6a86", "#eb6f92", "#31748f", "#f6c177", "#9ccfd8", "#c4a7e7", "#ebbcba", "#e0def4" },
-- }

-- Tab Bar Options
config.use_fancy_tab_bar = true
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.show_tab_index_in_tab_bar = false

-- Padding
config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }

-- specific keybindings for multiplexing
config.unix_domains = {
	{
		name = "unix",
	},
}

-- resurrect.wezterm periodic save every 5 minutes
resurrect.state_manager.periodic_save({
	interval_seconds = 300,
	save_tabs = true,
	save_windows = true,
	save_workspaces = true,
})

-- Save only 5000 lines per pane
resurrect.state_manager.set_max_nlines(5000)

local resurrect_event_listeners = {
	"resurrect.error",
	"resurrect.state_manager.save_state.finished",
}
local is_periodic_save = false
wezterm.on("resurrect.periodic_save", function()
	is_periodic_save = true
end)
for _, event in ipairs(resurrect_event_listeners) do
	wezterm.on(event, function(...)
		if event == "resurrect.state_manager.save_state.finished" and is_periodic_save then
			is_periodic_save = false
			return
		end
		local args = { ... }
		local msg = event
		for _, v in ipairs(args) do
			msg = msg .. " " .. tostring(v)
		end
		wezterm.gui.gui_windows()[1]:toast_notification("Wezterm - resurrect", msg, nil, 4000)
	end)
end

workspace_switcher.apply_to_config(config)

wezterm.on("smart_workspace_switcher.workspace_switcher.created", function(window, path, label)
	local workspace_state = resurrect.workspace_state

	workspace_state.restore_workspace(resurrect.state_manager.load_state(label, "workspace"), {
		window = window,
		relative = true,
		restore_text = true,
		on_pane_restore = resurrect.tab_state.default_on_pane_restore,
	})
end)

-- Saves the state whenever I select a workspace
wezterm.on("smart_workspace_switcher.workspace_switcher.selected", function(window, path, label)
	local workspace_state = resurrect.workspace_state
	resurrect.state_manager.save_state(workspace_state.get_workspace_state())
end)

wezterm.on("smart_workspace_switcher.workspace_switcher.chosen", function(window, workspace)
	local gui_win = window:gui_window()
	local base_path = string.gsub(workspace, "(.*[/\\])(.*)", "%2")
	gui_win:set_right_status(wezterm.format({
		{ Foreground = { Color = "green" } },
		{ Text = base_path .. "  " },
	}))
end)

wezterm.on("smart_workspace_switcher.workspace_switcher.created", function(window, workspace)
	local gui_win = window:gui_window()
	local base_path = string.gsub(workspace, "(.*[/\\])(.*)", "%2")
	gui_win:set_right_status(wezterm.format({
		{ Foreground = { Color = "green" } },
		{ Text = base_path .. "  " },
	}))
end)

local modal = wezterm.plugin.require("https://github.com/MLFlexer/modal.wezterm")
modal.apply_to_config(config)

wezterm.on("modal.enter", function(name, window, pane)
	modal.set_right_status(window, name)
	modal.set_window_title(pane, name)
end)

wezterm.on("modal.exit", function(name, window, pane)
	local title = basename(window:active_workspace())
	window:set_right_status(wezterm.format({
		{ Attribute = { Intensity = "Bold" } },
		{ Text = title .. "  " },
	}))
	modal.reset_window_title(pane)
end)

config.default_workspace = "~"

config.leader = {
	key = "a",
	mods = "CTRL",
	timeout_milliseconds = 2000,
}

config.keys = {
	-- Attach to muxer
	{
		key = "a",
		mods = "LEADER",
		action = act.AttachDomain("unix"),
	},

	-- Detach from muxer
	{
		key = "d",
		mods = "LEADER",
		action = act.DetachDomain({ DomainName = "unix" }),
	},
	{
		key = "w",
		mods = "LEADER",
		action = act.ShowTabNavigator,
	},
	{
		key = ",",
		mods = "LEADER",
		action = act.PromptInputLine({
			description = "Enter new name for tab",
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},
	{
		key = "$",
		mods = "LEADER|SHIFT",
		action = act.PromptInputLine({
			description = "Enter new name for session/workspace",
			action = wezterm.action_callback(function(window, pane, line)
				local workspace_state = resurrect.workspace_state
				if line then
					mux.rename_workspace(window:mux_window():get_workspace(), line)
					resurrect.state_manager.save_state(workspace_state.get_workspace_state())
				end
			end),
		}),
	},
	-- Show list of workspaces
	{
		key = "s",
		mods = "LEADER",
		-- action = act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }),
		action = workspace_switcher.switch_workspace(),
	},
	-- show launcher
	{
		key = "l",
		mods = "LEADER",
		action = act.ShowLauncher,
	},

	-- Vertical split
	{
		key = "|",
		mods = "LEADER|SHIFT",
		action = act.SplitPane({
			direction = "Right",
			size = { Percent = 50 },
		}),
	},
	-- Horizontal split
	{
		key = "-",
		mods = "LEADER",
		action = act.SplitPane({
			direction = "Down",
			size = { Percent = 50 },
		}),
	},
	-- Close/kill active pane
	{
		key = "x",
		mods = "LEADER",
		action = act.CloseCurrentPane({ confirm = true }),
	},
	-- Swap active pane with another one
	{
		key = "{",
		mods = "LEADER|SHIFT",
		action = act.PaneSelect({ mode = "SwapWithActiveKeepFocus" }),
	},
	{
		key = "p",
		mods = "LEADER",
		action = act.PaneSelect,
	},
	{
		key = "P",
		mods = "LEADER|SHIFT",
		action = act.ActivatePaneDirection("Next"),
	},
	-- session-manager
	{
		key = "S",
		mods = "LEADER|SHIFT",
		action = wezterm.action_callback(function(win, pane)
			resurrect.state_manager.save_state(resurrect.workspace_state.get_workspace_state())
			resurrect.window_state.save_window_action()
		end),
	},
	{
		key = "W",
		mods = "LEADER|SHIFT",
		action = resurrect.window_state.save_window_action(),
	},
	{
		key = "T",
		mods = "LEADER|SHIFT",
		action = resurrect.tab_state.save_tab_action(),
	},
	{
		-- Load workspace or window state, using a fuzzy finder
		key = "L",
		mods = "LEADER|SHIFT",
		action = wezterm.action_callback(function(win, pane)
			local fuzzy_opts = {
				show_state_with_date = true,
			}

			resurrect.fuzzy_loader.fuzzy_load(win, pane, function(id, label)
				local type = string.match(id, "^([^/]+)") -- match before '/'
				id = string.match(id, "([^/]+)$") -- match after '/'
				id = string.match(id, "(.+)%..+$") -- remove file extention
				local opts = {
					relative = true,
					restore_text = true,
					on_pane_restore = resurrect.tab_state.default_on_pane_restore,
				}
				if type == "workspace" then
					local state = resurrect.state_manager.load_state(id, "workspace")
					resurrect.workspace_state.restore_workspace(state, opts)
				elseif type == "window" then
					local state = resurrect.state_manager.load_state(id, "window")
					resurrect.window_state.restore_window(pane:window(), state, opts)
				elseif type == "tab" then
					local state = resurrect.state_manager.load_state(id, "tab")
					resurrect.tab_state.restore_tab(pane:tab(), state, opts)
				end
			end, fuzzy_opts)
		end),
	},
	{
		-- Delete a saved session using a fuzzy finder
		key = "D",
		mods = "LEADER|SHIFT",
		action = wezterm.action_callback(function(win, pane)
			resurrect.fuzzy_loader.fuzzy_load(win, pane, function(id)
				resurrect.state_manager.delete_state(id)
			end, {
				title = "Delete State",
				description = "Select session to delete and press Enter = accept, Esc = cancel, / = filter",
				fuzzy_description = "Search session to delete: ",
				is_fuzzy = true,
			})
		end),
	},

	-- { key = "D", mods = "LEADER|SHIFT", action = act.ShowDebugOverlay },
}

wezterm.on("gui-startup", resurrect.state_manager.resurrect_on_gui_startup)
wezterm.on("gui-startup", wezterm.plugin.update_all)

-- and finally, return the configuration to wezterm
return config
