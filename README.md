# colorscheme-manager.nvim

A custom plugin for Neovim to manage neovim visuals.

## Why Use It?
This is a single plugin in which you could not only load your colorschemes, but also pass your
custom and favorite changes as a function, so it is able to toggle them on and off. 

This allows for a custom experience for testing different colorschemes and how your functions affect them.

### How It Works
`colorscheme-manager.nvim` is built to work with the following parameters:
- **colorscheme**: This parameter is the string that represents the colorscheme you would like to activate in your environment. You should pass the exact value you would pass to the `colorscheme` command.
- **custom_options_function**: This function sets all the custom UI changes you prefer.
- **enable_custom_options [Optional]**: A boolean flag that indicates if the plugin should run the `custom_options_function`. If no value is provided it's automatically set to true if you pass the `custom_options_function` setup function.
- **autocmd [Optional]**: A boolean flag to indicate if the plugin should sync itself to the `ColorScheme` autocmd
    > Note: 
    > This is encouraged, since it attaches the `custom_options_function` to the Color Scheme event, allowing the user to use both the `colorscheme` and `ColorManagerChangeColor` commands interchangeably. 

## Getting Started
### Lazy

```lua
{
    "Diogo364/colorscheme-manager.nvim",
    tag = "0.2.0"
}
```

## Usage and Commands
As mentioned before, this should be helpful when switching your colorscheme and keeping your UI setup.
Therefore, we provide a set of commands to allow you to see how your setup is affected by your choices:
- `:ColorManagerToggleCustomOptions`: Enable/Disable your custom options function.
- `:ColorManagerChangeColor <your-favorite-colorscheme-here>`: Changes your colorscheme and applies your custom options function, if enabled.

## Customization
Use this guide to setup your personal preferences.

```lua
local ColorMyPencils = function()
    -- Yes, this is from ThePrimeagen's config
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

require("colorscheme-manager").setup({
    colorscheme = "your-favorite-colorscheme-here",
    enable_custom_options = true,
    custom_options_function = ColorMyPencils,
    autocmd = true
})
```

## Inspirations
- [ThePrimeagen's](https://github.com/ThePrimeagen) `ColorMyPencils` function to apply changes to the UI.
