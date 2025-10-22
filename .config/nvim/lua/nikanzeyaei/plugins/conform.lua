return {
    "stevearc/conform.nvim",
    opts = {
        formatters_by_ft = {
            lua = { "stylua", lsp_format = "fallback" },
            -- javascript = { "eslint_d", "prettierd", stop_after_first = true },
            typescript = { "biome", lsp_format = "fallback" },
            -- javascriptreact = { "eslint_d", "prettierd", stop_after_first = true },
            -- typescriptreact = { "eslint_d", "prettierd", stop_after_first = true },
            go = { "gofumpt", "golines", "goimports" },
            c = { "clang-format" },
            sql = { "sqlfmt" },
        },
    },
    keys = {
        {
            "<leader>cf",
            function()
                local conform = require("conform")
                conform.format()
            end,
            desc = "Format file",
        },
        {
            "<leader>ce",
            function() require("conform").format({ formatters = { "eslint_d" } }) end,
            desc = "ESLint fix all (eslint_d)",
        },
    },
}
