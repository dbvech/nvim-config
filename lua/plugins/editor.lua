return {
	"tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically
	-- Highlight todo, notes, etc in comments
	{
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
	},
	{
		"mg979/vim-visual-multi", -- :help visual-multi
		branch = "master",
	},
	{
		"luukvbaal/statuscol.nvim",
		config = function()
			local builtin = require("statuscol.builtin")

			require("statuscol").setup({
				relculright = true,
				segments = {
					{
						sign = { name = { ".*" }, maxwidth = 1, colwidth = 1 },
						click = "v:lua.ScSa",
					},
					{
						text = { " ", builtin.lnumfunc },
						condition = { true, builtin.not_empty },
						click = "v:lua.ScLa",
					},
					{
						sign = { namespace = { "gitsigns" }, colwidth = 1, wrap = true },
						click = "v:lua.ScSa",
					},
					{
						text = { builtin.foldfunc, " " },
						click = "v:lua.ScFa",
					},
				},
			})
		end,
	},
	{
		"kevinhwang91/nvim-ufo",
		dependencies = {
			"kevinhwang91/promise-async",
		},
		config = function()
			require("ufo").setup({
				-- provider_selector = function()
				-- 	return { "lsp", "treesitter" }
				-- end,
			})

			-- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
			vim.keymap.set("n", "zR", require("ufo").openAllFolds)
			vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
		end,
	},
}
