local wibox = require("wibox")
local settings = require("settings")

local flags = settings.ICONS.lang
local img = wibox.widget({
	widget = wibox.widget.imagebox,
	resize = true,
	forced_width = 18,
	forced_height = 18,
})

local keyboard = wibox.widget({
	{
		img,
		halign = "center",
		valign = "center",
		widget = wibox.container.place,
	},
	widget = wibox.container.background,
})
local function update()
	local group = awesome.xkb_get_layout_group() + 1
	img.image = flags[group]
end

awesome.connect_signal("xkb::group_changed", update)
update()

return keyboard
