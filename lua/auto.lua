--- [[ Basic Autocommands ]]
--- See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

if nixCats("lsp") then
	-- Set the color of inlay hints to match comments to keep the background
	-- (I like colorschemes to have transparent backgrounds and inlay hints will often
	-- have bright backgrounds)
	vim.api.nvim_create_autocmd({ "Colorscheme", "VimEnter" }, {
		group = vim.api.nvim_create_augroup("Color", {}),
		pattern = "*",
		callback = function()
			vim.api.nvim_set_hl(0, "LspInlayHint", { link = "Comment" })
		end,
	})

	-- Refresh Codelens
	vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
		callback = function()
			vim.lsp.codelens.refresh({ bufnr = 0 })
		end,
	})
end

if nixCats("zellij") then
	local function zellij(mode)
		vim.schedule(function()
			if vim.env.ZELLIJ ~= nil then
				vim.fn.system({ "zellij", "action", "switch-mode", mode })
			end
		end)
	end

	-- Automatically lock and unlock zellij when entering and leaving neovim
	-- Credit to https://github.com/fresh2dev/zellij-autolock/issues/11#issuecomment-2575922784
	vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
		callback = function()
			-- Wait to lock zellij for 100ms so it runs after `FocusLost` autocommand
			vim.defer_fn(function()
				zellij("locked")
			end, 100)
		end,
	})

	vim.api.nvim_create_autocmd({ "FocusLost", "VimLeave" }, {
		callback = function()
			zellij("normal")
		end,
	})
end
