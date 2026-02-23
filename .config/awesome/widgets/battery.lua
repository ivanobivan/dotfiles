local wibox = require("wibox")
local gears = require("gears")
local settings = require("settings")
local utils = require("utils")

local icon_widget = utils.createIconWidget(settings.ICONS.battery.charging)
local battery = wibox.widget({
	widget = wibox.widget.textbox,
})

local widget = wibox.widget({
	icon_widget,
	battery,
	spacing = 2,
	layout = wibox.layout.fixed.horizontal,
})
local BAT_PATH = "/sys/class/power_supply"

local function file_read(path)
	local f = io.open(path, "r")
	if not f then
		return nil
	end
	local v = f:read("*l")
	f:close()
	return v
end

local function get_battery()
	for entry in io.popen("ls -1 " .. BAT_PATH):lines() do
		if entry:match("^BAT") then
			return BAT_PATH .. "/" .. entry
		end
	end
	return nil
end

local function pick_icon(level, charging)
	if charging then
		return settings.ICONS.battery.charging
	elseif level <= 10 then
		return settings.ICONS.battery.empty
	elseif level <= 30 then
		return settings.ICONS.battery.quarter
	elseif level <= 60 then
		return settings.ICONS.battery.half
	elseif level <= 85 then
		return settings.ICONS.battery.threeq
	else
		return settings.ICONS.battery.full
	end
end

local function update()
	local bat = get_battery()

	if not bat then
		widget.visible = false
		return
	end

	widget.visible = true

	local cap = tonumber(file_read(bat .. "/capacity")) or 0
	local status = file_read(bat .. "/status") or ""
	local charging = status == "Charging"

	local icon = pick_icon(cap, charging)

	utils.updateIconMarkup(icon_widget, icon)
	utils.updateTextMarkup(battery, string.format("%S%%", cap))
end

gears.timer({
	timeout = 30,
	autostart = true,
	call_now = true,
	callback = update,
})

return widget
