return {
    {
        "folke/snacks.nvim",
        keys = {
            {
                "<leader>fr",
                function()
                    local relative = vim.fn.fnamemodify(vim.fn.expand("%:p"), ":.")

                    vim.fn.setreg("+", relative)
                    vim.notify("Copied relative path: " .. relative)
                end,
                desc = "Copy relative path from cwd",
            },
            {
                "<leader>fn",
                function()
                    local file = vim.fn.expand("%:t")
                    vim.fn.setreg("+", file)
                    vim.notify("Copied file name: " .. file)
                end,
                desc = "Copy file name",
            },
            {
                "<leader>fp",
                function()
                    local file = vim.fn.expand("%:p")
                    vim.fn.setreg("+", file)
                    vim.notify("Copied absolute path: " .. file)
                end,
                desc = "Copy absolute path",
            },
            {
                "<leader>rr",
                function()
                    Snacks.picker.grep()
                end,
                desc = "Find",
            },
            {
                "<leader>ra",
                function()
                    Snacks.picker.grep({ hidden = true, ignored = true })
                end,
                desc = "Find all",
            },
            {
                "<leader>rs",
                function()
                    Snacks.picker.grep({ regex = false })
                end,
                desc = "Find without regex",
            },
            {
                "<leader>rt",
                function()
                    Snacks.picker.grep({ glob = { "*.ts", "*.tsx" } })
                end,
                desc = "Find TS",
            },
            {
                "<leader>rh",
                function()
                    Snacks.picker.grep({ glob = { "*.html" } })
                end,
                desc = "Find HTML",
            },

            {
                "<leader>rl",
                function()
                    Snacks.picker.grep({ glob = { "*.less" } })
                end,
                desc = "Find LESS",
            },
        },
    },
}
