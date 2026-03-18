return {
    {
        "jsongerber/nvim-px-to-rem",
        config = function()
            require("nvim-px-to-rem").setup({
                root_font_size = 16,
                decimal_count = 4,
                show_virtual_text = false,
                add_cmp_source = false,
                filetypes = {
                    "css",
                    "scss",
                    "sass",
                    "less",
                },
            })
        end,
    },
}
