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
                eslint = {},
                prettier = {},
            },
            setup = {},
        },
    },
}
