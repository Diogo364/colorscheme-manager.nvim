# colorscheme-manager.nvim

Custom plugin to manager neovim visuals.

## Why use it?
This is a single plugin in which you could not only load your colorschemes, but also pass to it your
custom and favorite changes so it is able to toggle them on and off. 

This allows an custom experience for testing different colorschemes and how your functions affect
them.

### How it works?
`colorscheme-manager.nvim` is built to work on a couple of simple parameters:
- **colorscheme:** This parameter is the string that represents the colorscheme you would like to
activate in your environment. You should pass the exact value you would pass to the `vim.cmd.colorscheme` function.
- **custom_options_function:** This should be a function that would set all the custom ui changes
you prefer.
- **enable_custom_options [Optional]:** A boolean flag that indicates if the plugin
should run the `custom_options_function`. If no value is provided it is automatically set to true if
you pass the `custom_options_function` setup function.

## Getting started
### Lazy
```lua
{
    "Diogo364/colorscheme-manager.nvim"
}
```

## Usage and Commands
As mentioned before, this should be helpful to switch your colorscheme keeping your ui setup.
Therefore, we provide a set of commands to allow you to see how your setup is affected by your
choices:
- `:ColorManagerToggleCustomOptions`: Enable/Disable your custom options function.
- `:ColorManagerChangeColor <your-favorite-colorscheme-here>`: Changes your colorscheme and apply
your custom options function, if enabled.


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
    custom_options_function = ColorMyPencils
})
```


## Inspirations
- [ThePrimeagen's](https://github.com/ThePrimeagen) `ColorMyPencils` function to apply changes to
the ui.
