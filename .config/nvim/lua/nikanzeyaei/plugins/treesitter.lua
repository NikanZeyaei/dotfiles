return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			local treesitter = require("nvim-treesitter")
			local languages = {
				"bash",
				"c",
				"javascript",
				"jsdoc",
				"lua",
				"typescript",
			}

			treesitter.setup()

			local install = treesitter.install(languages)
			if #vim.api.nvim_list_uis() == 0 then
				install:wait(300000)
			end

			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("NikanzeyaeiTreeSitter", { clear = true }),
				pattern = languages,
				callback = function(event)
					local max_filesize = 100 * 1024 -- 100 KB
					local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(event.buf))

					if ok and stats and stats.size > max_filesize then
						vim.notify("File larger than 100KB treesitter disabled for performance", vim.log.levels.WARN, {
							title = "Treesitter",
						})
						return
					end

					vim.treesitter.start(event.buf)
					vim.bo[event.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end,
			})
		end,
	},
}
