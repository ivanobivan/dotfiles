return {
    {
        "neovim/nvim-lspconfig",
        opts = {
            ensure_installed = {
                "prettier",
                "bash",
                "html",
                "javascript",
                "json",
                "lua",
                "markdown",
                "markdown_inline",
                "python",
                "query",
                "regex",
                "tsx",
                "typescript",
                "vim",
                "yaml",
                "jdtls",
            },
            servers = {
                vtsls = {
                    -- отключаем для Angular проектов, чтобы не дублировать angularls
                    filetypes = {
                        "typescript",
                        "typescriptreact",
                        "typescript.tsx",
                        "javascript",
                        "javascriptreact",
                        "javascript.jsx",
                    },
                    init_options = {
                        preferences = {
                            -- отключаем медленные code actions
                            includePackageJsonAutoImports = "off",
                            providePrefixAndSuffixTextForRename = false,
                        },
                    },
                },
                angularls = {
                    -- ускоряем code actions в angular
                    init_options = {
                        angularOnly = true,
                    },
                },
                eslint = {
                    -- автофикс при сохранении через code action
                    on_attach = function(client, bufnr)
                        vim.api.nvim_create_autocmd("BufWritePre", {
                            buffer = bufnr,
                            callback = function()
                                vim.cmd("EslintFixAll")
                            end,
                        })
                    end,
                },
                prettier = {},
            },
            setup = {},
        },
    },
}
