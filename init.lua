-- Load opts before plugins so the leader key is correctly set
require("opts")

require("keys")

require("auto")

-- Register an extra lze handler with the spec_field "for_cat"
-- that makes enabling an lze spec for a category slightly nicer
require("lze").register_handlers(require("nixCatsUtils.lzUtils").for_cat)

-- Register lze handler from lzextras that allows lze to set up lsps
-- and trigger the correct hook for the correct filetype
require("lze").register_handlers(require("lzextras").lsp)

require("plugins")

-- Set coloscheme
vim.cmd.colorscheme(nixCats("colorscheme"))
