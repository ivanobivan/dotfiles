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
                { "<leader>r", group = "ripgrep", mode = "n", icon = "" },
                { "<leader>d", group = "utils", mode = "n", icon = "" },
                { "<leader>m", group = "LLM", mode = { "n", "v" }, icon = "" },
            },
        },
    },
}
