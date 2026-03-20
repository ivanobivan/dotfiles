return {
    {
        "folke/which-key.nvim",
        opts = {
            preset = "helix",
            delay = function()
                return 0
            end,
            sort = { "alphanum", "mod" },
            spec = {
                { "<leader>h", group = "custom search", mode = "n", icon = "" },
                { "<leader>d", group = "utils", mode = "n", icon = "" },
            },
        },
    },
}
