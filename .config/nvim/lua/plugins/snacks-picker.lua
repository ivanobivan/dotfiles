return {
    {
        "folke/snacks.nvim",
        opts = {
            picker = {
                preview = false,
                ignored = false,
                hidden = false,
                actions = {
                    explorer_copy_default = function(picker, item)
                        if not item then
                            return
                        end
                        local Tree = require("snacks.explorer.tree")
                        local actions = require("snacks.explorer.actions")
                        local uv = vim.uv or vim.loop
                        ---@type string[]
                        local paths = vim.tbl_map(Snacks.picker.util.path, picker:selected())
                        -- Copy selection
                        if #paths > 0 then
                            local dir = picker:dir()
                            Snacks.picker.util.copy(paths, dir)
                            picker.list:set_selected() -- clear selection
                            Tree:refresh(dir)
                            Tree:open(dir)
                            actions.update(picker, { target = dir })
                            return
                        end
                        Snacks.input({
                            prompt = "Copy to",
                            default = vim.fn.fnamemodify(item.file, ":t"),
                        }, function(value)
                            if not value or value:find("^%s$") then
                                return
                            end
                            local dir = vim.fs.dirname(item.file)
                            local to = vim.fs.normalize(dir .. "/" .. value)
                            if uv.fs_stat(to) then
                                Snacks.notify.warn("File already exists:\n- `" .. to .. "`")
                                return
                            end
                            Snacks.picker.util.copy_path(item.file, to)
                            Tree:refresh(vim.fs.dirname(to))
                            actions.update(picker, { target = to })
                        end)
                    end,
                },
                sources = {
                    explorer = {
                        hidden = true,
                        ignored = true,
                        win = {
                            list = {
                                keys = {
                                    ["C"] = "explorer_copy_default",
                                },
                            },
                        },
                    },
                },
            },
        },
    },
}
