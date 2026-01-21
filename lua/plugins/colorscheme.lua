local M = {}

if nixCats("colorscheme") == "monokai-pro" then
	table.insert(M, {
		"monokai-pro.nvim",
		for_cat = "themer",
		after = function(plugin)
			require("monokai-pro").setup({
				transparent_background = true,
				background_clear = {
					"float_win",
					"telescope",
					"notify",
					"neo-tree",
				},
			})
		end,
	})
end

if nixCats("colorscheme") == "tokyonight" then
	table.insert(M, {
		"tokyonight.nvim",
		for_cat = "themer",
		after = function(plugin)
			require("tokyonight").setup({
				style = "night",
				plugins = {
					all = true,
				},
			})
		end,
	})
end

return M
