return {
    'echasnovski/mini.ai',
    version = false,
    opts = function()
        local ai = require('mini.ai')
        local spec_treesitter = ai.gen_spec.treesitter
        return {
            custom_textobjects = {
                -- This will override default "function call" textobject
                f = spec_treesitter({ a = '@function.outer', i = '@function.inner' }),
                c = spec_treesitter({ a = '@class.outer', i = '@class.inner' }),
    i = spec_treesitter({ a = '@conditional.outer', i = '@conditional.inner' }),
            }
        }
    end
}
