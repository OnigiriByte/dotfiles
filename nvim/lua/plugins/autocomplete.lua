-- Autocompletion
return {
    'hrsh7th/nvim-cmp',
    event = { 'BufReadPre', 'BufNewFile' },
    --@type string | string[] | LazyPluginSpec[]
    dependencies = {
        -- Snippet Engine & its associated nvim-cmp source
        'rafamadriz/friendly-snippets',
        {
            'L3MON4D3/LuaSnip',
            version = "2.*",
            run = "make install_jsregexp",
            config = function()
                require('luasnip.loaders.from_vscode').lazy_load()
            end
        },
        'saadparwaiz1/cmp_luasnip',

        -- Adds LSP completion capabilities
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-buffer',
        'FelipeLema/cmp-async-path',
        'hrsh7th/cmp-cmdline',

        -- Adds a number of user-friendly snippets

        -- Add symbols
        'onsails/lspkind.nvim'
    },
    --@type cmp.ConfigSchema
    opts = function(LazyPlugin, opts)
        local cmp = require('cmp');
        local luasnip = require('luasnip');
        return {
            completion = {
                -- completeopt = 'noselect',
            },
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end
            },

            mapping = cmp.mapping.preset.insert {
                ['<C-e>'] = cmp.mapping.abort(),
                ['<C-n>'] = cmp.mapping.select_next_item(),
                ['<C-p>'] = cmp.mapping.select_prev_item(),
                ['<C-u>'] = cmp.mapping.scroll_docs(-4),
                ['<C-d>'] = cmp.mapping.scroll_docs(4),
                ['<C-Space>'] = cmp.mapping.complete(),
                ['<CR>'] = cmp.mapping.confirm {
                    behavior = cmp.ConfirmBehavior.Replace,
                    select = true,
                },
                ['<Tab>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif luasnip.expand_or_locally_jumpable() then
                        luasnip.expand_or_jump()
                    else
                        fallback()
                    end
                end, { 'i', 's' }),
                ['<S-Tab>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif luasnip.locally_jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { 'i', 's' }),
            },

            formatting = {
                format = require('lspkind').cmp_format({
                    mode = 'symbol_text', -- show symbol and text
                    menu = ({
                        buffer = '[Buffer]',
                        nvim_lsp = '[LSP]',
                        luasnip = '[LuaSnip]',
                        nvim_lua = '[Lua]',
                        async_path = "[Path]"
                    }),
                    maxwidth = 50,         -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
                    ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)

                    -- The function below will be called before any actual modifications from lspkind
                    -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
                    -- before = function(entry, vim_item)
                    --     return vim_item
                    -- end
                    before = require('tailwindcss-colorizer-cmp').formatter
                })
            },

            -- NOTE: Completion sources:
            -- WARN: The order matters. Completions suggestions will be 
            -- suggested in the following order:
            sources = cmp.config.sources({
                { name = 'nvim_lsp',  trigger_characters = { '-' } },
                { name = "nvim_lua" },
                { name = 'luasnip' },
                { name = "async_path" },

            }, {
            -- NOTE: Buffer completions only if no LSP completions
                { name = 'buffer' }


            }),

        }
    end
}
