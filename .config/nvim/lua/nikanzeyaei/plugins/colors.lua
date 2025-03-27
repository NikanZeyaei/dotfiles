function ColorMyCatppuccin()
	vim.opt.background = "dark"
	vim.opt.termguicolors = true
	vim.cmd.colorscheme("catppuccin")

	vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
	vim.api.nvim_set_hl(0, "NormalNC", { link = "Normal" })
end

return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			vim.cmd.colorscheme("catppuccin")
		end,
	},
}
