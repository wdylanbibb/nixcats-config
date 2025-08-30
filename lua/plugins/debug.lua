-- if not nixCats("debug") then return end
--
return {
	{
		"nvim-dap",
		for_cat = "debug",
		on_require = "dap",
		keys = {
			{ "<leader>db", "<cmd>DapToggleBreakpoint<CR>", mode = { "n" }, desc = "Debug: Toggle Breakpoint" },
			{
				"<leader>dB",
				function()
					if nixCats("snacks") then
						Snacks.input.input({
							prompt = "Breakpoint Condition",
						}, function(value)
							require("dap").set_breakpoint(value)
						end)
					else
						require("dap").set_breakpoint(vim.fn.input("Breakpoint Condition: "))
					end
				end,
				mode = { "n" },
				desc = "Debug: Set Breakpoint",
			},
			{
				"<leader>dc",
				function()
					require("dap").continue()
				end,
				desc = "Run/[C]ontinue",
			},
			-- {
			-- 	"<leader>da",
			-- 	function()
			-- 		require("dap").continue({ before = get_args })
			-- 	end,
			-- 	desc = "Run with [A]rgs",
			-- },
			{
				"<leader>dC",
				function()
					require("dap").run_to_cursor()
				end,
				desc = "Run to [C]ursor",
			},
			{
				"<leader>dg",
				function()
					require("dap").goto_()
				end,
				desc = "Go to Line (No Execute)",
			},
			{
				"<leader>di",
				function()
					require("dap").step_into()
				end,
				desc = "Step [I]nto",
			},
			{
				"<leader>dj",
				function()
					require("dap").down()
				end,
				desc = "Down",
			},
			{
				"<leader>dk",
				function()
					require("dap").up()
				end,
				desc = "Up",
			},
			{
				"<leader>dl",
				function()
					require("dap").run_last()
				end,
				desc = "Run [L]ast",
			},
			{
				"<leader>do",
				function()
					require("dap").step_out()
				end,
				desc = "Step [O]ut",
			},
			{
				"<leader>dO",
				function()
					require("dap").step_over()
				end,
				desc = "Step [O]ver",
			},
			{
				"<leader>dP",
				function()
					require("dap").pause()
				end,
				desc = "[P]ause",
			},
			{
				"<leader>dr",
				function()
					require("dap").repl.toggle()
				end,
				desc = "Toggle [R]EPL",
			},
			{
				"<leader>ds",
				function()
					require("dap").session()
				end,
				desc = "[S]ession",
			},
			{
				"<leader>dt",
				function()
					require("dap").terminate()
				end,
				desc = "[T]erminate",
			},
			{
				"<leader>dw",
				function()
					require("dap.ui.widgets").hover()
				end,
				desc = "Hover",
			},
			{
				"<leader>du",
				function()
					require("dapui").toggle({})
				end,
				desc = "Dap UI",
			},
			{
				"<leader>de",
				function()
					require("dapui").eval()
				end,
				desc = "Eval",
				mode = { "n", "v" },
			},
		},
		after = function(plugin)
			local dap = require("dap")
			local dapui = require("dapui")

			local pickers = require("telescope.pickers")
			local finders = require("telescope.finders")
			local conf = require("telescope.config").values
			local actions = require("telescope.actions")
			local action_state = require("telescope.actions.state")

			dap.listeners.after.event_initialized["dapui_config"] = dapui.open
			dap.listeners.before.event_terminated["dapui_config"] = dapui.close
			dap.listeners.before.event_exited["dapui_config"] = dapui.close

			if nixCats("c") then
				dap.adapters.codelldb = {
					type = "executable",
					command = "codelldb",
				}
				dap.configurations.c = {
					{
						name = "Launch (CodeLLDB)",
						type = "codelldb",
						request = "launch",
						program = function()
							return coroutine.create(function(coro)
								local opts = {}
								pickers
									.new(opts, {
										prompt_title = "Path to executable",
										finder = finders.new_oneshot_job(
											{ "fd", "--hidden", "--no-ignore", "--type", "x", "-E", ".git" },
											{}
										),
										sorter = conf.generic_sorter(opts),
										attach_mappings = function(buffer_number)
											actions.select_default:replace(function()
												actions.close(buffer_number)
												coroutine.resume(coro, action_state.get_selected_entry()[1])
											end)
											return true
										end,
									})
									:find()
							end)
						end,
						cwd = "${workspaceFolder}",
						stopOnEntry = false,
					},
				}
				dap.configurations.cpp = dap.configurations.c
			end
		end,
		dep_of = { "nvim-dap-ui", "nvim-dap-virtual-text" },
	},
	{
		"nvim-dap-ui",
		for_cat = "debug",
		on_plugin = "nvim-dap",
		on_require = "dapui",
		after = function(plugin)
			require("dapui").setup({
				-- Set icons to characters that are more likely to work in every terminal.
				--    Feel free to remove or use ones that you like more! :)
				--    Don't feel like these are good choices.
				icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
				controls = {
					icons = {
						pause = "⏸",
						play = "▶",
						step_into = "⏎",
						step_over = "⏭",
						step_out = "⏮",
						step_back = "b",
						run_last = "▶▶",
						terminate = "⏹",
						disconnect = "⏏",
					},
				},
			})
		end,
	},
	{
		"nvim-dap-virtual-text",
		for_cat = "debug",
		on_plugin = "nvim-dap",
		after = function(plugin)
			require("nvim-dap-virtual-text").setup({
				enabled = true,
				enabled_commands = true,
				highlight_changed_variables = true,
				highlight_new_as_changed = false,
				show_stop_reason = true,
				commented = false,
				only_first_definition = true,
				all_references = false,
				clear_on_continue = false,
				display_callback = function(variable, buf, stackframe, node, options)
					if options.virt_text_pos == "inline" then
						return " = " .. variable.value
					else
						return variable.name .. " = " .. variable.value
					end
				end,
				virt_text_pos = vim.fn.has("nvim-0.10") == 1 and "inline" or "eol",

				all_frames = false,
				virt_lines = false,
				virt_text_win_col = nil,
			})
		end,
	},
}
