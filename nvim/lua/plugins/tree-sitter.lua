return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        -- event = { "BufReadPost", "BufNewFile" },
        dependencies = {
            -- treesitter powered textobjects
            -- "nvim-treesitter/nvim-treesitter-textobjects",
            -- better comment support for jsx/tsx
            "JoosepAlviste/nvim-ts-context-commentstring",
        },

        opts = {
            ensure_installed = {
                'astro', 'css', 'graphql', 'html', 'javascript',
                'lua', 'nix', 'php', 'python', 'scss', 'svelte', 'tsx', 'twig',
                'typescript', 'vim', 'vue', 'svelte'
            },

            context_commentstring = {
                enable = true,
                enable_autocmd = false
            },
            highlight = {
                enable = true
            }
        },

        main = "nvim-treesitter.configs",
    },
}
