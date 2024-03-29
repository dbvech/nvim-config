return {
	"mfussenegger/nvim-dap",
	dependencies = {
		-- Creates a beautiful debugger UI
		"rcarriga/nvim-dap-ui",

		"nvim-neotest/nvim-nio",

		-- Installs the debug adapters for you
		"williamboman/mason.nvim",
		"jay-babu/mason-nvim-dap.nvim",

		-- Add your own debuggers here
		"leoluz/nvim-dap-go",
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")

		require("mason-nvim-dap").setup({
			-- Makes a best effort to setup the various debuggers with
			-- reasonable debug configurations
			automatic_setup = true,

			-- You can provide additional configuration to the handlers,
			-- see mason-nvim-dap README for more information

			-- handlers = {
			-- 	dart = function(config)
			-- 		local flutter_path = "$HOME/fvm/default"
			--
			-- 		dap.adapters.dart = {
			-- 			type = "executable",
			-- 			command = "dart",
			-- 			args = { "debug_adapter" },
			-- 		}
			--
			-- 		dap.adapters.flutter = {
			-- 			type = "executable",
			-- 			command = "flutter",
			-- 			args = { "debug_adapter" },
			-- 		}
			--
			-- 		config.configurations = {
			-- 			{
			-- 				type = "dart",
			-- 				request = "launch",
			-- 				name = "Launch dart",
			-- 				dartSdkPath = flutter_path .. "/bin/dart",
			-- 				flutterSdkPath = flutter_path,
			-- 				program = "${workspaceFolder}/lib/main.dart",
			-- 				cwd = "${workspaceFolder}",
			-- 			},
			-- 			{
			-- 				name = "Flutter: Attach",
			-- 				type = "flutter",
			-- 				request = "attach",
			-- 				dartSdkPath = flutter_path .. "/bin/dart",
			-- 				flutterSdkPath = flutter_path,
			-- 				program = "${workspaceFolder}/lib/main.dart",
			-- 				cwd = "${workspaceFolder}",
			-- 				toolArgs = function()
			-- 					-- if vim.g.flutter_device_id == nil then
			-- 					-- 	vim.notify("Please select a device to attach to with <F8>", vim.log.levels.ERROR)
			-- 					-- 	return
			-- 					-- end
			-- 					-- return { "--device-id", vim.g.flutter_device_id }
			-- 					return {}
			-- 				end,
			-- 			},
			-- 			{
			-- 				name = "Flutter: Run",
			-- 				type = "flutter",
			-- 				request = "launch",
			-- 				dartSdkPath = flutter_path .. "/bin/dart",
			-- 				flutterSdkPath = flutter_path,
			-- 				program = "${workspaceFolder}/lib/main.dart",
			-- 				cwd = "${workspaceFolder}",
			-- 				toolArgs = { "--dart-define-from-file", ".env" },
			-- 			},
			-- 		}
			-- 		-- Keep original functionality
			-- 		require("mason-nvim-dap").default_setup(config)
			-- 	end,
			-- },

			ensure_installed = {
				"delve", -- golang
				"dart",
				"flutter",
				"javascript",
				"typescript",
			},
		})

		-- Basic debugging keymaps, feel free to change to your liking!
		vim.keymap.set("n", "<F8>", function()
			local function select_flutter_device()
				-- local async = require("plenary.async")
				local Job = require("plenary.job")

				local get_devices_job = Job:new({
					command = "flutter",
					args = { "devices" },
				})

				local result = get_devices_job:sync(10000)

				local devices = {}
				for _, line in pairs(result) do
					if line:find("•", 1, true) then
						local device_info = {}
						local parts = {}
						for part in line:gmatch("[^•]+") do
							parts[#parts + 1] = part:match("^%s*(.-)%s*$")
						end
						device_info["name"] = parts[1]
						device_info["id"] = parts[2]

						devices[#devices + 1] = device_info
					end
				end

				vim.ui.select(devices, {
					prompt = "Select a device to attach to",
					format_item = function(item)
						return item["name"]
					end,
				}, function(choice)
					vim.g.flutter_device_id = choice["id"]
				end)
			end

			select_flutter_device()
		end, { desc = "Debug: Select Device" })

		vim.keymap.set("n", "<F5>", dap.continue, { desc = "Debug: Start/Continue" })
		vim.keymap.set("n", "<F1>", dap.step_into, { desc = "Debug: Step Into" })
		vim.keymap.set("n", "<F2>", dap.step_over, { desc = "Debug: Step Over" })
		vim.keymap.set("n", "<F3>", dap.step_out, { desc = "Debug: Step Out" })
		vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
		vim.keymap.set("n", "<leader>dB", function()
			dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
		end, { desc = "Debug: Set Breakpoint" })

		-- Dap UI setup
		-- For more information, see |:help nvim-dap-ui|
		dapui.setup(
			-- {
			-- Set icons to characters that are more likely to work in every terminal.
			--    Feel free to remove or use ones that you like more! :)
			--    Don't feel like these are good choices.
			-- icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
			-- controls = {
			-- 	icons = {
			-- 		pause = "⏸",
			-- 		play = "▶",
			-- 		step_into = "⏎",
			-- 		step_over = "⏭",
			-- 		step_out = "⏮",
			-- 		step_back = "b",
			-- 		run_last = "▶▶",
			-- 		terminate = "⏹",
			-- 		disconnect = "⏏",
			-- 	},
			-- },
			-- }
		)

		-- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
		vim.keymap.set("n", "<F7>", dapui.toggle, { desc = "Debug: See last session result." })

		dap.listeners.before.attach.dapui_config = dapui.open
		dap.listeners.before.launch.dapui_config = dapui.open
		dap.listeners.before.event_terminated.dapui_config = dapui.close
		dap.listeners.before.event_exited.dapui_config = dapui.close

		-- Install golang specific config
		-- require("dap-go").setup()
	end,
}
