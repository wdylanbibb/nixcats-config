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
			local black = "#000000"
			require("tokyonight").setup({
				style = "night",
				transparent = true,

				plugins = {
					all = true,
				},

				on_colors = function(c)
					-- local black = "#000000"
					c.bg_float = black
					c.bg_popup = black
				end,
			})
		end,
	})
end

return M
