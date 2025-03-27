return {
	"neovim/nvim-lspconfig",
	dependencies = {
		-- "stevearc/conform.nvim",
		{ "williamboman/mason.nvim", config = true },

		-- Useful status updates for LSP
		-- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
		{ "j-hui/fidget.nvim", tag = "legacy", opts = {} },

		-- Additional lua configuration, makes nvim stuff amazing!
		"folke/neodev.nvim",

		"williamboman/mason-lspconfig.nvim",

		"hrsh7th/nvim-cmp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"saadparwaiz1/cmp_luasnip",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-nvim-lua",
		"hrsh7th/cmp-vsnip",

		"rafamadriz/friendly-snippets",

		"L3MON4D3/LuaSnip",
		"saadparwaiz1/cmp_luasnip",

		"hrsh7th/cmp-nvim-lsp",

		"rafamadriz/friendly-snippets",

		-- 'lukas-reineke/cmp-rg'
	},

	config = function()
		require("neodev").setup()

		vim.diagnostic.config({ virtual_text = true, signs = true, underline = true })

		require("luasnip.loaders.from_vscode").lazy_load()

		local cmp = require("cmp")
		local cmp_lsp = require("cmp_nvim_lsp")

		local capabilities = vim.tbl_deep_extend(
			"force",
			{},
			vim.lsp.protocol.make_client_capabilities(),
			cmp_lsp.default_capabilities()
		)

		---@diagnostic disable-next-line: unused-local
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
				-- vim.lsp.buf.format()
				require("conform").format()
			end, { desc = "Format current buffer with LSP" })
		end

		require("fidget").setup({})
		require("mason").setup()
		require("mason-lspconfig").setup({
			automatic_installation = false,
			ensure_installed = {
				"lua_ls",
				"ts_ls",
				"eslint",
				"gopls",
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

		local luasnip = require("luasnip")
		luasnip.config.setup({})

		cmp.setup({
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<C-n>"] = cmp.mapping.select_next_item(),
				["<C-p>"] = cmp.mapping.select_prev_item(),
				["<C-d>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-Space>"] = cmp.mapping.complete({}),
				["<CR>"] = cmp.mapping.confirm({
					behavior = cmp.ConfirmBehavior.Replace,
					select = true,
				}),
				["<Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item()
					elseif luasnip.expand_or_locally_jumpable() then
						luasnip.expand_or_jump()
					else
						fallback()
					end
				end, { "i", "s" }),
				["<S-Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					elseif luasnip.locally_jumpable(-1) then
						luasnip.jump(-1)
					else
						fallback()
					end
				end, { "i", "s" }),
			}),
			---@diagnostic disable-next-line: missing-fields
			formatting = {
				format = function(entry, vim_item)
					vim_item.menu = ({
						rg = "[Rg]",
						buffer = "[Buffer]",
						nvim_lsp = "[LSP]",
						vsnip = "[Snippet]",
						path = "[Path]",
					})[entry.source.name]
					return vim_item
				end,
			},
			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "luasnip" },
				{ name = "buffer" },
				{ name = "rg" },
				{ name = "path" },
			}, {
				{ name = "buffer" },
			}),
		})
	end,
}
