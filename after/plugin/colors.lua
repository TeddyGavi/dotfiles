require("catppuccin").setup({
    flavour = "macchiato", -- latte, frappe, macchiato, mocha
    background = { -- :h background
        light = "macchiato",
        dark = "mocha",
    },
    transparent_background = true, 
})

function ColorMyPencils(color) 
	color = color or "catppuccin"
	vim.cmd [[colorscheme catppuccin]]

	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

end

ColorMyPencils()
