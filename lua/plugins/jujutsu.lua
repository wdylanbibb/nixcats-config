return {
	{
		"lazyjj.nvim",
		cmd = { "LazyJJ" },
		keys = {
			{
				"<leader>jj",
				function()
					require("lazyjj").open()
				end,
				mode = { "n" },
				desc = "LazyJJ",
			},
		},
		after = function(_)
			require("lazyjj").setup({})
		end,
	},
	{
		"hunk.nvim",
		cmd = { "DiffEditor" },
		after = function(_)
			require("hunk").setup()
		end,
	},
}
