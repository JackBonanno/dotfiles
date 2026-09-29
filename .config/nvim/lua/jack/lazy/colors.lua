function ColorMyPencils(color)
	color = color or "bamboo"
	vim.cmd.colorscheme(color)

    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

return {
	{
		-- Using lazy.nvim
--		{
--			'ribru17/bamboo.nvim',
--			lazy = false,
--			priority = 1000,
--			config = function()
--				require('bamboo').setup ({
--                    code_style = {
--                        comments = { italic = false },
--                        keywords = {italic = false},
--					-- optional configuration here
--				},
--            })
--				require('bamboo').load()
--			end,
--    },
{
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
        require("catppuccin").setup({
            flavour = "mocha", -- latte, frappe, macchiato, mocha
            background = {
                light = "latte",
                dark = "mocha",
            },
            transparent_background = false,
            integrations = {
                cmp = true,
                gitsigns = true,
                nvimtree = true,
                telescope = true,
                treesitter = true,
            },
            styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
                comments = {  }, -- Change the style of comments
                conditionals = {  },
                loops = {},
                functions = {},
                keywords = {},
                strings = {},
                variables = {},
                numbers = {},
                booleans = {},
                properties = {},
                types = {},
                operators = {},
                -- miscs = {}, -- Uncomment to turn off hard-coded styles
            },

        })

        -- setup must be called before loading the colorscheme
        vim.cmd.colorscheme "catppuccin-mocha"
    end,
}

}
}
