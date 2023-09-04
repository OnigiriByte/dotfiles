return {
        'echasnovski/mini.files',



        version = false,


        opts = {
                windows = {
                        preview = true,
                        width_focus = 30,
                        width_preview = 30,
                },
                options = {
                        use_as_default_explorer = true,
                }
        },

        lazy = false,


        keys = {
                {
                        "<Leader>e",
                        function()
                                print("Minus command ran!")
                                require('mini.files').open(vim.loop.cwd(), true)
                        end,
                        desc = "Open mini.files at project root"
                },
                {
                        "-",
                        function()
                                require('mini.files').open(vim.api.nvim_buf_get_name(0), true)
                        end,
                        desc = "Open mini.files at current buf dir."
                },
        },
        config = function(_, opts)
                local mini_files = require('mini.files')
                mini_files.setup(opts)

                vim.api.nvim_create_autocmd("User", {
                        pattern = "MiniFilesBufferCreate",
                        callback = function(args)
                                local buf_id = args.data.buf_id
                                vim.keymap.set("n", "-", mini_files.go_out, { buffer = buf_id })
                        end
                })
        end,
}
