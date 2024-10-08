---@type ColorschemeManager
local colorscheme_manager = require("colorscheme-manager.manager")

local M = {}

---@param opts ColorschemeManager?
function M.setup(opts)
    opts = opts or {}
    colorscheme_manager = colorscheme_manager:new(opts)
    colorscheme_manager:apply_changes()
end

---Function to toggle the enable_custom_options flag
function M.toggle_custom_options()
    colorscheme_manager:toggle_custom_options()
end

---@param colorscheme string Setter for changing the colorscheme name and start update the ui settings
function M.switch_colorscheme(colorscheme)
    colorscheme_manager:switch_colorscheme(colorscheme)
end

---Setter for the custom_options_function parameter. This function runs each time the colorscheme changes
---@param custom_options_function function: Function to run each time Colorscheme changes
function M.set_custom_options(custom_options_function)
    colorscheme_manager:set_custom_options_function(custom_options_function)
end

return M
