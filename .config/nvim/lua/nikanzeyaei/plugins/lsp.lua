return {
	"neovim/nvim-lspconfig",
	dependencies = {
		{ "williamboman/mason.nvim", config = true },
		{ "j-hui/fidget.nvim", opts = {} },
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

		---@diagnostic disable-next-line: unused-local
		local on_attach = function(client, bufnr)
			vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = bufnr })
			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = bufnr })
			vim.keymap.set("n", "<leader>lk", function()
				vim.diagnostic.open_float()
			end, { buffer = bufnr })

			vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr })
			vim.keymap.set("n", "gr", require("telescope.builtin").lsp_references, { buffer = bufnr })
			vim.keymap.set("n", "gI", require("telescope.builtin").lsp_implementations, { buffer = bufnr })

			vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr })
			vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, { buffer = bufnr })

			vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = bufnr })

			vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
				require("conform").format()
			end, {})
		end

		require("fidget").setup({})
		require("mason").setup()

		local servers = {
			"bashls",
			"lua_ls",
			"eslint",
			"gopls",
			"jsonls",
			"sqls",
			"clangd",
			"biome",
		}

		local server_configs = {
			-- denols = {
			-- 	root_markers = { "deno.json", "deno.jsonc" },
			-- },
			-- ts_ls = {
			-- 	root_markers = { "package.json" },
			-- 	single_file_support = true,
			-- },
			biome = {
				root_markers = { "biome.json" },
			},
			clangd = {
				single_file_support = true,
			},
			elixirls = {
				root_markers = { "mix.exs" },
			},
			rust_analyzer = {
				root_markers = { "Cargo.toml" },
			},
			tailwindcss = {
				init_options = {
					userLanguages = {
						elixir = "html-eex",
						eelixir = "html-eex",
						heex = "html-eex",
					},
				},
			},
		}

		for name, _ in pairs(server_configs) do
			table.insert(servers, name)
		end

		require("mason-lspconfig").setup({
			automatic_installation = false,
			ensure_installed = servers,
		})

		local base = {
			capabilities = capabilities,
			on_attach = on_attach,
		}

		vim.lsp.enable("gleam")

		for _, name in ipairs(servers) do
			local cfg = vim.tbl_deep_extend("force", base, server_configs[name] or {})
			vim.lsp.config(name, cfg)
			vim.lsp.enable(name)
		end
	end,
}
