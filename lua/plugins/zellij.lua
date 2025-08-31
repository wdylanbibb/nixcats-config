return {
	{
		"zellij-vim",
		for_cat = "zellij",
		after = function(_)
			vim.keymap.set(
				"n",
				"<C-h>",
				"<cmd>ZellijNavigateLeft!<CR>",
				{ desc = "Move focus to the left window or tab" }
			)
			vim.keymap.set(
				"n",
				"<C-j>",
				"<cmd>ZellijNavigateDown!<CR>",
				{ desc = "Move focus to the lower window or tab" }
			)
			vim.keymap.set(
				"n",
				"<C-k>",
				"<cmd>ZellijNavigateUp!<CR>",
				{ desc = "Move focus to the upper window or tab" }
			)
			vim.keymap.set(
				"n",
				"<C-l>",
				"<cmd>ZellijNavigateRight!<CR>",
				{ desc = "Move focus to the right window or tab" }
			)

			vim.keymap.set("n", "<leader>zn", "<cmd>ZellijNewPane<CR>", { desc = "Open ZelliJ floating pane" })
			vim.keymap.set(
				"n",
				"<leader>zs",
				"<cmd>ZellijNewPaneVSplit<CR>",
				{ desc = "Open ZelliJ pane to the right" }
			)
			vim.keymap.set("n", "<leader>zS", "<cmd>ZellijNewPaneSplit<CR>", { desc = "Open ZelliJ pane below" })

			vim.keymap.set("n", "<leader>zt", "<cmd>ZellijNewTab<CR>", { desc = "Open ZelliJ tab" })

			vim.keymap.set("n", "<leader>zf", function()
				os.execute("zellij action toggle-fullscreen")
			end, { desc = "Toggle pane fullscreen" })
		end,
	},
}
