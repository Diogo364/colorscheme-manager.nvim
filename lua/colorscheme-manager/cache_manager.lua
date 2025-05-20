local Path = require("plenary.path")

---@class CacheManager
---Caches colorscheme option into file
---@field private data_path string Colorscheme-Manager cache dir
---@field private filename string Colorscheme-Manager cache file
---@field private fullpath Path Path to Colorscheme-Manager cache file
local CacheManager = {
    data_path = string.format("%s/colorscheme-manager", vim.fn.stdpath("data")),
    filename = "curr_colorscheme",
}

---Create new CacheManager
---@param opts CacheManager?
---@return CacheManager
function CacheManager:new(opts)
    local cache = opts or {}
    setmetatable(cache, self)
    self.__index = self

    cache.fullpath = Path:new(cache.data_path, cache.filename)
    cache:ensure_data_path()

    return cache
end

function CacheManager:ensure_data_path()
    if not self.fullpath:exists() then
        self.fullpath:parent():mkdir({ exists_ok = true })
        vim.fn.system({
            "touch",
            self.fullpath:absolute(),
        })
    end
end

function CacheManager:cache(data)
    local path = self.fullpath
    path:write(data, "w")
end

function CacheManager:load()
    local path = self.fullpath
    local data = path:read() or ""
    if string.len(data) == 0 then
        return nil
    end
    return data
end

function CacheManager:clear()
    local path = self.fullpath
    vim.system({ "rm", "-r", path:absolute() })
end

return CacheManager
