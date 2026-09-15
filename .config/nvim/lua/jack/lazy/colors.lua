function ColorMyPencils(color)
	color = color or "bamboo"
	vim.cmd.colorscheme(color)

    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

return {
	{
		-- Using lazy.nvim
		{
			'ribru17/bamboo.nvim',
			lazy = false,
			priority = 1000,
			config = function()
				require('bamboo').setup ({
                    code_style = {
                        comments = { italic = false },
                        keywords = {italic = false},
					-- optional configuration here
				},
            })
				require('bamboo').load()
			end,
    },

}
}
