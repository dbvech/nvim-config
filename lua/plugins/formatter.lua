return {
	"stevearc/conform.nvim",
	dependencies = { "mason.nvim" },
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>F",
			function()
				require("conform").format({ async = false, lsp_fallback = false })
			end,
			mode = "",
			desc = "Format buffer",
		},
	},
	config = function()
		require("conform").setup({
			notify_on_error = false,
			-- Define your formatters
			formatters_by_ft = {
				lua = { "stylua" },
				javascript = { { "prettierd", "prettier" } },
				typescript = { { "prettierd", "prettier" } },
				vue = { { "prettierd", "prettier" } },
			},
			-- Set up format-on-save
			format_on_save = function(bufnr)
				-- Disable with a global or buffer-local variable
				if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
					return
				end
				local disable_filetypes = { c = true, cpp = true }
				return {
					timeout_ms = 500,
					lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
				}
			end,
			-- Customize formatters
			formatters = {
				shfmt = {
					prepend_args = { "-i", "2" },
				},
			},
		})

		vim.api.nvim_create_user_command("FormatDisable", function(args)
			if args.bang then
				-- FormatDisable! will disable formatting just for this buffer
				local bufnr = vim.api.nvim_get_current_buf()
				vim.b[bufnr].disable_autoformat = true
			else
				vim.g.disable_autoformat = true
			end
		end, {
			desc = "Disable autoformat-on-save",
			bang = true,
		})

		vim.api.nvim_create_user_command("FormatEnable", function()
			local bufnr = vim.api.nvim_get_current_buf()
			vim.b[bufnr].disable_autoformat = false
			vim.g.disable_autoformat = false
		end, {
			desc = "Re-enable autoformat-on-save",
		})

		vim.keymap.set(
			"n",
			"<leader>W",
			":FormatDisable<CR>:w<CR>:FormatEnable<CR>",
			{ silent = true, desc = "Write the buffer without formatting" }
		)

		vim.keymap.set("n", "<leader>fe", ":FormatEnable<CR>", { desc = "Re-enable autoformat-on-save" })
		vim.keymap.set("n", "<leader>fd", ":FormatDisable<CR>", { desc = "Disable autoformat-on-save" })

		vim.keymap.set(
			"n",
			"<leader>fD",
			":FormatDisable!<CR>",
			{ desc = "Disable autoformat-on-save for this buffer" }
		)
	end,
}
