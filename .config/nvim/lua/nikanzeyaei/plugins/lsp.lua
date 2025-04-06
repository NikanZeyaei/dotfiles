return {
	"neovim/nvim-lspconfig",
	dependencies = {
		{ "williamboman/mason.nvim", config = true },
		{ "j-hui/fidget.nvim", tag = "legacy", opts = {} },
		"folke/neodev.nvim",
		"williamboman/mason-lspconfig.nvim",
		"hrsh7th/cmp-nvim-lsp",
	},

	config = function()
		require("neodev").setup()

		vim.diagnostic.config({ virtual_text = true, signs = true, underline = true })

		local capabilities = vim.tbl_deep_extend(
			"force",
			{},
			vim.lsp.protocol.make_client_capabilities(),
			require("cmp_nvim_lsp").default_capabilities()
		)

		local on_attach = function(client, bufnr)
			vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = bufnr })
			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = bufnr })

			vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr })
			vim.keymap.set("n", "gr", require("telescope.builtin").lsp_references, { buffer = bufnr })
			vim.keymap.set("n", "gI", require("telescope.builtin").lsp_implementations, { buffer = bufnr })

			vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr })
			vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, { buffer = bufnr })

			vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = bufnr })

			vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
				require("conform").format()
			end, {})
		end

		require("fidget").setup({})
		require("mason").setup()
		require("mason-lspconfig").setup({
			automatic_installation = false,
			ensure_installed = {
                "bashls",
				"lua_ls",
				"ts_ls",
				"eslint",
				"gopls",
                "jsonls",
                "sqls",
			},
			handlers = {
				function(server_name)
					require("lspconfig")[server_name].setup({
						capabilities = capabilities,
						on_attach = on_attach,
					})
				end,
			},
		})
	end,
}
