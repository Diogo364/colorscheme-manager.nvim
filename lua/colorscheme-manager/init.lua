local _config = require("colorscheme-manager.config")
local M = {}

M.colorscheme_manager = {}

function M.setup(opts)
    opts = opts or {}
    M.colorscheme_manager = _config.extend_options(opts)
    M.colorscheme_manager:apply_changes()
end

M.toggle_custom_options = function()
    M.colorscheme_manager:toggle_custom_options()
end

M.switch_colorscheme = function(colorscheme)
    M.colorscheme_manager:switch_colorscheme(colorscheme)
end

M.set_custom_options = function(custom_options_function)
    M.colorscheme_manager:set_custom_options_function(custom_options_function)
end

return M
