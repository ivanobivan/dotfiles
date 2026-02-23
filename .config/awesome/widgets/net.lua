local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")
local naughty = require("naughty")
local spawn = require("awful.spawn")
local settings = require("settings")
local utils = require("utils")

local icon_widget = utils.createIconWidget(settings.ICONS.net.disconnected)

local net = wibox.widget({
	widget = wibox.widget.textbox,
})

local function show_wifi_list()
	spawn.easy_async("nmcli device wifi list --rescan yes", function(stdout)
		naughty.notify({
			title = "Available Wi-Fi Networks",
			text = stdout,
			timeout = 10,
			bg = "#1e1e2e",
			fg = "#ffffff",
		})
	end)
end

local function update_net()
	spawn.easy_async("nmcli -t -f DEVICE,TYPE,STATE,CONNECTION device status", function(stdout)
		local icon = settings.ICONS.net.disconnected
		local status_text = "Offline"

		for line in stdout:gmatch("[^\r\n]+") do
			local dev, typ, state, conn = line:match("([^:]+):([^:]+):([^:]+):?(.*)")
			if dev and state == "connected" then
				if typ == "wifi" then
					icon = settings.ICONS.net.wifi
					status_text = conn ~= "" and conn or "wi-fi"
				elseif typ == "ethernet" then
					icon = settings.ICONS.net.lan
					status_text = "LAN"
				end
				break
			end
		end

		utils.updateIconMarkup(icon_widget, icon)
		utils.updateTextMarkup(net, status_text)
	end)
end

gears.timer({
	timeout = 5,
	autostart = true,
	call_now = true,
	callback = update_net,
})

net:buttons(gears.table.join(awful.button({}, 1, function()
	show_wifi_list()
end)))

local widget = wibox.widget({
	icon_widget,
	net,
	spacing = 0,
	layout = wibox.layout.fixed.horizontal,
})

return widget
