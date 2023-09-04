-- Autocompletion
return {
        'hrsh7th/nvim-cmp',
        dependencies = {
                -- Snippet Engine & its associated nvim-cmp source
                'L3MON4D3/LuaSnip',
                'saadparwaiz1/cmp_luasnip',

                -- Adds LSP completion capabilities
                'hrsh7th/cmp-nvim-lsp',
                'hrsh7th/cmp-buffer',
                'FelipeLema/cmp-async-path',
                'hrsh7th/cmp-cmdline',

                -- Adds a number of user-friendly snippets
                'rafamadriz/friendly-snippets',

                -- Add symbols
                'onsails/lspkind.nvim'
        },
        config = function()
                local cmp = require('cmp')
                local luasnip = require('luasnip')
                local lspkind = require('lspkind')

                require('luasnip.loaders.from_vscode').lazy_load()
                luasnip.config.setup({})


                cmp.setup({
                        snippet = {
                                expand = function(args)
                                        luasnip.lsp_expand(args.body)
                                end,
                        },
                        formatting = {
                                format = lspkind.cmp_format({
                                        mode = 'symbol_text',       -- show symbol and text
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
                                        before = function(entry, vim_item)
                                                return vim_item
                                        end
                                })
                        },
                        completion = {
                                autocomplete = false
                        },
                        window = {
                                -- completion = cmp.config.window.bordered(),
                                -- documentation = cmp.config.window.bordered(),
                        },
                        mapping = cmp.mapping.preset.insert {
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


                        sources = cmp.config.sources({

                                { name = 'nvim_lsp',  trigger_characters = { '-' } },
                                { name = 'luasnip' },
                                { name = "nvim_lua" },
                                { name = "async_path" },

                        }, {
                                { name = 'buffer' }


                        }),
                })
        end
}
