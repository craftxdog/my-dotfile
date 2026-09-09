-- Mason installs external editor tools: LSP servers, formatters, linters, and DAP adapters.
-- Package names must match `:Mason` / https://mason-registry.dev/registry/list.

---@type LazySpec
return {
  -- use mason-tool-installer for automatically installing Mason packages
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    -- overrides `require("mason-tool-installer").setup(...)`
    opts = {
      -- Make sure to use the names found in `:Mason`
      ensure_installed = {
        -- LSP servers
        "lua-language-server",
        "typescript-language-server", -- nvim-lspconfig server name: ts_ls
        "eslint-lsp", -- nvim-lspconfig server name: eslint
        "html-lsp", -- nvim-lspconfig server name: html
        "css-lsp", -- nvim-lspconfig server name: cssls
        "clangd",
        "sqlls",

        -- Formatters
        "stylua",
        "prettier",
        "clang-format",
        "sql-formatter",

        -- Debug adapters
        "js-debug-adapter", -- JavaScript, TypeScript, Node, React
        "codelldb", -- C/C++

        -- Other tooling used by nvim-treesitter
        "tree-sitter-cli",
      },
    },
  },
}
