-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")
require("awful.autofocus")

local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
local widgets = require("widgets")
local settings = require("settings")

-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

local SCRIPT_PATH = os.getenv("HOME") .. "/.config/awesome/scripts"

-- Error handling
if awesome.startup_errors then
	naughty.notify({
		preset = naughty.config.presets.critical,
		title = "Oops, there were errors during startup!",
		text = awesome.startup_errors,
	})
end

-- Handle runtime errors after startup
do
	local in_error = false
	awesome.connect_signal("debug::error", function(err)
		if in_error then
			return
		end
		in_error = true

		naughty.notify({
			preset = naughty.config.presets.critical,
			title = "Oops, an error happened!",
			text = tostring(err),
		})
		in_error = false
	end)
end

-- theme init
beautiful.init(string.format("%s/.config/awesome/theme/theme.lua", os.getenv("HOME")))
beautiful.taglist_shape = gears.shape.rounded_rect

-- terminal/editor
local terminal = settings.terminal
local editor = settings.editor
local editor_cmd = settings.editor_cmd

-- modkeys
local modkey = "Mod4"
local altkey = "Mod1"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
	awful.layout.suit.max,
	awful.layout.suit.tile.left,
	awful.layout.suit.tile,
	-- awful.layout.suit.tile.bottom,
	-- awful.layout.suit.tile.top,
	-- awful.layout.suit.floating,
	-- awful.layout.suit.fair,
	-- awful.layout.suit.fair.horizontal,
	-- awful.layout.suit.spiral,
	-- awful.layout.suit.spiral.dwindle,
	-- awful.layout.suit.max.fullscreen,
	-- awful.layout.suit.magnifier,
	-- awful.layout.suit.corner.nw,
	-- awful.layout.suit.corner.ne,
	-- awful.layout.suit.corner.sw,
	-- awful.layout.suit.corner.se,
}

--top left menu
local myawesomemenu = {
	{
		"hotkeys",
		function()
			hotkeys_popup.show_help(nil, awful.screen.focused())
		end,
	},
	{ "manual", terminal .. " -e man awesome" },
	{ "edit config", editor_cmd .. " " .. awesome.conffile },
	{ "restart", awesome.restart },
	{
		"quit",
		function()
			awesome.quit()
		end,
	},
}

local mymainmenu = awful.menu({
	items = {
		{ "awesome", myawesomemenu, beautiful.awesome_icon },
		{ "open terminal", terminal },
	},
})

local mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon, menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
	awful.button({}, 1, function(t)
		t:view_only()
	end),
	awful.button({ modkey }, 1, function(t)
		if client.focus then
			client.focus:move_to_tag(t)
		end
	end),
	awful.button({}, 3, awful.tag.viewtoggle),
	awful.button({ modkey }, 3, function(t)
		if client.focus then
			client.focus:toggle_tag(t)
		end
	end),
	awful.button({}, 4, function(t)
		awful.tag.viewnext(t.screen)
	end),
	awful.button({}, 5, function(t)
		awful.tag.viewprev(t.screen)
	end)
)

local tasklist_buttons = gears.table.join(
	awful.button({}, 1, function(c)
		if c == client.focus then
			c.minimized = true
		else
			c:emit_signal("request::activate", "tasklist", { raise = true })
		end
	end),
	awful.button({}, 3, function()
		awful.menu.client_list({ theme = { width = 250 } })
	end),
	awful.button({}, 4, function()
		awful.client.focus.byidx(1)
	end),
	awful.button({}, 5, function()
		awful.client.focus.byidx(-1)
	end)
)

local function set_wallpaper(s)
	if beautiful.wallpaper then
		local wallpaper = beautiful.wallpaper(s)
		if type(wallpaper) == "function" then
			wallpaper = wallpaper(s)
		end
		gears.wallpaper.maximized(wallpaper, s, true)
	end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
	set_wallpaper(s)
	local icons = { "󰆍 ", " ", " ", " ", " ", " ", " ", " ", " " }

	awful.tag(icons, s, awful.layout.suit.max)

	s.mypromptbox = awful.widget.prompt()
	s.mylayoutbox = awful.widget.layoutbox(s)
	s.mylayoutbox:buttons(gears.table.join(
		awful.button({}, 1, function()
			awful.layout.inc(1)
		end),
		awful.button({}, 3, function()
			awful.layout.inc(-1)
		end),
		awful.button({}, 4, function()
			awful.layout.inc(1)
		end),
		awful.button({}, 5, function()
			awful.layout.inc(-1)
		end)
	))

	s.mytaglist = awful.widget.taglist({
		screen = s,
		filter = awful.widget.taglist.filter.all,
		buttons = taglist_buttons,
		layout = {
			spacing = 0,
			layout = wibox.layout.fixed.horizontal,
		},
		style = {
			shape = gears.shape.rounded_bar,
		},
		widget_template = {
			{
				{
					id = "text_role",
					widget = wibox.widget.textbox,
				},
				left = 8,
				right = 8,
				widget = wibox.container.margin,
			},
			id = "background_role",
			widget = wibox.container.background,
			shape = gears.shape.rounded_rect,
		},
	})

	-- Create a tasklist widget
	s.mytasklist = awful.widget.tasklist({
		screen = s,
		filter = awful.widget.tasklist.filter.currenttags,
		buttons = tasklist_buttons,
		style = {
			shape = gears.shape.rounded_bar,
		},
		layout = {
			spacing = 10,
			layout = wibox.layout.flex.horizontal,
		},
		widget_template = {
			{
				{
					{
						{
							id = "icon_role",
							widget = wibox.widget.imagebox,
						},
						margins = 2,
						widget = wibox.container.margin,
					},
					{
						id = "text_role",
						widget = wibox.widget.textbox,
					},
					layout = wibox.layout.fixed.horizontal,
				},
				left = 10,
				right = 10,
				widget = wibox.container.margin,
			},
			id = "background_role",
			widget = wibox.container.background,
		},
	})

	-- WIDGETS (SETUP UP BAR)
	local bar = awful.wibar({ position = "top", screen = s, height = 24 })
	bar:setup({
		layout = wibox.layout.align.horizontal,
		{
			layout = wibox.layout.fixed.horizontal,
			{
				s.mytaglist,
				left = 4,
				widget = wibox.container.margin,
			},
			s.mypromptbox,
		},
		{
			s.mytasklist,
			widget = wibox.container.margin,
			right = 6,
			left = 6,
		},
		{
			layout = wibox.layout.fixed.horizontal,
			widgets.systray,
			widgets.mem,
			widgets.cpu_usage,
			widgets.cpu_temp,
			widgets.volume,
			widgets.net,
			widgets.battery,
			widgets.calendar,
			widgets.watch,
			widgets.keyboard,
			s.mylayoutbox,
		},
	})
	s.mywibox = bar
end)

-- Mouse bindings
root.buttons(gears.table.join(
	awful.button({}, 3, function()
		mymainmenu:toggle()
	end),
	awful.button({}, 4, awful.tag.viewnext),
	awful.button({}, 5, awful.tag.viewprev)
))

--  key bindings (hotkeys, keymaps)
--  awesome (default) keys
local globalkeys = gears.table.join(
	awful.key({ modkey }, "/", hotkeys_popup.show_help, { description = "show help", group = "awesome" }),
	awful.key({ modkey, "Shift" }, "r", awesome.restart, { description = "reload awesome", group = "awesome" }),
	awful.key({ modkey, "Shift" }, "q", awesome.quit, { description = "quit awesome", group = "awesome" }),
	awful.key({ modkey }, "r", function()
		mymainmenu:show()
	end, { description = "show main menu", group = "awesome" }),

	-- tabs (navigations)
	-- awful.key({ modkey, "Shift" }, "Tab", awful.tag.viewprev, { description = "view previous", group = "tag" }),
	awful.key({ modkey }, "`", awful.tag.viewnext, { description = "view next", group = "tag" }),
	awful.key({ modkey }, "Escape", awful.tag.history.restore, { description = "go back", group = "tag" }),

	awful.key({ altkey }, "Tab", function()
		awful.client.focus.byidx(1)
		if client.focus then
			client.focus:raise()
		end
	end, { description = "focus next window", group = "client" }),

	awful.key({ altkey, "Shift" }, "Tab", function()
		awful.client.focus.byidx(-1)
		if client.focus then
			client.focus:raise()
		end
	end, { description = "focus previous window", group = "client" }),

	-- Layout manipulation
	awful.key({ modkey, "Shift" }, "j", function()
		awful.client.swap.byidx(1)
	end, { description = "swap with next client by index", group = "client" }),

	awful.key({ modkey, "Shift" }, "k", function()
		awful.client.swap.byidx(-1)
	end, { description = "swap with previous client by index", group = "client" }),

	awful.key({ modkey }, "u", awful.client.urgent.jumpto, { description = "jump to urgent client", group = "client" }),

	-- Standard program
	awful.key({ modkey }, "Return", function()
		awful.spawn(terminal)
	end, { description = "open a terminal", group = "launcher" }),

	awful.key({ modkey }, "l", function()
		awful.tag.incmwfact(0.05)
	end, { description = "increase master width factor", group = "layout" }),
	awful.key({ modkey }, "h", function()
		awful.tag.incmwfact(-0.05)
	end, { description = "decrease master width factor", group = "layout" }),
	awful.key({ modkey, "Shift" }, "h", function()
		awful.tag.incnmaster(1, nil, true)
	end, { description = "increase the number of master clients", group = "layout" }),
	awful.key({ modkey, "Shift" }, "l", function()
		awful.tag.incnmaster(-1, nil, true)
	end, { description = "decrease the number of master clients", group = "layout" }),
	awful.key({ modkey, "Control" }, "h", function()
		awful.tag.incncol(1, nil, true)
	end, { description = "increase the number of columns", group = "layout" }),
	awful.key({ modkey, "Control" }, "l", function()
		awful.tag.incncol(-1, nil, true)
	end, { description = "decrease the number of columns", group = "layout" }),
	awful.key({ modkey }, "space", function()
		awful.layout.inc(1)
	end, { description = "select next", group = "layout" }),
	awful.key({ modkey, "Shift" }, "space", function()
		awful.layout.inc(-1)
	end, { description = "select previous", group = "layout" }),

	awful.key({ modkey, "Control" }, "n", function()
		local c = awful.client.restore()
		-- Focus restored client
		if c then
			c:emit_signal("request::activate", "key.unminimize", { raise = true })
		end
	end, { description = "restore minimized", group = "client" }),

	-- Prompt
	awful.key({ modkey }, "o", function()
		awful.screen.focused().mypromptbox:run()
	end, { description = "run prompt", group = "launcher" }),

	awful.key({ modkey }, "x", function()
		awful.prompt.run({
			prompt = "Run Lua code: ",
			textbox = awful.screen.focused().mypromptbox.widget,
			exe_callback = awful.util.eval,
			history_path = awful.util.get_cache_dir() .. "/history_eval",
		})
	end, { djscription = "lua execute prompt", group = "awesome" }),
	-- Menubar
	awful.key({ modkey }, "p", function()
		menubar.show()
	end, { description = "show the menubar", group = "launcher" })
)

-- custom (user) hotkeys
globalkeys = gears.table.join(
	globalkeys,
	-- wallpaper
	awful.key({ modkey, "Shift" }, "Right", function()
		beautiful.change_wallpaper(1)
		set_wallpaper()
	end, { description = "set next user wallpaper", group = "awesome" }),

	awful.key({ modkey, "Shift" }, "Left", function()
		beautiful.change_wallpaper(-1)
		set_wallpaper()
	end, { description = "set previous user wallpaper", group = "awesome" }),

	-- lock
	awful.key({ modkey }, "l", function()
		awful.spawn(SCRIPT_PATH .. "/lock.sh")
	end, { description = "Lock Screen", group = "awesome" }),

	-- printscrean (screenshot)
	awful.key({}, "Print", function()
		awful.spawn("flameshot gui")
	end, { description = "Make screenshot by flameshot", group = "awesome" }),

	awful.key({ altkey }, "Print", function()
		awful.spawn(string.format("flameshot screen -p %s/screenshots", os.getenv("HOME")))
	end, { description = "Make screenshot by flameshot", group = "awesome" }),

	-- pulsemixer (audio music)
	awful.key({}, "XF86AudioRaiseVolume", function()
		os.execute(string.format("pulsemixer --change-volume +5 --max-volume 100"))
		widgets.volume.update()
	end, { description = "sounds volume up", group = "awesome" }),

	awful.key({}, "XF86AudioLowerVolume", function()
		os.execute(string.format("pulsemixer --change-volume -5 --max-volume 100"))
		widgets.volume.update()
	end, { description = "sounds volume down", group = "awesome" }),

	awful.key({}, "XF86AudioMute", function()
		os.execute(string.format("pulsemixer --toggle-mute"))
		widgets.volume.update()
	end, { description = "sounds volume down", group = "awesome" }),

	-- brightnessctl

	awful.key({}, "XF86MonBrightnessUp ", function()
		os.execute(string.format("brightnessctl set +10%"))
		widgets.volume.update()
	end, { description = "bright volume up", group = "awesome" }),

	awful.key({}, "XF86MonBrightnessDown  ", function()
		os.execute(string.format("brightnessctl set -10%"))
		widgets.volume.update()
	end, { description = "bright volume up", group = "awesome" }),

	-- rofi
	awful.key({ modkey }, "d", function()
		awful.spawn("rofi -i -modi drun,run,ssh -show drun -theme default")
	end, { description = "show rofi drun", group = "launcher" }),

	awful.key({ modkey }, "Tab", function()
		awful.spawn("rofi -modi window,windowcd -show window -no-fixed-num-lines -selected-row 1 -theme nav")
	end, { description = "alt + tab", group = "launcher" }),

	awful.key({ altkey }, "F4", function()
		awful.spawn(SCRIPT_PATH .. "/powermenu.sh")
	end, { description = "powermenu", group = "launcher" })
)

local clientkeys = gears.table.join(
	awful.key({ modkey }, "f", function(c)
		c.fullscreen = not c.fullscreen
		c:raise()
	end, { description = "toggle fullscreen", group = "client" }),

	awful.key({ modkey }, "w", function(c)
		c:kill()
	end, { description = "close", group = "client" }),

	awful.key(
		{ modkey, "Control" },
		"space",
		awful.client.floating.toggle,
		{ description = "toggle floating", group = "client" }
	),

	awful.key({ modkey, "Control" }, "Return", function(c)
		c:swap(awful.client.getmaster())
	end, { description = "move to master", group = "client" }),

	awful.key({ modkey }, "o", function(c)
		c:move_to_screen()
	end, { description = "move to screen", group = "client" }),

	awful.key({ modkey }, "t", function(c)
		c.ontop = not c.ontop
	end, { description = "toggle keep on top", group = "client" }),

	awful.key({ modkey }, "n", function(c)
		c.minimized = true
	end, { description = "minimize", group = "client" }),

	awful.key({ modkey, "Control" }, "n", function()
		local c = awful.client.restore()
		if c then
			c:activate({ context = "key.unminimize" })
		end
	end, { description = "(un)minimize", group = "client" }),

	awful.key({ modkey }, "m", function(c)
		c.maximized = not c.maximized
		c:raise()
	end, { description = "(un)maximize", group = "client" }),

	awful.key({ modkey, "Control" }, "m", function(c)
		c.maximized_vertical = not c.maximized_vertical
		c:raise()
	end, { description = "(un)maximize vertically", group = "client" }),

	awful.key({ modkey, "Shift" }, "m", function(c)
		c.maximized_horizontal = not c.maximized_horizontal
		c:raise()
	end, { description = "(un)maximize horizontally", group = "client" })
)

-- Bind all key numbers to tags.
for i = 1, 9 do
	globalkeys = gears.table.join(
		globalkeys,
		-- View tag only.
		awful.key({ modkey }, "#" .. i + 9, function()
			local screen = awful.screen.focused()
			local tag = screen.tags[i]
			if tag then
				tag:view_only()
			end
		end, { description = "view tag #" .. i, group = "tag" }),
		-- Toggle tag display.
		awful.key({ modkey, "Control" }, "#" .. i + 9, function()
			local screen = awful.screen.focused()
			local tag = screen.tags[i]
			if tag then
				awful.tag.viewtoggle(tag)
			end
		end, { description = "toggle tag #" .. i, group = "tag" }),
		-- Move client to tag.
		awful.key({ modkey, "Shift" }, "#" .. i + 9, function()
			if client.focus then
				local tag = client.focus.screen.tags[i]
				if tag then
					client.focus:move_to_tag(tag)
				end
			end
		end, { description = "move focused client to tag #" .. i, group = "tag" }),
		-- Toggle tag on focused client.
		awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9, function()
			if client.focus then
				local tag = client.focus.screen.tags[i]
				if tag then
					client.focus:toggle_tag(tag)
				end
			end
		end, { description = "toggle focused client on tag #" .. i, group = "tag" })
	)
end

local clientbuttons = gears.table.join(
	awful.button({}, 1, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
	end),
	awful.button({ modkey }, 1, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
		awful.mouse.client.move(c)
	end),
	awful.button({ modkey }, 3, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
		awful.mouse.client.resize(c)
	end)
)

-- Set keys
root.keys(globalkeys)

-- Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
	-- All clients will match this rule.
	{
		rule = {},
		properties = {
			border_width = beautiful.border_width,
			border_color = beautiful.border_normal,
			focus = awful.client.focus.filter,
			raise = true,
			keys = clientkeys,
			buttons = clientbuttons,
			screen = awful.screen.preferred,
			placement = awful.placement.no_overlap + awful.placement.no_offscreen,
		},
	},

	-- Floating clients.
	{
		rule_any = {
			instance = {
				"DTA", -- Firefox addon DownThemAll.
				"copyq", -- Includes session name in class.
				"pinentry",
			},
			class = {
				"Arandr",
				"Blueman-manager",
				"Gpick",
				"Kruler",
				"MessageWin", -- kalarm.
				"Sxiv",
				"Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
				"Wpa_gui",
				"veromix",
				"xtightvncviewer",
			},

			-- Note that the name property shown in xprop might be set slightly after creation of the client
			-- and the name shown there might not match defined rules here.
			name = {
				"Event Tester", -- xev.
			},
			role = {
				"AlarmWindow", -- Thunderbird's calendar.
				"ConfigManager", -- Thunderbird's about:config.
				"pop-up", -- e.g. Google Chrome's (detached) Developer Tools.
			},
		},
		properties = { floating = false },
	},

	-- Add titlebars to normal clients and dialogs
	{ rule_any = { type = { "normal", "dialog" } }, properties = { titlebars_enabled = true } },
}

-- Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
	-- Set the windows at the slave,
	-- i.e. put it at the end of others instead of setting it master.
	-- if not awesome.startup then awful.client.setslave(c) end

	if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
		-- Prevent clients from being unreachable after screen count changes.
		awful.placement.no_offscreen(c)
	end
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
	c:emit_signal("request::activate", "mouse_enter", { raise = false })
end)

client.connect_signal("focus", function(c)
	c.border_color = beautiful.border_focus
end)
client.connect_signal("unfocus", function(c)
	c.border_color = beautiful.border_normal
end)

-- AUTOSTART
-- picom
awful.spawn.once(string.format("/usr/bin/picom --config %s/.config/picom/picom.conf", os.getenv("HOME")))

-- auto locker
awful.spawn.once("xset s 450")
awful.spawn.once("xset dpms 300 600 1200")
awful.spawn.once(string.format("xss-lock --transfer-sleep-lock -- %s/lock.sh", SCRIPT_PATH))
