local wibox = require("wibox")
local spawn = require("awful.spawn")
local settings = require("settings")
local utils = require("utils")

local icon_widget = utils.createIconWidget(settings.ICONS.vol.low)

local vol = wibox.widget({
	widget = wibox.widget.textbox,
})

local function update()
	spawn.easy_async_with_shell("pulsemixer --get-volume --get-mute", function(output)
		local lines = {}
		for line in output:gmatch("[^\r\n]+") do
			table.insert(lines, line)
		end

		local vol_line = lines[1] or "0"
		local level = tonumber(vol_line:match("(%d+)")) or 0

		local muted = (lines[2] == "1")

		local icon
		if muted or level == 0 then
			icon = settings.ICONS.vol.mute
		elseif level < 50 then
			icon = settings.ICONS.vol.low
		else
			icon = settings.ICONS.vol.high
		end

		utils.updateIconMarkup(icon_widget, icon)
		utils.updateTextMarkup(vol, level)
	end)
end

update()

local widget = wibox.widget({
	icon_widget,
	vol,
	spacing = 2,
	layout = wibox.layout.fixed.horizontal,
})

widget.update = update
return widget
