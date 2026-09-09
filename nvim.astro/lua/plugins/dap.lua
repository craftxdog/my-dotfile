-- DAP setup for the debuggers installed through Mason.
-- `codelldb` is auto-configured by mason-nvim-dap; JavaScript/TypeScript
-- gets explicit launch configurations because js-debug-adapter exposes several modes.

---@type LazySpec
return {
  {
    "jay-babu/mason-nvim-dap.nvim",
    opts = {
      ensure_installed = {
        "js",
        "codelldb",
      },
      handlers = {
        function(config) require("mason-nvim-dap").default_setup(config) end,
      },
    },
  },
  {
    "mfussenegger/nvim-dap",
    opts = function()
      local dap = require "dap"
      local js_debug_path = vim.fn.stdpath "data" .. "/mason/packages/js-debug-adapter"
      local js_debug_bin = js_debug_path .. "/js-debug/src/dapDebugServer.js"

      dap.adapters["pwa-node"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = "node",
          args = { js_debug_bin, "${port}" },
        },
      }

      dap.adapters["pwa-chrome"] = dap.adapters["pwa-node"]

      local js_based_filetypes = {
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
      }

      local js_configurations = {
        {
          type = "pwa-node",
          request = "launch",
          name = "Node: launch current file",
          program = "${file}",
          cwd = "${workspaceFolder}",
          console = "integratedTerminal",
          sourceMaps = true,
        },
        {
          type = "pwa-node",
          request = "attach",
          name = "Node: attach process",
          processId = require("dap.utils").pick_process,
          cwd = "${workspaceFolder}",
          sourceMaps = true,
        },
        {
          type = "pwa-chrome",
          request = "launch",
          name = "React: launch Chrome localhost:3000",
          url = "http://localhost:3000",
          webRoot = "${workspaceFolder}",
          sourceMaps = true,
        },
      }

      for _, filetype in ipairs(js_based_filetypes) do
        dap.configurations[filetype] = js_configurations
      end
    end,
  },
}
