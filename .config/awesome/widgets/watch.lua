local wibox = require("wibox")
local awful = require("awful")
local settings = require("settings")
local utils = require("utils")

local icon = utils.createIconWidget(settings.ICONS.watch)

local watch = awful.widget.textclock(
	string.format(
		"<span font='%s' size='%d' foreground='%s'>%%H:%%M</span>",
		settings.font,
		settings.size,
		settings.color
	),
	60
)

local widget = wibox.widget({
	icon,
	watch,
	spacing = 2,
	layout = wibox.layout.fixed.horizontal,
})

return widget
