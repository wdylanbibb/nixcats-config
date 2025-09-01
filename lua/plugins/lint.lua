return {
	{
		-- https://github.com/mfussenegger/nvim-lint
		"nvim-lint",
		for_cat = "lint",
		event = "DeferredUIEnter",
		after = function(_)
			local function addIf(package, linter)
				return nixCats(package) and { linter } or {}
			end

			require("lint").linters_by_ft = {
				nix = addIf("nix", "nix"),
				c = addIf("c", "clangtidy"),
				lua = addIf("lua", "luac"),
			}

			if nixCats("c") then
				require("lint").linters.clangtidy.args = {
					"--quiet",
					"-checks=bugprone-*",
				}
			end

			require("lint").try_lint()

			vim.api.nvim_create_autocmd({ "BufWritePost" }, {
				callback = function()
					require("lint").try_lint()
				end,
			})
		end,
	},
}
