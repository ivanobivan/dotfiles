local wibox = require("wibox")
local gears = require("gears")
local settings = require("settings")
local utils = require("utils")

local icon_widget = utils.createIconWidget(settings.ICONS.cpu)

local cpu = wibox.widget({
	widget = wibox.widget.textbox,
})
local prev_total = 0
local prev_idle = 0

local function update()
	local file = io.open("/proc/stat", "r")
	if not file then
		return
	end
	local line = file:read("*l")
	file:close()

	local line, user, nice, system, idle, iowait, irq, softirq, steal, guest, guest_nice =
		line:match("(%S+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s*(%d*)%s*(%d*)%s*(%d*)")

	user = tonumber(user)
	nice = tonumber(nice)
	system = tonumber(system)
	idle = tonumber(idle)
	iowait = tonumber(iowait)
	irq = tonumber(irq)
	softirq = tonumber(softirq)
	steal = tonumber(steal) or 0

	local total = user + nice + system + idle + iowait + irq + softirq + steal
	local diff_total = total - prev_total
	local diff_idle = idle - prev_idle

	local usage = 0
	if diff_total > 0 then
		usage = (diff_total - diff_idle) / diff_total * 100
	end

	prev_total = total
	prev_idle = idle

	utils.updateTextMarkup(cpu, string.format("%.1f%%", usage))
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
	spacing = 2,
	layout = wibox.layout.fixed.horizontal,
})
return widget
