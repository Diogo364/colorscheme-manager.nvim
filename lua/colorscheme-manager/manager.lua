local ColorschemeManagerGroup = require("colorscheme-manager.autocmd")
local CacheManager = require("colorscheme-manager.cache_manager")

---@class ColorschemeManager
---This is the motor behind the ColorschemeManager. It does all the implementation logic for apply the changes
---@field private colorscheme string Name of the colorscheme to be set
---@field private enable_custom_options boolean? Boolean flag if the custom_options_function should run
---@field private custom_options_function function? Function that sets, or tweaks custom changes whenever
---colorscheme changes
local ColorschemeManager = {
    colorscheme = "default",
    enable_custom_options = nil,
    custom_options_function = nil,
    autocmd = true,
    cache_dir = nil,
}

---Create new ColorschemeManager
---@param opts ColorschemeManager?
---@return ColorschemeManager
function ColorschemeManager:new(opts)
    local manager = opts or {}
    setmetatable(manager, self)
    self.__index = self

    if type(manager.custom_options_function) ~= "function" then
        manager.enable_custom_options = nil
        manager.custom_options_function = nil
    end

    local cache_params = {}
    if self.cache_dir then
        cache_params.data_path = self.cache_dir
    end
    self.cache_manager = CacheManager:new(cache_params)

    manager:_set_autocmd()

    return manager
end

---Encapsulation for the custom_options_function
function ColorschemeManager:apply_custom_options_function()
    if self.enable_custom_options == true then
        if self.custom_options_function == nil then
            error("No custom options function setted")
        end
        self.custom_options_function()
    end
end

---Use ColorschemeManager to update colorscheme and run the custom_options_function if enabled
function ColorschemeManager:apply_changes()
    local colorscheme = self:_load_cached() or self.colorscheme
    vim.cmd.colorscheme(colorscheme)
    if not self.autocmd then
        self:apply_custom_options_function()
    end
end

---Passive function that updates the ColorschemeManager with the current colorscheme and apply the
---custom_options_function if enabled
function ColorschemeManager:sync_changes()
    self.colorscheme = vim.g.colors_name
    self:_save_cache(self.colorscheme)
    self:apply_custom_options_function()
end

---Function to toggle the enable_custom_options flag
function ColorschemeManager:toggle_custom_options()
    if self.enable_custom_options ~= nil then
        self.enable_custom_options = not self.enable_custom_options
    else
        self.enable_custom_options = true
    end
    self:apply_changes()
end

---@param colorscheme string Setter for changing the colorscheme name and start update the ui settings
function ColorschemeManager:switch_colorscheme(colorscheme)
    if colorscheme == nil then
        error("No colorscheme passed to this function")
    end
    self:_save_cache(colorscheme)
    self:apply_changes()
end

---Setter for the custom_options_function parameter. This function runs each time the colorscheme changes
---@param custom_options_function function: Function to run each time Colorscheme changes
function ColorschemeManager:set_custom_options_function(custom_options_function)
    if type(custom_options_function) ~= "function" then
        error(
            "Not a valid function is set to Colorscheme Manager's custom_options"
        )
    end
    self.custom_options_function = custom_options_function
    self.enable_custom_options = true
end

---Binds the sync_changes method to the ColorScheme autocmd
function ColorschemeManager:_set_autocmd()
    vim.api.nvim_create_autocmd({ "ColorScheme" }, {
        group = ColorschemeManagerGroup,
        pattern = "*",
        callback = function()
            self:sync_changes()
        end,
        desc = "Run custom_options_function for each change in colorscheme",
    })
end

function ColorschemeManager:_load_cached()
    return self.cache_manager:load()
end

function ColorschemeManager:_save_cache(colorscheme)
    self.cache_manager:cache(colorscheme)
end

function ColorschemeManager:_clear_cache()
    self.cache_manager:clear()
    self.cache_manager:ensure_data_path()
end

return ColorschemeManager
