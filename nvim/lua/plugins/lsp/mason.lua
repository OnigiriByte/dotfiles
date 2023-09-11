return {
    'williamboman/mason-lspconfig.nvim',
    name = "mason",
    dependencies = { "williamboman/mason.nvim", config = true },
    opts = {
        ensure_installed = {
            "lua_ls",
            "bashls",
            "cssls",
            -- "unocss",
            "dockerls",
            "docker_compose_language_service",
            "eslint",
            "emmet_ls",
            "html",
            "jsonls",
            "tsserver",
            -- 'vtsls',
            "jqls",
            "marksman",
            "powershell_es",
            "sqlls",
            "yamlls",
            "pyright",
            "tailwindcss"

        },
        automatic_installation = true,
    },
}
