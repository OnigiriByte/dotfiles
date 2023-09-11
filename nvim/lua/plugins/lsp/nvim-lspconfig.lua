-- LSP Configuration & Plugins
-- @class LazyPluginSpec


print("running lsp/nvim-lspconfig")
return {
    "neovim/nvim-lspconfig",
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
        "mason",
        -- { "hrsh7th/cmp-nvim-lsp" },
        -- { "antosha417/nvim-lsp-file-operations", config = true },
        -- Useful for status/activity updates
        { 'j-hui/fidget.nvim', tag = 'legacy', opts = {}, event = "LspAttach" },
        -- additional lua configuration
        'folke/neodev.nvim',
    },
    -- end of dependencies

    config = function(_, optv)
        -- print("NVIM LSPCONFIG LOADING...")
        local lspconfig = require('lspconfig')
        local cmp_nvim_lsp = require('cmp_nvim_lsp')
        --
        -- This function gets run when an LSP connects to a particular buffer.
        local on_attach = function(_, bufnr)
            -- We create a function that lets us more easily define mappings
            -- specific for LSP related itmes. It sets the mode, buffer and
            -- description for us each time.
            local nmap = function(keys, func, desc)
                if desc then
                    desc = '[LSP] ' .. desc
                end

                vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
            end


            -- Renames all references to the symbol under the cursor
            nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
            -- Selects a code action available at the current cursor position
            nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
            -- Jump to the definition
            nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
            -- Jump to declaration
            nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
            nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
            nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')


            nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
            nmap('<leader>wl', function()
                print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end, '[W]orkspace [L]ist Folders')



            -- Create a command `:Format` local to the LSP buffer
            vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
                vim.lsp.buf.format()
            end, { desc = 'Format current buffer with LSP' })



            nmap('K', vim.lsp.buf.hover, "Hover")
            --Displays a function's signature information help
            nmap('<C-k>', vim.lsp.buf.signature_help, "Get help (signatureu)")



            -- Lists all the implementations for the symbol under the cursor
            -- nmap('gi', vim.lsp.buf.implementation,  "Getall implementations")

            -- Jumps to the definition of the type symbol
            -- nmap('go', vim.lsp.buf.type_definition,  "Goto objects/symbol")


            -- Lists all the references
            -- nmap('gr', vim.lsp.buf.references, "Get references")
            -- local ts_builtin = require('telescope.builtin')
            -- nmap('gr', ts_builtin.lsp_references, "[G]et [R]eferences")
            -- nmap('<leader>s', ts_builtin.lsp_document_symbols, "[G]et [S]ymbols (buffer)")
            -- nmap('<leader>S', ts_builtin.lsp_dynamic_workspace_symbols, "[G]et [S]ymbols (workspace)")

            -- Shows diagnostics in a floating window
            nmap('<Leader>gl', '<cmd lua vim.diagnostic.open_float()<cr>', "Get Linediagnostics")
        end

        --NOTE: Customizing UI of diagnostics
        vim.diagnostic.config({
            virtual_text = true,
            signs = true,
            underline = true,
            update_in_insert = false,
            severity_sort = false,
        })

        local signs = { Error = "", Warn = "", Hint = "", Info = " " }
        for type, icon in pairs(signs) do
            local hl = "DiagnosticSign" .. type
            vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
        end


        -- Enable the following language servers
        local servers = {
            lua_ls = {
                Lua = {
                    workspace = { checkThirdParty = false },
                    telemetry = { enable = false },
                }
            },
            pyright = {},
            ruff_lsp = {},
        }

        --
        -- Setup neovim lua configuration
        require('neodev').setup()

        --  nvim-cmp supports additional completion, so broadcast that to servers
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
        capabilities.textDocument.completion.completionItem.snippetSupport = true


        -- NOTE: UFO Folding setup using nvim lsp as LSP client
        -- See: https://github.com/kevinhwang91/nvim-ufo#minimal-configuration
        capabilities.textDocument.foldingRange = {
            dynamicRegistration = false,
            lineFoldingOnly = true
        }




        --Ensure the servers above are installed and setup
        local mason_lspconfig = require 'mason-lspconfig'

        mason_lspconfig.setup_handlers({
            -- NOTE: The first entry (without a key) will be the default handler
            -- and will be called for each installed server that doesn't have
            -- a dedicated handler.
            function(server_name)
                lspconfig[server_name].setup({
                    capabilities = capabilities,
                    on_attach = on_attach,
                    settings = servers[server_name],
                    filetypes = (servers[server_name] or {}).filetypes,
                })
            end,

            ['tsserver'] = function(server_name)
                require('typescript').setup({
                    capabilities = capabilities,
                    on_attach = on_attach,
                    settings = servers[server_name],
                    filetypes = (servers[server_name] or {}).filetypes,
                })
            end

        })
    end
}
