local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end

vim.opt.rtp:prepend(lazypath)

require("nikanzeyaei.remaps")
require("nikanzeyaei.sets")

require("lazy").setup({
	spec = { import = "nikanzeyaei.plugins" },
	change_detection = { notify = false },
})

local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = "*",
})

vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		-- ColorMyCatppuccin()
        ColorMyGruberDarker()
	end,
})
