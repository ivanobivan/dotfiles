local wibox = require("wibox")
local awful = require("awful")
local settings = require("settings")
local gears = require("gears")
local utils = require("utils")

local icon_widget = utils.createIconWidget(settings.ICONS.date)
local date = awful.widget.textclock(
	string.format(
		"<span font='%s' size='%d' foreground='%s'> %%d.%%m</span>",
		settings.font,
		settings.size,
		settings.color
	),
	60
)

local calendar = awful.widget.calendar_popup.month({
	start_sunday = false,
	spacing = 8,
	margin = 4,
	shape = gears.shape.rounded_rect,
	border_width = 2,
	border_color = settings.bg_normal,
	bg = settings.white,

	style_month = {
		fg_color = settings.fg_normal,
		markup = function(text)
			return "<b>" .. text .. "</b>"
		end,
	},
	style_header = { fg_color = settings.bg_normal },
	style_weekday = { fg_color = "#a6adc8" },
	style_normal = { fg_color = settings.black },
	style_focus = { fg_color = settings.white, bg_color = settings.border_focus, shape = gears.shape.rounded_rect },
})

local widget = wibox.widget({
	icon_widget,
	date,
	spacing = -10,
	layout = wibox.layout.fixed.horizontal,
})

calendar:attach(widget, "tr", {
	on_hover = false,
	on_click = true,
})

return widget
