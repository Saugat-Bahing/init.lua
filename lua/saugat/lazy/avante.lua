return {
	"yetone/avante.nvim",
	build = "make",
	event = "VeryLazy",
	version = false,
	opts = {
		provider = "copilot",
		auto_suggestions_provider = "copilot", -- Specify provider for auto suggestions
		behaviour = {
			auto_suggestions = false, -- Disable auto suggestions to prevent conflicts with Copilot
			auto_set_highlight_group = false,
			auto_set_keymaps = false,
			auto_apply_diff_after_generation = false,
			support_paste_from_clipboard = false,
			minimize_diff = true, -- Whether to remove unchanged lines when applying a code block
		},
		suggestion = {
			debounce = 400, -- Reduced from default 600ms for faster suggestions
			throttle = 400, -- Reduced from default 600ms for faster suggestions
		},
	},
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"nvim-tree/nvim-web-devicons",
		"zbirenbaum/copilot.lua",
		{
			"MeanderingProgrammer/render-markdown.nvim",
			opts = {
				file_types = { "markdown", "Avante" },
			},
			ft = { "markdown", "Avante" },
		},
	},
}
