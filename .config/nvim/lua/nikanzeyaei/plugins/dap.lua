return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			{
				"rcarriga/nvim-dap-ui",
				dependencies = { "nvim-neotest/nvim-nio" },
				opts = {},
			},
			{
				"jay-babu/mason-nvim-dap.nvim",
				dependencies = { "williamboman/mason.nvim" },
				opts = {
					ensure_installed = { "python" },
					handlers = {
						function(config)
							require("mason-nvim-dap").default_setup(config)
						end,
					},
				},
			},
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			local function project_root()
				return vim.fs.root(0, { "pyproject.toml", ".git" }) or vim.fn.getcwd()
			end

			local function python_path()
				local root = project_root()
				local poetry = vim.system({ "poetry", "env", "info", "-p" }, { cwd = root }):wait()

				if poetry.code == 0 then
					local venv = vim.trim(poetry.stdout)
					if venv ~= "" then
						return venv .. "/bin/python"
					end
				end

				local venv = root .. "/.venv/bin/python"
				if vim.fn.executable(venv) == 1 then
					return venv
				end

				return "python3"
			end

			local function manage_py()
				local matches = vim.fn.globpath(project_root(), "**/manage.py", false, true)
				if #matches == 0 then
					error("No manage.py found below " .. project_root())
				end
				return matches[1]
			end

			local function manage_py_directory()
				return vim.fn.fnamemodify(manage_py(), ":h")
			end

			dap.configurations.python = {
				{
					type = "python",
					request = "launch",
					name = "Python: Current file",
					program = "${file}",
					python = python_path,
				},
				{
					type = "python",
					request = "launch",
					name = "Django: runserver",
					program = manage_py,
					cwd = manage_py_directory,
					args = { "runserver", "--noreload" },
					django = true,
					python = python_path,
				},
				{
					type = "python",
					request = "launch",
					name = "Django: manage.py command",
					program = manage_py,
					cwd = manage_py_directory,
					args = function()
						return vim.split(vim.fn.input("Django command: ", "test"), "%s+", { trimempty = true })
					end,
					django = true,
					python = python_path,
				},
				{
					type = "python",
					request = "attach",
					name = "Python: Attach to debugpy",
					connect = {
						host = "127.0.0.1",
						port = function()
							return tonumber(vim.fn.input("debugpy port: ", "5678"))
						end,
					},
				},
			}

			dap.listeners.before.attach.dapui_config = dapui.open
			dap.listeners.before.launch.dapui_config = dapui.open
			dap.listeners.before.event_terminated.dapui_config = dapui.close
			dap.listeners.before.event_exited.dapui_config = dapui.close
		end,
	},
}
