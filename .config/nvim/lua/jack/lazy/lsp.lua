return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp", -- IMPORTANT: Ensure this is present
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "j-hui/fidget.nvim",
        "mfussenegger/nvim-jdtls", -- Keep this here to install the client plugin
    },

    config = function()
        local cmp = require('cmp')
        local cmp_lsp = require("cmp_nvim_lsp")
        
        -- Use cmp-lsp default capabilities to enable completion
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities())

        require("fidget").setup({})
        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",
                "rust_analyzer",
                "ts_ls",
                "pyright",
                "jdtls", -- Mason installs the server binary
                "clangd",
                "html",
                "cssls",
                "jsonls",
            },
            automatic_installation = true,
            
            -- This is the correct way to prevent lspconfig from starting jdtls
            -- so that nvim-jdtls can handle it correctly via ftplugin/java.lua
            handlers = {
                function(server_name) -- default handler (for everything not listed below)
                    require("lspconfig")[server_name].setup {
                        capabilities = capabilities
                    }
                end,

                ["lua_ls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.lua_ls.setup {
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                diagnostics = {
                                    globals = { "vim", "it", "describe", "before_each", "after_each" },
                                }
                            }
                        }
                    }
                end,
                
                -- Handler to explicitly SKIP jdtls setup by lspconfig
                ["jdtls"] = function()
                    return
                end,
            }
        })
        
        -- CMP SETUP (No changes needed here, it's correct for LSP completion)
        local cmp_select = { behavior = cmp.SelectBehavior.Select }

        cmp.setup({
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping.complete(),
            }),
            sources = cmp.config.sources({
                { name = 'nvim_lsp' }, -- This is what enables LSP completion
                { name = 'luasnip' },
            }, {
                { name = 'buffer' },
            })
        })

        -- DIAGNOSTIC SETUP (Correct)
        vim.diagnostic.config({
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })
        vim.api.nvim_create_autocmd('FileType', {
            pattern='java',
            callback = function(args)
                require'jack.jdtls.jdtls_setup'.setup()
            end
        })
    end -- end of config = function()
} -- end of return {}
