-- @class LazyPluginSpec
local M =  {
    "HampusHauffman/block.nvim",
    --@type fun(self:LazyPlugin, keys:string[]):(string | LazyKeys)[]
    keys =  {
        {"<leader>tb", ":Block<CR>", desc="Toggle Block view"}
    },
    opts = {}

}

return M
