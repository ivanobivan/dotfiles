-- snacks animations
vim.g.snacks_animate = false

-- add breadcrumbs recording blank lines
vim.opt.list = true
vim.opt.listchars:append("space:⋅")

-- format on save with eslint + prettier
vim.g.lazyvim_format_on_save = "lsp"
