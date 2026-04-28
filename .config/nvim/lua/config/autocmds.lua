vim.api.nvim_create_autocmd("FileType", {
    pattern = { "typescript", "javascript", "html", "css", "less", "scss", "tsx", "jsx", "react", "saas", "sh", "lua" },
    callback = function()
        vim.bo.shiftwidth = 4
        vim.bo.tabstop = 4
        vim.bo.softtabstop = 4
        vim.bo.expandtab = true
    end,
})

vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        local args = vim.fn.argv()
        if #args == 1 and vim.fn.isdirectory(args[1]) == 1 then
            vim.cmd.cd(args[1])
        end
    end,
})
