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

		local function get_python_path()
				local function find_pyproject(start_path)
					local cwd = start_path or vim.fn.getcwd()
					local marker = cwd .. "/pyproject.toml"
					if vim.fn.filereadable(marker) == 1 then
						return cwd
					end
					local parent = vim.fn.fnamemodify(cwd, ":h")
					if parent ~= cwd and parent ~= "" then
						return find_pyproject(parent)
					end
					return nil
				end

				local project_root = find_pyproject()
				if project_root then
					local handle = io.popen("cd " .. project_root .. " && poetry env info -p 2>/dev/null")
					if handle then
						local result = handle:read("*a"):gsub("%s+$", "")
						handle:close()
						if result and result ~= "" and result ~= "No virtualenv" then
							return result .. "/bin/python"
						end
					end
					local venv_path = project_root .. "/.venv"
					if vim.fn.isdirectory(venv_path) == 1 then
						return venv_path .. "/bin/python"
					end
				end
				return "python3"
			end

		vim.diagnostic.config({ virtual_text = true, signs = true, underline = true })

		local capabilities = vim.tbl_deep_extend(
			"force",
			{},
			vim.lsp.protocol.make_client_capabilities(),
			require("cmp_nvim_lsp").default_capabilities()
		)

		local lsp_keymaps = function(bufnr)
			vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = bufnr, desc = "Rename symbol" })
			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = bufnr, desc = "Code action" })
			vim.keymap.set("n", "<leader>lk", function()
				vim.diagnostic.open_float()
			end, { buffer = bufnr, desc = "Line diagnostics" })

			vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "Go to definition" })
			vim.keymap.set("n", "gr", require("telescope.builtin").lsp_references, { buffer = bufnr, desc = "References" })
			vim.keymap.set("n", "gI", require("telescope.builtin").lsp_implementations, { buffer = bufnr, desc = "Implementations" })

			vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "Hover" })
			vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, { buffer = bufnr, desc = "Signature help" })

			vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = bufnr, desc = "Go to declaration" })

			vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
				require("conform").format()
			end, {})
		end

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("NikanzeyaeiLspKeymaps", { clear = true }),
			callback = function(event)
				lsp_keymaps(event.buf)
			end,
		})

		require("fidget").setup({})
		require("mason").setup()

		local servers = {
			-- "bashls",
			"lua_ls",
			"eslint",
			-- "gopls",
			-- "jsonls",
			"sqls",
			-- "clangd",
			"biome",
		}

		local server_configs = {
			-- denols = {
			-- 	root_markers = { "deno.json", "deno.jsonc" },
			-- },
			tsc = {},
			biome = {
				root_markers = { "biome.json" },
			},
			pyright = {
				settings = {
					python = {
						pythonPath = get_python_path(),
						analysis = {
							typeCheckingMode = "basic",
							autoSearchPaths = true,
							useLibraryCodeForTypes = true,
							diagnosticMode = "workspace",
							extraPaths = {},
						},
					},
				},
			},
			ruff = {
				init_options = {
					settings = {
						args = {},
					},
				},
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
		}

		vim.lsp.enable("gleam")

		for _, name in ipairs(servers) do
			local cfg = vim.tbl_deep_extend("force", base, server_configs[name] or {})
			vim.lsp.config(name, cfg)
			vim.lsp.enable(name)
		end
	end,
}
