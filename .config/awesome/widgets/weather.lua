local awful = require("awful")
local naughty = require("naughty")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local filesystem = require("gears.filesystem")
local settings = require("settings")

local CMD_FORMAT = [[bash -c "curl -fGsS --compressed -X GET 'https://wttr.in/%s'"]]
local OS_LANG = os.getenv("LANG")
local LANG = "en"
if OS_LANG ~= nil and OS_LANG ~= "" then
	LANG = os.getenv("LANG"):sub(1, 2)
end

if LANG == "C" or LANG == "C." then
	LANG = "en"
end

local tooltip = awful.tooltip({
	mode = "outside",
	shape = gears.shape.rounded_rect,
	visible = false,
	preferred_positions = { "bottom" },
	ontop = true,
	border_width = 2,
	border_color = settings.bg_normal,
	bg = settings.white,
	widget = wibox.widget.textbox,
})

local function show_warning(message)
	naughty.notify({
		preset = naughty.config.presets.critical,
		title = "Weather Warning !",
		text = message,
	})
end

local function update_widget(wdg, stdout, stderr, _, existcode)
	wdg:update(stdout, stderr, existcode)
end

local function get_api_url(location, format, lang, units)
	local sep = "?"
	local api_url = location
	if format ~= nil then
		api_url = api_url .. "?format=" .. format
		sep = "&"
	end

	api_url = api_url .. sep .. "lang=" .. lang .. "&" .. units

	return api_url
end

local function get_cmd(location, format, lang, units)
	local api_url = get_api_url(location, format, lang, units)

	return string.format(CMD_FORMAT, api_url)
end

local function weather(user_args)
	local args = user_args or {}
	local location = args.location or "Oymyakon"
	local format = args.format or "%c%t/%f+%m"
	local format_tooltip = args.format_tooltip or "%c%C+🌡️%t/%f+💦%p/%h+💨%w+〽%P+%m"
	local font = args.font or (beautiful.font:gsub("%s%d+$", "") .. " 9")
	local units = args.units or "m"
	local timeout = args.timeout or 120
	local lang = args.lang or "ru"

	local cmd = get_cmd(location, format, lang, units)
	local cmd_hover = get_cmd(location, format_tooltip, lang, units)
	local cache_path = filesystem.get_cache_dir() .. "weather/forecast.txt"
	local last_time_over = 0
	local warning_shown = false
	local is_initialized = false

	local wdg = wibox.widget({
		{
			{
				{
					id = "textbox",
					font = font,
					widget = wibox.widget.textbox,
				},
				layout = wibox.layout.fixed.horizontal,
			},
			left = 1,
			right = 1,
			layout = wibox.container.margin,
		},
		widget = wibox.container.background,

		init = function(self)
			if not is_initialized then
				awful.widget.watch(cmd, timeout, update_widget, self)
				tooltip.font = font
				tooltip:add_to_object(self)

				self:connect_signal("mouse::enter", self:show_tooltip())

				if not filesystem.file_readable(cache_path) then
					local ok, err = filesystem.make_parent_directories(cache_path)
					if not ok then
						show_warning(err)
					end
				end

				is_initialized = true
			end
		end,
		toggle_tooltip = function()
			Toggle_tooltip()
		end,
		show_tooltip = function(self)
			return function()
				if last_time_over == 0 or (os.time() - last_time_over > timeout) then
					tooltip.text = "Loading…"

					awful.spawn.easy_async(cmd_hover, function(stdout, stderr, _, exitcode)
						if exitcode ~= 0 then
							self:show_error(stdout .. "\n" .. stderr)
							return
						end
						last_time_over = os.time()
						tooltip.text = stdout
					end)
				else
				end
			end
		end,
		update = function(self, stdout, stderr, exitcode)
			if exitcode ~= 0 then
				self:show_error(stdout .. "\n" .. stderr)
				return
			end

			self:is_ok(true)
			self:set_text(stdout)
		end,

		shape = function(cr, width, height)
			gears.shape.rounded_rect(cr, width, height, 4)
		end,
		set_text = function(self, text)
			self:get_children_by_id("textbox")[1]:set_text(text)
		end,
		show_error = function(self, stderr)
			if not warning_shown then
				self:is_ok(false)
				local msg = cmd .. "\n" .. stderr
				show_warning(msg)
			end
		end,
		is_ok = function(self, is_ok)
			warning_shown = not is_ok

			if is_ok then
				self:get_children_by_id("textbox")[1]:set_opacity(1)
				self:get_children_by_id("textbox")[1]:emit_signal("widget:redraw_needed")
			else
				self:get_children_by_id("textbox")[1]:set_opacity(0.5)
				self:set_text("wttr error…")
				self:get_children_by_id("textbox")[1]:emit_signal("widget:redraw_needed")
			end
		end,
	})

	wdg:init()

	function Toggle_tooltip()
		local signal = "mouse::enter"
		if tooltip.visible then
			signal = "mouse::leave"
		end
		wdg:emit_signal(signal)
	end

	return wdg
end

local widget = wibox.widget({
	layout = wibox.layout.fixed.horizontal,
	weather({
		location = "Yaroslavl",
		font = settings.font .. " 16",
		format = "%l:%c%t/%f%w",
	}),
})

return widget
