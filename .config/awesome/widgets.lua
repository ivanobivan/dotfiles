local wibox = require("wibox")
local net = require("widgets.net")
local watch = require("widgets.watch")
local date = require("widgets.date")
local volume = require("widgets.vol")
local cpu_temp = require("widgets.cpu")
local cpu_usage = require("widgets.cpu-usage")
local mem = require("widgets.mem")
local keyboard = require("widgets.keyboard")
local battery = require("widgets.battery")

local M = {}

local function wrapWidget(widget, top, bottom, right)
	return {
		widget,
		right = right or 6,
		top = top or 0,
		bottom = bottom or 0,
		widget = wibox.container.margin,
		halign = "center",
		valign = "center",
	}
end

local systray = wibox.widget.systray()
systray.base_size = 20

M.watch = wrapWidget(watch)
M.calendar = wrapWidget(date)
M.net = wrapWidget(net, 0, 0, 2)
M.volume = wrapWidget(volume)
M.volume.update = volume.update
M.cpu_temp = wrapWidget(cpu_temp)
M.cpu_usage = wrapWidget(cpu_usage)
M.mem = wrapWidget(mem)
M.keyboard = wrapWidget(keyboard)
M.battery = wrapWidget(battery)
M.systray = wrapWidget(systray, 4, 4)

return M
