return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	opts = {
		menu = {
			width = vim.api.nvim_win_get_width(0) - 4,
		},
		settings = {
			save_on_toggle = true,
			sync_on_ui_close = true,
		},
	},
	keys = {
		{
			"<leader>a",
			function()
				require("harpoon"):list():add()
			end,
		},
		{
			"<C-e>",
			function()
				local harpoon = require("harpoon")
				harpoon.ui:toggle_quick_menu(harpoon:list())
			end,
		},
		{
			"<A-h>",
			function()
				require("harpoon"):list():select(1)
			end,
		},
		{
			"<A-j>",
			function()
				require("harpoon"):list():select(2)
			end,
		},
		{
			"<A-k>",
			function()
				require("harpoon"):list():select(3)
			end,
		},
		{
			"<A-l>",
			function()
				require("harpoon"):list():select(4)
			end,
		},
	},
}
