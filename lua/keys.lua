--- [[ Basic Keymaps ]]
--- See `:help vim.keymap.set()`

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })

-- Use CTRL+<hjkl> to switch between windows
-- See `:help wincmd` for a list of all window commands
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Use SHIFT+<hl> to switch between buffers
vim.keymap.set("n", "<S-h>", "<cmd>bp<CR>", { desc = "Move focus to the previous buffer" })
vim.keymap.set("n", "<S-l>", "<cmd>bn<CR>", { desc = "Move focus to the next buffer" })

-- Close current buffer
vim.keymap.set("n", "<leader>bd", function()
	if nixCats("snacks") then
		Snacks.bufdelete()
	else
		vim.api.nvim_buf_delete(vim.api.nvim_get_current_buf(), {})
	end
end, { desc = "[D]elete current buffer" })

-- See installed plugins
vim.keymap.set("n", "<leader>n", "<cmd>NixCats pawsible<CR>", { desc = "See Installed Plugins" })
