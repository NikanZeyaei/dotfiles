return {
	"lewis6991/gitsigns.nvim",
	opts = {
		signs = {
			add = { text = "+" },
			change = { text = "~" },
			delete = { text = "_" },
			topdelete = { text = "‾" },
			changedelete = { text = "~" },
		},
		on_attach = function(bufnr)
			-- Set up highlight groups (new recommended way)
			vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = "#00ff00", bg = nil })
			vim.api.nvim_set_hl(0, "GitSignsChange", { fg = "#ffff00", bg = nil })
			vim.api.nvim_set_hl(0, "GitSignsDelete", { fg = "#ff0000", bg = nil })
			vim.api.nvim_set_hl(0, "GitSignsChangedelete", { link = "GitSignsChange" })
			vim.api.nvim_set_hl(0, "GitSignsTopdelete", { link = "GitSignsDelete" })

			vim.keymap.set("n", "<leader>hp", require("gitsigns").preview_hunk, { buffer = bufnr })

			-- don't override the built-in and fugitive keymaps
			local gs = package.loaded.gitsigns
			vim.keymap.set({ "n", "v" }, "]c", function()
				if vim.wo.diff then
					return "]c"
				end
				vim.schedule(function()
					gs.next_hunk()
				end)
				return "<Ignore>"
			end, { expr = true, buffer = bufnr, desc = "Jump to next hunk" })
			vim.keymap.set({ "n", "v" }, "[c", function()
				if vim.wo.diff then
					return "[c"
				end
				vim.schedule(function()
					gs.prev_hunk()
				end)
				return "<Ignore>"
			end, { expr = true, buffer = bufnr, desc = "Jump to previous hunk" })
		end,
	},
}
