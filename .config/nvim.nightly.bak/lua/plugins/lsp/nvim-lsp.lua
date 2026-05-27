-- update diagnostic config function
vim.diagnostic.config({
	signs = { text = signs },
	virtual_text = true,
	underline = true, -- Always on
	update_in_insert = true,
	float = {
		focusable = false,
		style = "minimal",
		border = "rounded",
		source = true,
	},
})

-- <leader>lx toggle for virtual text (no hover changes)
vim.keymap.set("n", "<leader>lx", function()
	local current = vim.diagnostic.config().virtual_text
	vim.diagnostic.config({ virtual_text = not current })
end, { desc = "Toggle LSP virtual text" })

-- NOTE: Setup servers
-- local cmp_nvim_lsp = require("cmp_nvim_lsp")
-- local capabilities = cmp_nvim_lsp.default_capabilities()

-- Native LSP capabilities (if dropping cmp_nvim_lsp)
local capabilities = vim.lsp.protocol.make_client_capabilities()

-- Global LSP settings (applied to all servers)
vim.lsp.config('*', {
	capabilities = capabilities
})


-- Diagnostics
vim.diagnostic.config({
	-- Use the default configuration
	-- virtual_lines = true

	-- Alternatively, customize specific options
	virtual_lines = {
		-- Only show virtual line diagnostics for the current cursor line
		current_line = true,
	},
})

-- Configure and enable LSP servers
-- lua_ls
vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
			completion = {
				callSnippet = "Replace",
			},
			-- workspace = {
			--     library = {
			--         [vim.fn.expand("$VIMRUNTIME/lua")] = true,
			--         [vim.fn.stdpath("config") .. "/lua"] = true,
			--     },
			-- },
		},
	},
})

-- emmet_language_server
vim.lsp.config("emmet_language_server", {
	filetypes = {
		"css",
		"html",
		"javascript",
		"javascriptreact",
		"less",
		"typescriptreact",
	},
	init_options = {
		includeLanguages = {},
		excludeLanguages = {},
		extensionsPath = {},
		preferences = {},
		showAbbreviationSuggestions = true,
		showExpandedAbbreviation = "always",
		showSuggestionsAsSnippets = false,
		syntaxProfiles = {},
		variables = {},
	},
})

-- emmet_ls
vim.lsp.config("emmet_ls", {
	filetypes = {
		"html",
		"typescriptreact",
		"javascriptreact",
		"css",
		"sass",
		"scss",
	},
})

-- ts_ls (TypeScript/JavaScript)
vim.lsp.config("ts_ls", {
	workspace_required = false,
	filetypes = {
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
	},
	single_file_support = true,
	init_options = {
		preferences = {
			includeCompletionsForModuleExports = true,
			includeCompletionsForImportStatements = true,
		},
	},
	settings = {
		typescript = {
			inlayHints = {
				includeInlayParameterNameHints = "all",
				includeInlayVariableTypeHints = true,
				includeInlayFunctionParameterTypeHints = true,
			},
		},
		javascript = {
			inlayHints = {
				includeInlayParameterNameHints = "none",
				includeInlayVariableTypeHints = false,
				includeInlayFunctionParameterTypeHints = false,
			},
		},
	},
})

-- gopls
vim.lsp.config("gopls", {
	settings = {
		gopls = {
			analyses = {
				unusedparams = true,
			},
			staticcheck = true,
			gofumpt = true,
		},
	},
})

-- css
vim.lsp.config("cssls", {
	filetypes = { "css", "scss", "less" },
	init_options = { provideFormatter = true },
	single_file_support = true,
	settings = {
		css = {
			lint = {
				unknownAtRules = "ignore",
			},
			validate = true
		},
		scss = {
			lint = {
				unknownAtRules = "ignore"
			},
			validate = true
		},
		less = {
			lint = {
				unknownAtRules = "ignore"
			},
			validate = true
		},
	},
})

-- tailwind
vim.lsp.config("tailwindcss", {
	filetypes = {
		"html",
		"css",
		"javascript",
		"typescript",
		"javascriptreact",
		"typescriptreact",
		"vue",
	},
})

-- Instead of using mason enable all configured LSP via `automatic_enable=true`
-- Prefer more control, enable manual server call below via vim.lsp.enable("")
vim.lsp.enable({
	"intelephense",
	"lua_ls",
	"cssls",
	"emmet_language_server",
	"emmet_ls",
	"ts_ls",
	"gopls",
	"tailwindcss",
	"marksman",
})
