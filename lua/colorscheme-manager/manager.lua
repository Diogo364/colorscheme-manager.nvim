local ColorschemeManagerGroup = require("colorscheme-manager.autocmd")

---@class ColorschemeManager
---This is the motor behind the ColorschemeManager. It does all the implementation logic for apply the changes
---@field private colorscheme string Name of the colorscheme to be set
---@field private enable_custom_options boolean? Boolean flag if the custom_options_function should run
---@field private custom_options_function function? Function that sets, or tweaks custom changes whenever colorscheme changes
local ColorschemeManager = {
    colorscheme = "default",
    enable_custom_options = nil,
    custom_options_function = nil,
    autocmd = true,
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
    vim.cmd.colorscheme(self.colorscheme)
    if not self.autocmd then
        self:apply_custom_options_function()
    end
end

---Passive function that updates the ColorschemeManager with the current colorscheme and apply the custom_options_function if enabled
function ColorschemeManager:sync_changes()
    self.colorscheme = vim.g.colors_name
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
    self.colorscheme = colorscheme
    self:apply_changes()
end

---Setter for the custom_options_function parameter. This function runs each time the colorscheme changes
---@param custom_options_function function: Function to run each time Colorscheme changes
function ColorschemeManager:set_custom_options_function(custom_options_function)
    if type(custom_options_function) ~= "function" then
        error("Not a valid function is set to Colorscheme Manager's custom_options")
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

return ColorschemeManager
