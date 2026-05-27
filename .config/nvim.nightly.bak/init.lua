require('vim._core.ui2').enable({})
require("core")

vim.pack.add({
	-- { src = 'https://github.com/rose-pine/neovim' },
	{ src = "https://github.com/vague2k/vague.nvim" },
	-- { src = "https://github.com/vague-theme/vague.nvim" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/nvim-mini/mini.nvim" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter",          version = "main" },
	{ src = "https://github.com/ibhagwan/fzf-lua" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim" },
	{ src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },
	{ src = "https://github.com/kdheepak/lazygit.nvim" },
	{ src = "https://github.com/stevearc/conform.nvim" },
	{ src = "https://github.com/dmtrKovalenko/fff.nvim" },
})

vim.cmd.colorscheme("vague")
require("nvim-treesitter").setup()

require("oil").setup({
	view_options = {
		show_hidden = true,
	},
	lsp_file_methods = {
		enabled = true,
		timeout_ms = 1000,
		autosave_changes = true,
	},
	float = {
		max_width = 0.5,
		max_height = 0.5,
		border = "rounded",
	},
})

-- require("mini.pick").setup()
-- vim.keymap.set({'n', 'v', 'x'}, '<leader><leader>', ':Pick files<CR>')
require("fzf-lua").setup({
	dependencies = {
		"nvim-mini/mini.icons",
	},
})

vim.keymap.set({ "n", "v", "x" }, "<leader><leader>", ":FzfLua files<CR>")
vim.keymap.set({ "n", "v", "x" }, "<leader>fg", ":FzfLua global<CR>")

vim.keymap.set("n", "<leader>cf", vim.lsp.buf.format)

vim.keymap.set({ "n", "i", "v", "x" }, "<leader>gg", ":LazyGit<CR>")

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- fff
vim.api.nvim_create_autocmd('PackChanged', {
	callback = function(ev)
		local name, kind = ev.data.spec.name, ev.data.kind
		if name == 'fff.nvim' and (kind == 'install' or kind == 'update') then
			if not ev.data.active then
				vim.cmd.packadd('fff.nvim')
			end
			require('fff.download').download_or_build_binary()
		end
	end,
})

vim.g.fff = {
	lazy_sync = true, -- start syncing only when the picker is open
	debug = {
		enabled = true,
		show_scores = true,
	},
}


require("core.config.keymaps")
require("plugins")
