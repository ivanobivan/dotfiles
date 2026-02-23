local os = require("os")
local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local settings = require("settings")
local themes_path = string.format("%s/.config/awesome/theme", os.getenv("HOME"))
local theme = {}
local wallpaper_index = os.date("*t").month

theme.font = "Adwaita Mono 13.25"

theme.bg_normal = settings.bg_normal
theme.bg_focus = settings.bg_focus
theme.bg_urgent = settings.bg_urgent
theme.bg_minimize = settings.bg_minimize
theme.bg_systray = settings.bg_systray

theme.fg_normal = settings.fg_normal
theme.fg_focus = settings.fg_focus
theme.fg_urgent = settings.fg_urgent
theme.fg_minimize = settings.fg_minimize

theme.useless_gap = dpi(0)
theme.border_width = dpi(1)
theme.border_normal = settings.border_normal
theme.border_focus = settings.border_focus
theme.border_marked = settings.border_marked

theme.taglist_bg_focus = settings.taglist_bg_focus
theme.taglist_fg_focus = settings.taglist_fg_focus

theme.taglist_bg_occupied = settings.taglist_bg_occupied
theme.taglist_fg_occupied = settings.taglist_fg_occupied

theme.taglist_bg_empty = settings.taglist_bg_empty
theme.taglist_fg_empty = settings.taglist_fg_empty

theme.menu_submenu_icon = themes_path .. "icons/submenu.png"
theme.menu_height = dpi(20)
theme.menu_width = dpi(140)
theme.systray_icon_spacing = dpi(6)

theme.wallpaper = function(screen)
	return themes_path .. "/wallpapers/" .. tostring(wallpaper_index) .. ".jpg"
end

theme.layout_max = themes_path .. "/icons/max.png"
theme.layout_tileleft = themes_path .. "/icons/tileleft.png"
theme.layout_tile = themes_path .. "/icons/tile.png"

theme.awesome_icon = theme_assets.awesome_icon(theme.menu_height, theme.bg_focus, theme.fg_focus)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = "Adwaita"

theme.change_wallpaper = function(step)
	wallpaper_index = wallpaper_index + step
	if wallpaper_index > 12 then
		wallpaper_index = 1
	elseif wallpaper_index <= 0 then
		wallpaper_index = 12
	end
	theme.wallpaper = function()
		return themes_path .. "/wallpapers/" .. tostring(wallpaper_index) .. ".jpg"
	end
end
return theme
