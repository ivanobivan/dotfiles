local M = {}

--icons
M.ICONS = {
	watch = "",
	mem = " ",
	date = "󰃭",
	cpu = "",
	cpu_temp = {
		low = "",
		medium = "",
		high = "",
	},
	battery = {
		empty = "",
		quarter = "",
		half = "",
		threeq = "",
		full = "",
		charging = "",
	},
	lang = {
		os.getenv("HOME") .. "/.config/awesome/theme/svg/us.svg",
		os.getenv("HOME") .. "/.config/awesome/theme/svg/ru.svg",
	},
	net = {
		disconnected = "󰈂",
		wifi = "",
		lan = "󰈀",
	},
	vol = {
		mute = "",
		low = "",
		high = "",
	},
}

-- shared configs for theme and widgets
M.font = "Digital-7"
M.color = "#cfe5f4"
M.size = 18 * 1024
M.icon_color = "#c1f6da"
M.icon_size = 16 * 1024

M.bg_normal = "#1e1e2e"
M.bg_focus = "#313244"
M.bg_urgent = "#f38ba8"
M.bg_minimize = "#45475a"
M.bg_systray = M.bg_normal

M.fg_normal = "#cdd6f4"
M.fg_focus = "#f5e0dc"
M.fg_urgent = "#1e1e2e"
M.fg_minimize = "#a6adc8"

M.border_normal = "#d3d3d3"
M.border_focus = "#89b4fa"
M.border_marked = "#fab387"

M.taglist_bg_focus = "#313244"
M.taglist_fg_focus = "#cdd6f4"

M.taglist_bg_occupied = "#1e1e2e"
M.taglist_fg_occupied = "#cdd6f4"

M.taglist_bg_empty = "#1e1e2e"
M.taglist_fg_empty = "#6c7086"

M.black = "#000"
M.white = "#fff"

-- global settings

M.terminal = "kitty"
M.editor = os.getenv("EDITOR") or "nvim"
M.editor_cmd = M.terminal .. " -e " .. M.editor

return M
