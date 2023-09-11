return {
    'numToStr/Comment.nvim',
    dependencies = {'nvim-treesitter'},
    -- keys = {
    --     "gcc",
    --     "gbc",
    --     { "gc", mode = "v" },
    --     { "gbc", mode = "v" },
    -- },
    opts = function()
        return {
            pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
        }
    end,
    lazy = false,
}
