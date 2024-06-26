vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.termguicolors = true
vim.opt.exrc = true

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true

vim.opt.number = true
vim.opt.relativenumber = true

-- Keep signcolumn on by default
vim.opt.signcolumn = "yes"

-- Case-insensitive searching UNLESS \C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = "a"

-- Don't show the mode, since it's already in status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
vim.opt.clipboard = "unnamedplus"

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
-- vim.opt.list = true
-- vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Preview substitutions live, as you type!
vim.opt.inccommand = "split"

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- Disable line wrapping
vim.opt.wrap = false

-- Enable break indent
vim.opt.breakindent = true

vim.opt.swapfile = false
vim.opt.backup = false

-- Save undo history
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- Folding settings
vim.o.foldcolumn = "1" -- '0' is not bad
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.opt.incsearch = true

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Set diagnostic icons
vim.fn.sign_define("DiagnosticSignError", { text = " ", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn", { text = " ", texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInfo", { text = " ", texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint", { text = "󰌵", texthl = "DiagnosticSignHint" })

-- Sort diagnostics by severity
vim.diagnostic.config({ severity_sort = true })

local function diagnostic_severity_sign()
	-- Create a custom namespace. This will aggregate signs from all other
	-- namespaces and only show the one with the highest severity on a
	-- given line
	local ns = vim.api.nvim_create_namespace("dbvech-diagnostic-signs")

	-- Get a reference to the original signs handler
	local orig_signs_handler = vim.diagnostic.handlers.signs

	-- Override the built-in signs handler
	vim.diagnostic.handlers.signs = {
		show = function(_, bufnr, _, opts)
			-- Get all diagnostics from the whole buffer rather than just the
			-- diagnostics passed to the handler
			local diagnostics = vim.diagnostic.get(bufnr)

			-- Find the "worst" diagnostic per line
			local max_severity_per_line = {}
			for _, d in pairs(diagnostics) do
				local m = max_severity_per_line[d.lnum]
				if not m or d.severity < m.severity then
					max_severity_per_line[d.lnum] = d
				end
			end

			-- Pass the filtered diagnostics (with our custom namespace) to
			-- the original handler
			local filtered_diagnostics = vim.tbl_values(max_severity_per_line)
			orig_signs_handler.show(ns, bufnr, filtered_diagnostics, opts)
		end,
		hide = function(_, bufnr)
			orig_signs_handler.hide(ns, bufnr)
		end,
	}
end

diagnostic_severity_sign()
