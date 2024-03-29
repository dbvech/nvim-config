return {
	"akinsho/flutter-tools.nvim",
	lazy = false,
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
	},
	config = function()
		require("flutter-tools").setup({
			decorations = {
				statusline = {
					app_version = true,
					device = true,
					project_config = true,
				},
			},
			debugger = { -- integrate with nvim dap + install dart code debugger
				enabled = true,
				run_via_dap = true, -- use dap instead of a plenary job to run flutter apps
				register_configurations = function(_)
					require("dap").configurations.dart = {}
					require("dap.ext.vscode").load_launchjs()
				end,
				-- register_configurations = function(paths)
				-- require("dap").configurations.dart = {
				-- {
				-- 	name = "Debug",
				-- 	request = "launch",
				-- 	type = "dart",
				-- 	args = { "--dart-define-from-file", ".env" },
				-- },
				-- {
				-- 	name = "Profile",
				-- 	request = "launch",
				-- 	type = "dart",
				-- 	flutterMode = "profile",
				-- 	args = { "--dart-define-from-file", ".env" },
				-- },
				-- {
				-- 	name = "Release",
				-- 	request = "launch",
				-- 	type = "dart",
				-- 	flutterMode = "release",
				-- 	args = { "--dart-define-from-file", ".env" },
				-- },
				-- }
				-- end,
			},
		})

		pcall(require("telescope").load_extension, "flutter")
		vim.keymap.set(
			"n",
			"<leader>fc",
			require("telescope").extensions.flutter.commands,
			{ desc = "[F]lutter [C]ommands" }
		)
	end,
}
