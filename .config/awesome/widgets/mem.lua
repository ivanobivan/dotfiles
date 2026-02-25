local wibox = require("wibox")
local gears = require("gears")
local settings = require("settings")
local utils = require("utils")

local icon_widget = utils.createIconWidget(settings.ICONS.mem)
local mem = wibox.widget({
	widget = wibox.widget.textbox,
})

local function update()
	local mem_total, mem_free, buffers, cached

	for line in io.lines("/proc/meminfo") do
		if line:match("^MemTotal:") then
			mem_total = tonumber(line:match("(%d+)"))
		elseif line:match("^MemFree:") then
			mem_free = tonumber(line:match("(%d+)"))
		elseif line:match("^Buffers:") then
			buffers = tonumber(line:match("(%d+)"))
		elseif line:match("^Cached:") then
			cached = tonumber(line:match("(%d+)"))
		end
	end

	if not mem_total or not mem_free or not buffers or not cached then
		return
	end

	local used = mem_total - mem_free - buffers - cached
	local percent = used / mem_total * 100

	utils.updateTextMarkup(mem, string.format("%.1f%%", percent))
end

gears.timer({
	timeout = 2,
	autostart = true,
	call_now = true,
	callback = update,
})

local widget = wibox.widget({
	icon_widget,
	mem,
	spacing = -4,
	layout = wibox.layout.fixed.horizontal,
})
return widget
