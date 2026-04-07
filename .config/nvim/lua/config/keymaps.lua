-- px to rem
vim.keymap.set("n", "<leader>df", ":PxToRemCursor<CR>", { noremap = true })
vim.keymap.set({ "n", "v" }, "<leader>dd", ":PxToRemLine<CR>", { noremap = true })

--toggle words
vim.keymap.set({ "n", "v" }, "<leader>dt", ":ToggleAlternate<CR>", { noremap = true, desc = "toggle word" })

--parrot
vim.keymap.set({ "n", "i" }, "<leader>mn", ":PrtChatNew<CR>", { noremap = true, desc = "New chat" })
vim.keymap.set({ "v" }, "<leader>mn", ":<C-u>'<,'>PrtChatNew<CR>", { noremap = true, desc = "New chat" })

vim.keymap.set({ "n" }, "<localleader>\\", ":PrtChatResponde<CR>", { noremap = true, desc = "Responde" })

vim.keymap.set({ "n", "v" }, "<leader>mt", ":PrtChatToggle<CR>", { noremap = true, desc = "Toggle chat" })

vim.keymap.set({ "n", "v" }, "<leader>mf", ":PrtChatFinder<CR>", { noremap = true, desc = "Chat finder" })

vim.keymap.set({ "n", "i" }, "<leader>mr", ":PrtRewrite<CR>", { noremap = true, desc = "Inline rewrite" })
vim.keymap.set({ "v" }, "<leader>mr", ":<C-u>'<,'>PrtRewrite<CR>", { noremap = true, desc = "Visual rewrite" })

vim.keymap.set({ "n" }, "<leader>mj", ":PrtRetry<CR>", { noremap = true, desc = "Retry last request" })

vim.keymap.set({ "n", "i" }, "<leader>mO", ":PrtAppend<CR>", { noremap = true, desc = "Inline append" })
vim.keymap.set({ "v" }, "<leader>mO", ":PrtAppend<CR>", { noremap = true, desc = "Visual append" })

vim.keymap.set({ "n", "i" }, "<leader>mo", ":PrtPrepend<CR>", { noremap = true, desc = "Inline prepend" })
vim.keymap.set({ "v" }, "<leader>mo", ":<C-u>'<,'>PrtPrepend<CR>", { noremap = true, desc = "Visual prepend" })

vim.keymap.set({ "v" }, "<leader>me", ":<C-u>'<,'>PrtEnew<cr>", { noremap = true, desc = "Visual Enew" })
vim.keymap.set({ "v" }, "<leader>ms", ":PrtStop<cr>", { noremap = true, desc = "Stop" })

vim.keymap.set({ "n" }, "<leader>mx", ":PrtContext<cr>", { noremap = true, desc = "Context" })
vim.keymap.set({ "n" }, "<leader>ma", ":PrtAsk<cr>", { noremap = true, desc = "Ask" })

--parrot hooks
vim.keymap.set(
    { "n", "i", "v", "x" },
    "<leader>mi",
    ":<C-u>'<,'>PrtComplete<cr>",
    { noremap = true, desc = "Inline complete" }
)
vim.keymap.set({ "n", "v" }, "<leader>me", ":PrtExplain<CR>", { noremap = true, desc = "Explain code" })
vim.keymap.set({ "n", "v" }, "<leader>mx", ":PrtFixBugs<CR>", { noremap = true, desc = "Fix bugs" })
vim.keymap.set({ "n", "v" }, "<leader>mz", ":PrtOptimize<CR>", { noremap = true, desc = "Explain code" })
