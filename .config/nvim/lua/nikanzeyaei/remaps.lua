vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Oil)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("x", "<leader>p", [["_dP]])

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({ "n", "v" }, "<leader>d", '"_d')

vim.keymap.set("n", "Q", "<nop>")

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz", { desc = "Next location list" })
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz", { desc = "Previous location list" })

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

vim.keymap.set("n", "<leader>db", function()
	require("dap").toggle_breakpoint()
end, { desc = "Toggle breakpoint" })
vim.keymap.set("n", "<leader>dc", function()
	require("dap").continue()
end, { desc = "Continue debugging" })
vim.keymap.set("n", "<leader>di", function()
	require("dap").step_into()
end, { desc = "Step into" })
vim.keymap.set("n", "<leader>do", function()
	require("dap").step_over()
end, { desc = "Step over" })
vim.keymap.set("n", "<leader>dO", function()
	require("dap").step_out()
end, { desc = "Step out" })
vim.keymap.set("n", "<leader>dt", function()
	require("dap").terminate()
end, { desc = "Terminate debugger" })
vim.keymap.set("n", "<leader>du", function()
	require("dapui").toggle()
end, { desc = "Toggle debug UI" })
vim.keymap.set({ "n", "v" }, "<leader>de", function()
	require("dapui").eval()
end, { desc = "Evaluate expression" })
