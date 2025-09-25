return {
	{
		"conform.nvim",
		for_cat = "format",
		event = { "BufWrite" },
		keys = {
			{ "<leader>FF", desc = "[F]ormat [F]ile" },
		},
		after = function(plugin)
			local conform = require("conform")

			conform.setup({
				formatters_by_ft = {
					lua = { "stylua" },
					nix = { "nixfmt" },
					c = { "clang-format" },
					rust = { "rustfmt" },
					ocaml = { "ocamlformat" },
				},
				format_on_save = {
					timeout_ms = 500,
					lsp_format = "fallback",
				},
			})

			vim.keymap.set({ "n", "v" }, "<leader>FF", function()
				conform.format({
					lsp_fallback = true,
					async = false,
					timeout_ms = 1000,
				})
			end, { desc = "[F]ormat [F]ile" })
		end,
	},
}
