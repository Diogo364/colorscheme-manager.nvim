---@class ColorschemeManager
---This is the motor behind the ColorschemeManager. It does all the implementation logic for apply the changes
---@field private colorscheme string Name of the colorscheme to be set
---@field private enable_custom_options boolean? Boolean flag if the custom_options_function should run
---@field private custom_options_function function? Function that sets, or tweaks custom changes whenever colorscheme changes
local ColorschemeManager = {
    colorscheme = "default",
    enable_custom_options = nil,
    custom_options_function = nil,
}

---Create new ColorschemeManager
---@param opts ColorschemeManager?
---@return ColorschemeManager
function ColorschemeManager:new(opts)
    local manager = opts or {}
    setmetatable(manager, self)
    self.__index = self

    -- self.colorscheme = opts.colorscheme
    if type(manager.custom_options_function) == "function" then
        self.enable_custom_options = manager.enable_custom_options
        self.custom_options_function = manager.custom_options_function
    end
    return manager
end

---Use ColorschemeManager to update colorscheme and run the custom_options_function if enabled
function ColorschemeManager:apply_changes()
    vim.cmd.colorscheme(self.colorscheme)

    if self.enable_custom_options == true then
        if self.custom_options_function == nil then
            error("No custom options function setted")
        end
        self.custom_options_function()
    end
end

---Function to toggle the enable_custom_options flag
function ColorschemeManager:toggle_custom_options()
    if self.enable_custom_options ~= nil then
        self.enable_custom_options = not self.enable_custom_options
    else
        self.enable_custom_options = true
    end
    print("ColorschemeManager opt set to:", self.enable_custom_options)
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

return ColorschemeManager
