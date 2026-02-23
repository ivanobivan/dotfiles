local naughty = require("naughty")

local M = {}

function M.print_table(tbl, title)
	local lines = {}
	for k, v in pairs(tbl) do
		local val_str = v
		if type(v) == "table" then
			val_str = "<table>"
		elseif type(v) == "boolean" then
			val_str = tostring(v)
		end
		table.insert(lines, string.format("%s: %s", k, val_str))
	end

	naughty.notify({
		title = title or "Table Keys",
		text = table.concat(lines, "\n"),
		timeout = 10,
	})
end

function M.print(msg)
	naughty.notify({
		text = msg,
	})
end

return M
