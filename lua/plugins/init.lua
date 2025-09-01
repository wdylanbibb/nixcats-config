--- [[ General Plugins ]]
--- Plugins specified here are a part of the base neovim setup
require("lze").load({
	{
		"lualine.nvim",
		for_cat = "general",
		event = "VimEnter",
		after = function(_)
			require("lualine").setup({
				options = {
					icons_enabled = false,
					component_separators = "|",
					section_separators = "",
				},
				sections = {
					lualine_c = {
						{ "filename", path = 1, status = true },
						{ require("recorder").recordingStatus },
					},
					lualine_x = {
						{ require("recorder").displaySlots },
						{ "encoding" },
						{ "fileformat" },
						{ "filetype" },
					},
				},
				inactive_sections = {
					lualine_b = {
						{ "filename", path = 3, status = true },
					},
					lualine_x = { "filetype" },
				},
				tabline = {
					lualine_a = { "buffers" },
					lualine_z = { "lsp_status" },
				},
				extensions = { "fugitive", "neo-tree", "nvim-dap-ui", "toggleterm", "trouble" },
			})
		end,
	},
	{
		"better-escape.nvim",
		for_cat = "general",
		event = "DeferredUIEnter",
		after = function(_)
			require("better_escape").setup({
				mappings = {
					i = { j = { j = false } },
					c = { j = { j = false } },
				},
			})
		end,
	},
	{
		"neo-tree.nvim",
		for_cat = "general",
		keys = {
			-- Load neo tree on key press
			{ "<leader>ft", "<cmd>Neotree toggle<CR>", desc = "NeoTree [T]oggle" },
		},
		after = function(_)
			require("neo-tree").setup({})
		end,
	},
	{
		"noice.nvim",
		for_cat = "general",
		event = "VimEnter",
		after = function(_)
			require("noice").setup({
				lsp = {
					override = {
						["vim.lsp.util.convert_input_to_markdown_lines"] = true,
						["vim.lsp.util.stylize_markdown"] = true,
						["cmp.entry.get_documentation"] = true,
					},
				},
				presets = {
					command_palette = true,
					long_message_to_split = true,
					lsp_doc_border = true,
				},
			})
		end,
	},
	{
		"which-key.nvim",
		for_cat = "general",
		after = function(_)
			local wk = require("which-key")
			wk.add({
				{ "<leader>b", group = "[B]uffer" },
				{ "<leader>f", group = "[F]iletree" },
				{ "<leader>s", group = "[S]earch" },
			})

			if nixCats("git") then
				wk.add({
					{ "<leader>g", group = "[G]it" },
					{ "<leader>gt", group = "[T]oggle" },
					{ "<leader>gh", group = "[H]unks" },
				})
			end

			if nixCats("lsp") then
				wk.add({
					{ "<leader>c", group = "[C]ode" },
					{ "<leader>x", group = "Diagnostics" },
				})
			end

			if nixCats("debug") then
				wk.add({
					{ "<leader>d", group = "[D]ebug" },
				})
			end

			if nixCats("format") then
				wk.add({
					{ "<leader>F", group = "[F]ormat" },
				})
			end

			if nixCats("zellij") then
				wk.add({
					{ "<leader>z", group = "[Z]elliJ" },
				})
			end
		end,
	},
	{
		"nvim-notify",
		for_cat = "general",
		after = function(_)
			require("notify").setup({
				background_colour = "#000000",
			})
			vim.notify = require("notify")
		end,
		dep_of = { "nvim-recorder" },
	},
	{
		"telescope.nvim",
		for_cat = "general",
		cmd = { "Telescope" },
		-- NOTE: our on attach function defines keybinds that call telescope.
		-- so, the on_require handler will load telescope when we use those.
		on_require = { "telescope" },
		keys = {
			{
				"<leader><leader>",
				function()
					return require("telescope.builtin").find_files()
				end,
				mode = { "n" },
				desc = "Find Files",
			},
			{
				"<leader>/",
				function()
					-- Slightly advanced example of overriding default behavior and theme
					-- You can pass additional configuration to telescope to change theme, layout, etc.
					require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
						winblend = 10,
						previewer = false,
					}))
				end,
				mode = { "n" },
				desc = "Fuzzily search in current buffer",
			},
			{
				"<leader>s/",
				function()
					require("telescope.builtin").live_grep({
						grep_open_files = true,
						prompt_title = "Live Grep in Open Files",
					})
				end,
				mode = { "n" },
				desc = "Search in Open Files",
			},
			{ "<leader>sM", "<cmd>Telescope notify<CR>", mode = { "n" }, desc = "Search [M]essage" },
			{
				"<leader>sd",
				function()
					return require("telescope.builtin").diagnostics()
				end,
				mode = { "n" },
				desc = "Search [D]iagnostics",
			},
			{
				"<leader>sg",
				function()
					return require("telescope.builtin").live_grep()
				end,
				mode = { "n" },
				desc = "Live [G]rep",
			},
			{
				"<leader>sb",
				function()
					return require("telescope.builtin").buffers()
				end,
				mode = { "n" },
				desc = "Search [B]uffers",
			},
			{
				"<leader>sk",
				function()
					return require("telescope.builtin").keymaps()
				end,
				mode = { "n" },
				desc = "Search [K]eymaps",
			},
			{
				"<leader>ss",
				function()
					return require("telescope.builtin").builtin()
				end,
				mode = { "n" },
				desc = "Search Telescope",
			},
			{
				"<leader>sh",
				function()
					return require("telescope.builtin").help_tags()
				end,
				mode = { "n" },
				desc = "Search [H]elp",
			},
		},
		after = function(_)
			require("telescope").setup({
				-- `:help telescope.setup()`
				defaults = {
					mappings = {
						i = { ["<c-enter>"] = "to_fuzzy_refine" },
					},
				},
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown(),
					},
				},
			})

			pcall(require("telescope").load_extension, "fzf")
			pcall(require("telescope").load_extension, "ui-select")
		end,
	},
	{
		"nvim-treesitter",
		for_cat = "general",
		dep_of = { "mini.nvim", "nvim-treesitter-textobjects" },
		event = "DeferredUIEnter",
		after = function(_)
			require("nvim-treesitter.configs").setup({
				highlight = { enable = true },
				indent = { enable = true },
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "<c-space>",
						node_incremental = "<c-space>",
						scope_incremental = "<c-s>",
						node_decremental = "<M-space>",
					},
				},
				textobjects = {
					select = {
						enable = true,
						lookahead = true,
						keymaps = {
							-- 	["aa"] = "@parameter.outer",
							-- 	["ia"] = "@parameter.inner",
							-- ["af"] = "@function.outer",
							-- ["if"] = "@function.inner",
							-- 	["ac"] = "@class.outer",
							-- 	["ic"] = "@class.inner",
						},
					},
					move = {
						enable = true,
						set_jumps = true,
						-- goto_next_start = {
						-- 	["]m"] = "@function.outer",
						-- 	["]]"] = "@class.outer",
						-- },
						-- goto_next_end = {
						-- 	["]M"] = "@function.outer",
						-- 	["]["] = "@class.outer",
						-- },
						-- goto_previous_start = {
						-- 	["[m"] = "@function.outer",
						-- 	["[["] = "@class.outer",
						-- },
						-- goto_previous_end = {
						-- 	["[M"] = "@function.outer",
						-- 	["[]"] = "@class.outer",
						-- },
					},
					swap = {
						enable = true,
						swap_next = {
							["<leader>w"] = "@parameter.inner",
						},
						swap_previous = {
							["<leader>W"] = "@parameter.inner",
						},
					},
				},
			})
		end,
	},
	{
		"mini.nvim",
		for_cat = "general",
		event = "DeferredUIEnter",
		after = function(_)
			-- Better Around/Inside text objects
			-- Examples:
			--  - va)  - [V]isually select [A]round [)]paren
			--  - yinq - [Y]ank [I]nside [N]ext [']quote
			--  - ci'  - [C]hange [I]nside [']quote
			-- require("mini.ai").setup({ n_lines = 500 })
			local ai = require("mini.ai")
			ai.setup({
				n_lines = 500,
				custom_textobjects = {
					o = ai.gen_spec.treesitter({ -- code block
						a = { "@block.outer", "@conditional.outer", "@loop.outer" },
						i = { "@block.inner", "@conditional.inner", "@loop.inner" },
					}),
					f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }), -- function
					c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }), -- class
					t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" }, -- tags
					d = { "%f[%d]%d+" }, -- digits
					e = { -- Word with case
						{
							"%u[%l%d]+%f[^%l%d]",
							"%f[%S][%l%d]+%f[^%l%d]",
							"%f[%P][%l%d]+%f[^%l%d]",
							"^[%l%d]+%f[^%l%d]",
						},
						"^().*()$",
					},
					u = ai.gen_spec.function_call(), -- u for "Usage"
					U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }), -- without dot in function name
				},
			})

			-- Add/delete/replace surroundings (brackets, quotes, etc.)
			-- Examples:
			--  - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
			--  - sd'   - [S]urround [D]elete [']quotes
			--  - sr)'  - [S]urround [R]eplace [)] [']
			require("mini.surround").setup({
				mappings = {
					add = "gsa",
					delete = "gsd",
					find = "gsf",
					find_left = "gsF",
					highlights = "gsh",
					replace = "gsr",
					update_n_lines = "gsn",
				},
			})

			-- Icon provider
			require("mini.icons").setup()

			-- Autopairs
			require("mini.pairs").setup({
				modes = { insert = true, command = true, terminal = false },
				skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
				skip_ts = { "string" },
				skip_unbalanced = true,
				markdown = true,
			})
		end,
	},
	{
		"nvim-comment",
		for_cat = "general",
		after = function(_)
			require("nvim_comment").setup()
		end,
	},
	{
		"indent-blankline.nvim",
		for_cat = "general",
		after = function(_)
			require("ibl").setup({
				indent = { char = "▏" },
				scope = {
					show_start = false,
					show_end = false,
				},
				exclude = {
					filetypes = {
						"help",
						"neo-tree",
						"notify",
						"toggleterm",
					},
				},
			})
		end,
	},
	{
		"toggleterm.nvim",
		for_cat = "general",
		cmd = "ToggleTerm",
		keys = {
			{ [[<c-\>]], "<cmd>ToggleTerm<CR>", mode = { "n", "t" }, desc = "Open ToggleTerm" },
		},
		after = function(_)
			require("toggleterm").setup({
				direction = "float",
				float_opts = {
					border = "curved",
				},
			})
		end,
	},
	{
		"dropbar.nvim",
		for_cat = "general",
		event = "DeferredUIEnter",
		after = function(_)
			local dropbar_api = require("dropbar.api")
			vim.keymap.set("n", "<leader>;", dropbar_api.pick, { desc = "Pick symbols in winbar" })
			vim.keymap.set("n", "[;", dropbar_api.goto_context_start, { desc = "Go to start of current context" })
			vim.keymap.set("n", "];", dropbar_api.select_next_context, { desc = "Select next context" })
		end,
	},
	{
		"nvim-recorder",
		for_cat = "general",
		event = "VimEnter",
		after = function(_)
			require("recorder").setup({
				useNerdfontIcons = false,
				lessNotifications = true,
			})
		end,
		dep_of = { "lualine.nvim" },
	},
	require("plugins.snacks"),
	require("plugins.git"),
	require("plugins.completion"),
	require("plugins.lsp"),
	require("plugins.lint"),
	require("plugins.format"),
	require("plugins.debug"),
	require("plugins.colorscheme"),
	require("plugins.zellij"),
	require("plugins.jujutsu"),
})
