local wibox = require("wibox")
local spawn = require("awful.spawn")
local gears = require("gears")
local settings = require("settings")
local utils = require("utils")

local LOW_THRESHOLD = 50
local HIGH_THRESHOLD = 75

local icon_widget = utils.createIconWidget(settings.ICONS.cpu_temp.low)

local cpu = wibox.widget({
	widget = wibox.widget.textbox,
})

local function update()
	spawn.easy_async_with_shell("sensors | grep '^Tctl:' | awk '{print $2}'", function(output)
		local temp = tonumber(output:match("([%d%.]+)")) or 0
		local icon
		if temp < LOW_THRESHOLD then
			icon = settings.ICONS.cpu_temp.low
		elseif temp < HIGH_THRESHOLD then
			icon = settings.ICONS.cpu_temp.medium
		else
			icon = settings.ICONS.cpu_temp.high
		end

		utils.updateIconMarkup(icon_widget, icon)
		utils.updateTextMarkup(cpu, string.format("%.1f%%", temp))
	end)
end

gears.timer({
	timeout = 10,
	autostart = true,
	call_now = true,
	callback = update,
})

local widget = wibox.widget({
	icon_widget,
	cpu,
	spacing = -4,
	layout = wibox.layout.fixed.horizontal,
})
return widget
