local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local themes_path = string.format("%s/.config/awesome/theme", os.getenv("HOME"))
local theme = {}

theme.font = "Iosevka Term 9"

theme.bg_normal = "#1e1e2e"
theme.bg_focus = "#313244"
theme.bg_urgent = "#f38ba8"
theme.bg_minimize = "#45475a"
theme.bg_systray = theme.bg_normal

theme.fg_normal = "#cdd6f4"
theme.fg_focus = "#f5e0dc"
theme.fg_urgent = "#1e1e2e"
theme.fg_minimize = "#a6adc8"

theme.useless_gap = dpi(0)
theme.border_width = dpi(0)
theme.border_normal = "#181825"
theme.border_focus = "#89b4fa"
theme.border_marked = "#fab387"

theme.taglist_bg_focus = "#313244"
theme.taglist_fg_focus = "#cdd6f4"

theme.taglist_bg_occupied = "#1e1e2e"
theme.taglist_fg_occupied = "#cdd6f4"

theme.taglist_bg_empty = "#1e1e2e"
theme.taglist_fg_empty = "#6c7086"

theme.menu_submenu_icon = themes_path .. "icons/submenu.png"
theme.menu_height = dpi(16)
theme.menu_width = dpi(140)

theme.wallpaper = themes_path .. "/bg.jpg"

theme.layout_max = themes_path .. "/icons/max.png"
theme.layout_tilebottom = themes_path .. "/icons/tilebottom.png"
theme.layout_tileleft = themes_path .. "/icons/tileleft.png"
theme.layout_tile = themes_path .. "/icons/tile.png"
theme.layout_tiletop = themes_path .. "/icons/tiletop.png"

theme.widget_vol = themes_path .. "/icons/vol.png"

theme.awesome_icon = theme_assets.awesome_icon(theme.menu_height, theme.bg_focus, theme.fg_focus)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = "Adwaita"

return theme
