return {
	"olimorris/codecompanion.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
	},
	config = function()
		local default_model = "google/gemini-2.0-flash-001"
		local available_models = {
			"google/gemini-2.0-flash-001",
			"google/gemini-2.5-pro-preview-03-25",
			"anthropic/claude-3.7-sonnet",
			"anthropic/claude-3.5-sonnet",
			"openai/gpt-4o-mini",
		}
		local current_model = default_model

		local function select_model()
			vim.ui.select(available_models, {
				prompt = "Select  Model:",
			}, function(choice)
				if choice then
					current_model = choice
					vim.notify("Selected model: " .. current_model)
				end
			end)
		end

		require("codecompanion").setup({
			strategies = {
				chat = {
					adapter = "openrouter",
				},
				inline = {
					adapter = "openrouter",
				},
			},
			adapters = {
				http = {
					openrouter = function()
						-- Extends the "openai_compatible" adapter with OpenRouter-specific settings.
						return require("codecompanion.adapters").extend("openai_compatible", {
							env = {
								-- OpenRouter API URL
								url = "https://openrouter.ai/api",
								-- API key retrieved from the environment variable OPENAI_API_KEY
								api_key = os.getenv("OPENAI_API_KEY"),
								-- Chat completions endpoint
								chat_url = "/v1/chat/completions",
							},
							schema = {
								-- Model to use for OpenRouter (defaults to the current model).
								model = {
									default = current_model,
								},
							},
						})
					end,
				},
			},
		})

		vim.keymap.set({ "n", "v" }, "<leader>ck", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
		vim.keymap.set("v", "ga", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true })

		vim.keymap.set("n", "<leader>cs", select_model, { desc = "Select Gemini Model" })
		-- Expand 'cc' into 'CodeCompanion' in the command line
		vim.cmd([[cab cc CodeCompanion]])
	end,
}
