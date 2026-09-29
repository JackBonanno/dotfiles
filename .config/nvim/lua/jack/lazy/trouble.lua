return {
    {
        "folke/trouble.nvim",
        config = function()
            local trouble = require("trouble")

            trouble.setup({
                -- Trouble v3 icon configuration (disabling icons)
                icons = {
                    indent = {
                        top = " ",
                        middle = " ",
                        last = " ",
                        fold_open = " ",
                        fold_closed = " ",
                        ws = " ",
                    },
                    folder_closed = "",
                    folder_open = "",
                    kinds = {},
                },
            })

            -- ThePrimeagen's keymaps
            vim.keymap.set("n", "<leader>tt", function()
                trouble.toggle()
            end)

            vim.keymap.set("n", "[t", function()
                trouble.next({ skip_groups = true, jump = true })
            end)

            vim.keymap.set("n", "]t", function()
                trouble.previous({ skip_groups = true, jump = true })
            end)
        end

    }
}
