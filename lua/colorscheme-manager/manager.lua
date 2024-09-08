local ColorschemeManager = {}

local defaults = {
	colorscheme = "default",
	enable_custom_options = nil,
	custom_options_function = nil,
}

function ColorschemeManager:new(opts)
	opts = opts or defaults
	self.colorscheme = opts.colorscheme
	if type(opts.custom_options_function) == "function" then
		self.enable_custom_options = opts.enable_custom_options
		self.custom_options_function = opts.custom_options_function
	end
	return self
end

function ColorschemeManager:apply_changes()
	vim.cmd.colorscheme(self.colorscheme)

	if self.enable_custom_options == true then
		if self.custom_options_function == nil then
			error("No custom options function setted")
		end
		self.custom_options_function()
	end
end

function ColorschemeManager:toggle_custom_options()
	if self.enable_custom_options ~= nil then
		self.enable_custom_options = not self.enable_custom_options
	else
		self.enable_custom_options = true
	end
	print("ColorschemeManager opt set to:", self.enable_custom_options)
	self:apply_changes()
end

function ColorschemeManager:switch_colorscheme(colorscheme)
	if colorscheme == nil then
		error("No colorscheme passed to this function")
		return
	end
	self.colorscheme = colorscheme
	self:apply_changes()
end

function ColorschemeManager:set_custom_options_function(custom_options_function)
	if type(custom_options_function) ~= "function" then
		error("Not a valid function is set to Colorscheme Manager's custom_options")
	end
	self.custom_options_function = custom_options_function
	self.enable_custom_options = true
end

return {
	colorscheme_manager = ColorschemeManager,
	defaults = defaults,
}
