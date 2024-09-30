vim.api.nvim_create_user_command("ColorManagerToggleCustomOptions", function()
    require("colorscheme-manager").toggle_custom_options()
end, {})

vim.api.nvim_create_user_command("ColorManagerChangeColor", function(colorscheme)
    require("colorscheme-manager").switch_colorscheme(colorscheme.args)
end, { nargs = 1, complete = "color" })
