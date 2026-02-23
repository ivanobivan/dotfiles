local wibox = require("wibox")
local settings = require("settings")

local M = {}

function M.createIconWidget(icon)
	return wibox.widget({
		markup = string.format(
			"<span font='%s' size='%d' foreground='%s'>%s </span>",
			settings.font,
			settings.icon_size,
			settings.icon_color,
			icon
		),
		widget = wibox.widget.textbox,
	})
end

function M.updateIconMarkup(widget, icon)
	widget.markup = string.format(
		"<span font='%s' size='%d' foreground='%s'>%s </span>",
		settings.font,
		settings.icon_size,
		settings.icon_color,
		icon
	)
end

function M.updateTextMarkup(widget, value)
	widget.markup = string.format(
		"<span font='%s' size='%d' foreground='%s'>%s</span>",
		settings.font,
		settings.size,
		settings.color,
		value
	)
end

return M
