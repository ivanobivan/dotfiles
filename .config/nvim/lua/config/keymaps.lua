-- px to rem
vim.keymap.set("n", "<leader>df", ":PxToRemCursor<CR>", { noremap = true })
vim.keymap.set({ "n", "v" }, "<leader>dd", ":PxToRemLine<CR>", { noremap = true })

--toggle words
vim.keymap.set({ "n", "v" }, "<leader>dt", ":ToggleAlternate<CR>", { noremap = true, desc = "toggle word" })

-- quotes replace
vim.keymap.set("v", "<leader>`", [[:s/'\(.*\)'/`\1`/g<CR>]])
vim.keymap.set("v", '<leader>"', [[:s/"\(.*\)"/`\1`/g<CR>]])
