return {
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup({
				signs = {
					-- add = { text = "+" },
					-- change = { text = "~" },
					-- delete = { text = "_" },
					-- topdelete = { text = "‾" },
					-- changedelete = { text = "~" },
				},
			})

			-- Keybindings
			vim.keymap.set("n", "<leader>gp", ":Gitsigns preview_hunk<CR>", { desc = "[G]it [P]review hunk" })
			vim.keymap.set(
				"n",
				"<leader>gb",
				":Gitsigns toggle_current_line_blame<CR>",
				{ desc = "[G]it [B]lame current line" }
			)
		end,
	},
	{
		"tpope/vim-fugitive",
	},
}
