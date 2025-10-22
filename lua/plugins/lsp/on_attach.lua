return function(client, bufnr)
	-- we create a function that lets us more easily define mappings specific
	-- for LSP related items. It sets the mode, buffer and description for us each time

	local function should_attach()
		-- Skip non-file buffers
		local buftype = vim.api.nvim_get_option_value("buftype", { buf = bufnr })
		if buftype ~= "" then
			return false
		end

		-- Skip unlisted buffers
		if not vim.api.nvim_get_option_value("buflisted", { buf = bufnr }) then
			return false
		end

		-- Skip specific filetypes
		local excluded_filetypes = {
			"neo-tree",
			"toggleterm",
			"help",
			"man",
			"gitcommit",
			"gitrebase",
			"fugitive",
			"TelescopePrompt",
		}
		local ft = vim.bo[bufnr].filetype
		if vim.tbl_contains(excluded_filetypes, ft) then
			return false
		end

		-- Skip diff views (by checking all windows displaying this buffer)
		for _, win in ipairs(vim.api.nvim_list_wins()) do
			if vim.api.nvim_win_get_buf(win) == bufnr then
				if vim.api.nvim_get_option_value("diff", { win = win }) then
					return false
				end
			end
		end

		return true
	end

	if not should_attach() then
		client.stop()
		return
	end

	local nmap = function(keys, func, desc)
		if desc then
			desc = "LSP: " .. desc
		end

		vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
	end

	nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
	nmap("gr", vim.lsp.buf.references, "[R]eferences")
	nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
	nmap("gy", vim.lsp.buf.type_definition, "[G]oto T[y]pe Definition")
	nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]elcaration")

	nmap("K", function()
		return vim.lsp.buf.hover()
	end, "Hover")
	nmap("gK", function()
		return vim.lsp.buf.signature_help()
	end, "Signature Help")
	-- nmap("<C-k>", function()
	-- 	return vim.lsp.buf.signature_help()
	-- end, "Signature Help")
	nmap("<leader>ca", vim.lsp.buf.code_action, "Code [A]ction")
	nmap("<leader>cc", vim.lsp.codelens.run, "Run [C]odelens")
	nmap("<leader>cC", vim.lsp.codelens.refresh, "Refresh & Display [C]odelens")
	nmap("<leader>cr", vim.lsp.buf.rename, "[R]ename")
	if nixCats("snacks") then
		nmap("<leader>cl", function()
			Snacks.picker.lsp_config()
		end, "Lsp Info")
		nmap("<leader>cR", function()
			Snacks.rename.rename_file()
		end, "Rename File")
		nmap("]]", function()
			Snacks.words.jump(vim.v.count1)
		end, "Next Reference")
		nmap("[[", function()
			Snacks.words.jump(-vim.v.count1)
		end, "Prev Reference")
	end

	-- Create a command `:Format` local to the LSP buffer
	vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
		vim.lsp.buf.format()
	end, { desc = "Format current buffer with LSP" })

	vim.lsp.inlay_hint.enable(true)
end
