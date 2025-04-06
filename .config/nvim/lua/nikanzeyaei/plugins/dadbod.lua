return {
	"tpope/vim-dadbod",
	dependencies = {
		"kristijanhusak/vim-dadbod-ui",
		"kristijanhusak/vim-dadbod-completion",
	},
	opt = true,
	cmd = {
		"DBUI",
		"DBUIToggle",
		"DBUIAddConnection",
		"DBUIFindBuffer",
	},
	config = function()
		vim.g.db_ui_use_nerd_fonts = 1
		vim.g.db_ui_show_database_icon = 1
		vim.g.db_ui_force_echo_notifications = 1
		vim.g.db_ui_win_position = "left"
		vim.g.db_ui_winwidth = 30

		vim.g.db_ui_save_location = vim.fn.stdpath("config") .. "/db_ui"

		vim.keymap.set("n", "<leader>du", "<cmd>DBUIToggle<CR>", { desc = "Toggle DBUI" })
		vim.keymap.set("n", "<leader>df", "<cmd>DBUIFindBuffer<CR>", { desc = "Find DB Buffer" })
		vim.keymap.set("n", "<leader>dr", "<cmd>DBUIRenameBuffer<CR>", { desc = "Rename DB Buffer" })
		vim.keymap.set("n", "<leader>dq", "<cmd>DBUILastQueryInfo<CR>", { desc = "Last Query Info" })
	end,
} 
