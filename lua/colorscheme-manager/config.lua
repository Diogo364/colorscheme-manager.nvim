local defaults = require("colorscheme-manager.manager").defaults
local colorscheme_manager = require("colorscheme-manager.manager").colorscheme_manager

local config = {}

config.colorscheme_manager = {}

config.fill_with_defaults = function(opts)
    opts = opts or {}
    for attr, default_value in pairs(defaults) do
        opts[attr] = opts[attr] or default_value
    end
    return opts
end

config.extend_options = function(opts)
    opts = config.fill_with_defaults(opts)
    return colorscheme_manager:new(opts)
end

return config
