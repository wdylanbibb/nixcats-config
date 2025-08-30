local load_w_after = function(name)
	vim.cmd.packadd(name)
	vim.cmd.packadd(name .. "/after")
end

return {
	{
		"cmp-cmdline",
		for_cat = "completion",
		on_plugin = { "blink.cmp" },
		load = load_w_after,
	},
	{
		"blink.compat",
		for_cat = "completion",
		dep_of = { "cmp-cmdline" },
	},
	{
		"luasnip",
		for_cat = "completion",
		dep_of = { "blink.cmp", "friendly-snippets" },
		after = function(plugin)
			local luasnip = require("luasnip")
			require("luasnip.loaders.from_vscode").lazy_load()
			luasnip.config.setup({})
		end,
	},
	{
		"colorful-menu.nvim",
		for_cat = "completion",
		on_plugin = { "blink.cmp" },
	},
	{
		"blink.cmp",
		for_cat = "completion",
		event = "DeferredUIEnter",
		after = function(plugin)
			require("blink.cmp").setup({
				-- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
				-- See :help blimk-cmp-keymap for configuring keymaps
				keymap = {
					preset = "default",
				},
				completion = {
					accept = {
						auto_brackets = {
							enabled = true,
						},
					},
					menu = {
						-- auto_show = false, -- Only show menu on manual <C-space>
						border = "rounded",
						draw = {
							treesitter = { "lsp" },
							components = {
								label = {
									text = function(ctx)
										return require("colorful-menu").blink_components_text(ctx)
									end,
									highlight = function(ctx)
										return require("colorful-menu").blink_components_highlight(ctx)
									end,
								},
							},
						},
						winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,CursorLine:BlinkCmpDocCursorLine,Search:None",
					},
					documentation = {
						auto_show = true,
						window = {
							border = "rounded",
						},
					},
				},
				cmdline = {
					keymap = { preset = "inherit" },
					completion = { menu = { auto_show = true } },
					sources = function()
						local type = vim.fn.getcmdtype()
						if type == "/" or type == "?" then
							return { "buffer" }
						end
						if type == ":" or type == "@" then
							return { "cmdline", "cmp_cmdline" }
						end
						return {}
					end,
				},
				snippets = {
					preset = "luasnip",
					active = function(filter)
						local snippet = require("luasnip")
						local blink = require("blink.cmp")
						if snippet.in_snippet() and not blink.is_visible() then
							return true
						else
							if not snippet.in_snippet() and vim.fn.mode() == "n" then
								snippet.unlink_current()
							end
							return false
						end
					end,
				},
				sources = {
					default = { "lsp", "path", "snippets", "buffer" },
					providers = {
						path = { score_offset = 50 },
						lsp = { score_offset = 40 },
						snippets = { score_offset = 40 },
						cmp_cmdline = {
							name = "cmp_cmdline",
							module = "blink.compat.source",
							score_offset = -100,
							opts = { cmp_name = "cmdline" },
						},
					},
				},
			})
		end,
	},
}
