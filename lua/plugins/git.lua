return {
	{
		"gitsigns.nvim",
		for_cat = "git",
		event = "DeferredUIEnter",
		after = function(plugin)
			require("gitsigns").setup({
				signs = {
					add = { text = "+" },
					change = { text = "~" },
					delete = { text = "_" },
					topdelete = { text = "‾" },
					changedelete = { text = "~" },
				},
				on_attach = function(bufnr)
					local gitsigns = require("gitsigns")

					local function map(mode, l, r, opts)
						opts = opts or {}
						opts.buffer = bufnr
						vim.keymap.set(mode, l, r, opts)
					end

					-- Navigation
					map("n", "]c", function()
						if vim.wo.diff then
							vim.cmd.normal({ "]c", bang = true })
						else
							gitsigns.nav_hunk("next")
						end
					end, { desc = "Jump to next git [c]hange" })

					map("n", "[c", function()
						if vim.wo.diff then
							vim.cmd.normal({ "[c", bang = true })
						else
							gitsigns.nav_hunk("prev")
						end
					end, { desc = "Jump to previous git [c]hange" })

					-- Actions
					-- visual mode
					map("v", "<leader>ghs", function()
						gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end, { desc = "Stage next git hunk" })
					map("v", "<leader>ghr", function()
						gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end, { desc = "Reset git hunk" })
					-- normal mode
					map("n", "<leader>ghs", gitsigns.stage_hunk, { desc = "Git [S]tage Hunk" })
					map("n", "<leader>ghr", gitsigns.reset_hunk, { desc = "Git [R]eset Hunk" })
					map("n", "<leader>ghS", gitsigns.stage_buffer, { desc = "Git [S]tage Buffer" })
					-- map("n", "<leader>ghu", gitsigns.undo_stage_hunk, { desc = "Git [U]ndo Stage Hunk" })
					map("n", "<leader>ghR", gitsigns.reset_buffer, { desc = "Git [R]eset Buffer" })
					map("n", "<leader>ghp", gitsigns.preview_hunk, { desc = "Git [P]review Hunk" })
					map("n", "<leader>ghb", gitsigns.blame_line, { desc = "Git [B]lame Line" })
					map("n", "<leader>ghd", gitsigns.diffthis, { desc = "Git [D]iff Against Index" })
					map("n", "<leader>ghD", function()
						gitsigns.diffthis("@")
					end, { desc = "Git [D]iff Against Last Commit" })
					--Toggles
					map(
						"n",
						"<leader>gtb",
						gitsigns.toggle_current_line_blame,
						{ desc = "Toggle Git Show [B]lame Line" }
					)
					map("n", "<leader>gtD", gitsigns.preview_hunk_inline, { desc = "Toggle Git Show [D]eleted" })
				end,
			})
		end,
	},
	{
		"lazygit.nvim",
		for_cat = "git",
		cmd = {
			"LazyGit",
			"LazyGitConfig",
			"LazyGitCurrentFile",
			"LazyGitFilter",
			"LazyGitFilterCurrentFile",
		},
		keys = {
			{ "<leader>gg", "<cmd>LazyGit<CR>", desc = "LazyGit" },
		},
	},
	{
		"diffview.nvim",
		for_cat = "git",
		cmd = {
			"DiffviewFileHistory",
			"DiffviewOpen",
		},
		before = function(_)
			vim.opt.fillchars:append({ diff = "╱" })
		end,
	},
	{
		"vim-fugitive",
		for_cat = "git",
		event = "DeferredUIEnter",
	},
	{
		"vim-rhubarb",
		for_cat = "git",
		event = "DeferredUIEnter",
	},
}
