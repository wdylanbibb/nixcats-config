if nixCats("lspDebugMode") then
	vim.lsp.set_log_level("debug")
end

-- NOTE: This file uses lzextras.lsp handler https://github.com/BirdeeHub/lzextras?tab=readme-ov-dile#lsp-handler
-- This is a slightly more performant fallback function
-- for when you don't provide a filetype to trigger on yourself
-- nixCats gives us the paths, which is faster than searching the rtp!
local old_ft_fallback = require("lze").h.lsp.get_ft_fallback()
require("lze").h.lsp.set_ft_fallback(function(name)
	local lspcfg = nixCats.pawsible({ "allPlugins", "opt", "nvim-lspconfig" })
		or nixCats.pawsible({ "allPlugins", "start", "nvim-lspconfig" })
	if lspcfg then
		local ok, cfg = pcall(dofile, lspcfg .. "/lsp/" .. name .. ".lua")
		if not ok then
			ok, cfg = pcall(dofile, lspcfg .. "/lua/lspconfig/configs/" .. name .. ".lua")
		end
		return (ok and cfg or {}).filetypes or {}
	else
		return old_ft_fallback(name)
	end
end)

return {
	{
		"trouble.nvim",
		for_cat = "lsp",
		cmd = { "Trouble" },
		keys = {
			{ "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", mode = { "n" }, desc = "Diagnostics (Trouble)" },
			{
				"<leader>xX",
				"<cmd>Trouble diagnostics toggle filter.buf=0<CR>",
				mode = { "n" },
				desc = "Buffer diagnostics (Trouble)",
			},
			{
				"<leader>cs",
				"<cmd>Trouble symbols toggle focus=false<CR>",
				mode = { "n" },
				desc = "Symbols (Trouble)",
			},
			{
				"<leader>cd",
				"<cmd>Trouble lsp toggle focus=false win.position=right<CR>",
				mode = { "n" },
				desc = "LSP Definitions / references / ... (Trouble)",
			},
			{ "<leader>xL", "<cmd>Trouble loclist toggle<CR>", mode = { "n" }, desc = "Location List (Trouble)" },
			{ "<leader>xQ", "<cmd>Trouble qflist toggle<CR>", mode = { "n" }, desc = "Quickfix List (Trouble)" },
		},
		after = function(_)
			require("trouble").setup()
		end,
	},
	{
		"lazydev.nvim",
		for_cat = "lua",
		cmd = { "LazyDev" },
		ft = "lua",
		after = function(plugin)
			require("lazydev").setup({
				library = {
					{ words = { "nixCats" }, path = (nixCats.nixCatsPath or "") .. "/lua" },
				},
			})
		end,
	},
	{
		"clangd_extensions.nvim",
		for_cat = "c",
		ft = { "c", "h", "cpp", "hpp", "objc", "objcpp", "cuda" },
	},
	{
		"rustaceanvim",
		for_cat = "rust",
		before = function(plugin)
			vim.g.rustaceanvim = {
				server = {
					on_attach = function(client, bufnr)
						require("plugins.lsp.on_attach")(client, bufnr)
						require("lsp_lines").setup()
						vim.diagnostic.config({
							virtual_text = false,
							virtual_lines = true,
						})
					end,
				},
			}
		end,
	},
	{
		"lsp_lines.nvim",
		for_cat = "rust",
		on_plugin = { "rustaceanvim" },
		-- after = function(_)
		-- 	require("lsp_lines").setup()
		-- 	vim.diagnostic.config({
		-- 		virtual_text = false,
		-- 		virtual_lines = true,
		-- 	})
		-- end,
	},
	{
		"nvim-lspconfig",
		for_cat = "lsp",
		on_require = { "lspconfig" },
		-- NOTE: define a function for lsp,
		-- and it will run for all specs with type(plugin.lsp) == table
		-- when their filetype trigger loads them
		lsp = function(plugin)
			vim.lsp.config(plugin.name, plugin.lsp or {})
			vim.lsp.enable(plugin.name)
		end,
		before = function(plugin)
			vim.lsp.config("*", {
				on_attach = require("plugins.lsp.on_attach"),
			})
		end,
	},
	{
		-- name of the lsp
		"lua_ls",
		enabled = nixCats("lua") or false,
		-- provide a table containing filetypes,
		-- and then whatever your functions defined in the function type specs expect.
		-- in our case, it just expects the normal lspconfig setup options,
		-- but with a default on_attach and capabilities
		lsp = {
			-- if you provide the filetypes it doesn't ask lspconfig for the filetypes
			filetypes = { "lua" },
			settings = {
				Lua = {
					runtime = { version = "LuaJIT" },
					formatters = {
						ignoreComments = true,
					},
					signatureHelp = { enabled = true },
					diagnostics = {
						globals = { "nixCats", "vim" },
						disable = { "missing-fields" },
					},
					telemetry = { enabled = false },
				},
			},
		},
	},
	{
		"nixd",
		enabled = nixCats("nix") or false,
		lsp = {
			filetypes = { "nix" },
			settings = {
				nixd = {
					-- nixd requires some configuration.
					-- luckily, the nixCats plugin is here to pass whatever we need!
					-- we passed this in via the `extra` table in our packageDefinitions
					-- for additional configuration options, refer to:
					-- https://github.com/nix-community/nixd/blob/main/nixd/docs/configuration.md
					nixpkgs = {
						expr = nixCats.extra("nixdExtras.nixpkgs") or [[import <nixpkgs> {}]],
					},
					options = {
						-- If you integrated with your system flake,
						-- you should use inputs.self as the path to your system flake
						-- that way it will ALWAYS work, regardless of where your config actually was
						nixos = {
							-- nixdExtras.nixos_options = ''(builtins.getFlake "path:${builtins.toString inputs.set.outPath}").nixosConfigurations.configname.options''
							expr = nixCats.extra("nixdExtras.nixos_options"),
						},
						-- If you have your config as a separate flake, inputs.self would be referring to the wrong flake.
						-- You can override the correct one into your package definition on import in your main configuration,
						-- or just put an absolute path to where it usually is and accept the impurity.
						["home-manager"] = {
							-- nixdExtras.home_manager_options = ''(builtins.getFlake "path:${builtins.toString inputs.self.outPath}").homeConfigurations.configname.options''
							expr = nixCats.extra("nixdExtras.home_manager_options"),
						},
					},
					formatting = {
						command = { "nixfmt" },
					},
					diagnostic = {
						suppress = {
							"sema-escaping-with",
						},
					},
				},
			},
		},
	},
	{
		"clangd",
		enabled = nixCats("c") or false,
		lsp = {
			filetypes = { "c", "h", "cpp", "hpp", "objc", "objcpp", "cuda" },
			cmd = { "clangd", "--background-index", "--log=verbose" },
			on_attach = require("plugins.lsp.on_attach"),
		},
	},
	{
		"ocamllsp",
		enabled = nixCats("ocaml") or false,
		lsp = {
			filetypes = { "ocaml" },
		},
	},
}
