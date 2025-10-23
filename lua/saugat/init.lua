require("saugat.set")
require("saugat.remap")
require("saugat.lsp")
require("saugat.lazy_init")
require("saugat.snake_camel")

local augroup = vim.api.nvim_create_augroup
local SaugatGroup = augroup("Saugat", {})

local autocmd = vim.api.nvim_create_autocmd

autocmd("LspAttach", {
	group = SaugatGroup,
	callback = function(e)
		local opts = { buffer = e.buffer }
		vim.keymap.set("n", "gd", function()
			vim.lsp.buf.definition()
		end, opts)
		vim.keymap.set("n", "K", function()
			vim.lsp.buf.hover()
		end, opts)
		vim.keymap.set("n", "<leader>vws", function()
			vim.lsp.buf.workspace_symbol()
		end, opts)
		vim.keymap.set("n", "<leader>vd", function()
			vim.diagnostic.open_float()
		end, opts)
		vim.keymap.set("n", "<leader>vca", function()
			vim.lsp.buf.code_action()
		end, opts)
		vim.keymap.set("n", "<leader>vrr", function()
			vim.lsp.buf.references()
		end, opts)
		vim.keymap.set("n", "<leader>vrn", function()
			vim.lsp.buf.rename()
		end, opts)
		vim.keymap.set("i", "<C-h>", function()
			vim.lsp.buf.signature_help()
		end, opts)
		vim.keymap.set("n", "[d", function()
			vim.diagnostic.goto_next()
		end, opts)
		vim.keymap.set("n", "]d", function()
			vim.diagnostic.goto_prev()
		end, opts)
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "ruby", -- Replace with your desired filetype
	callback = function()
		-- Get the current indentkeys
		local current_keys = vim.opt_local.indentkeys:get()

		-- Remove specific keys, e.g., '0=' (trigger on '=') or '0#' (trigger on '#')
		local filtered_keys = vim.tbl_filter(function(key)
			return key ~= "=when" and key ~= "." and key ~= "=else"
		end, current_keys)

		-- Apply the updated indentkeys list
		vim.opt_local.indentkeys = filtered_keys
	end,
})
