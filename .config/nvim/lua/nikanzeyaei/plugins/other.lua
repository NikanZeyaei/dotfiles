return {
	{
		"tpope/vim-surround",
	},
	{
		"stevearc/oil.nvim",
		opts = {
			default_file_explorer = true,
			view_options = {
				show_hidden = true,
				is_hidden_file = function(name, _)
					return vim.startswith(name, ".")
				end,
			},
		},
		-- Optional dependencies
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},
	{
		-- Add indentation guides even on blank lines
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = { indent = { char = "┊" } },
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {}, -- this is equalent to setup({}) function
	},
	{
		"mg979/vim-visual-multi",
	},
}
