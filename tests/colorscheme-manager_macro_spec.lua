COUNT = 0

local target_colorscheme = "blue"
local default_colorscheme = "default"

local set_defaults = function()
    vim.cmd("colorscheme " .. default_colorscheme)
    COUNT = 0
end

local CustomFunction = function()
    COUNT = COUNT + 1
end

local colorscheme_manager = require("colorscheme-manager")
colorscheme_manager.setup({
    colorscheme = target_colorscheme,
    enable_custom_options = false,
    custom_options_function = CustomFunction,
    autocmd = true,
})

describe("ColorschemeManager setup", function()
    before_each(set_defaults)

    it("can change the colorscheme to something else", function()
        colorscheme_manager.switch_colorscheme(target_colorscheme)
        assert.are_equal(vim.g.colors_name, target_colorscheme)
    end)

    it("can define a disabled function", function()
        colorscheme_manager.switch_colorscheme(target_colorscheme)
        assert.is_equal(COUNT, 0)
    end)

    it("can turn on the custom function", function()
        colorscheme_manager.toggle_custom_options()
        assert.is_equal(COUNT, 1)
    end)
end)

describe("Autocmd", function()
    before_each(set_defaults)

    it("can create an autocmd for ColorScheme events", function()
        local colorscheme_manager_autocmds =
            vim.api.nvim_get_autocmds({ group = "ColorschemeManager", event = "ColorScheme" })
        assert.is_equal(#colorscheme_manager_autocmds, 1)
    end)

    it("can run the custom options function whenever changing the colorscheme", function()
        vim.cmd("colorscheme " .. default_colorscheme)
        assert.is_equal(COUNT, 1)
    end)
end)

vim.cmd("source plugin/colorscheme-manager.lua")
describe("User Commands", function()
    before_each(set_defaults)

    it("can change the colorscheme through user command", function()
        vim.cmd("ColorManagerChangeColor " .. target_colorscheme)
        assert.are_equal(vim.g.colors_name, target_colorscheme)
    end)

    it("can turn on custom options function throught user command", function()
        vim.cmd("ColorManagerToggleCustomOptions")
        assert.is_equal(COUNT, 0)
    end)
end)
