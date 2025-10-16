function ColorMyPencils(color)
	color = color or "bamboo"
	vim.cmd.colorscheme(color)
end

return {
	{
		-- Using lazy.nvim
		{
			'ribru17/bamboo.nvim',
			lazy = false,
			priority = 1000,
			config = function()
				require('bamboo').setup {
					-- optional configuration here
				}
				require('bamboo').load()
			end,
		},

}
}
