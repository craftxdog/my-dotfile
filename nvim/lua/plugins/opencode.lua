return {
  {
    "nickjvandyke/opencode.nvim",
    version = "*",

    config = function()
      local opencode_cmd = "opencode --port"

      local terminal_opts = {
        win = {
          position = "right",
          enter = false,
        },
      }

      ---@type opencode.Opts
      vim.g.opencode_opts = {
        server = {
          start = function()
            require("snacks.terminal").open(opencode_cmd, terminal_opts)
          end,
        },
      }

      local opencode = require("opencode")

      vim.keymap.set({ "n", "x" }, "<leader>oa", function()
        opencode.ask("@this: ")
      end, {
        desc = "Ask OpenCode",
      })

      vim.keymap.set({ "n", "x" }, "<leader>os", function()
        opencode.select()
      end, {
        desc = "OpenCode Select",
      })

      vim.keymap.set({ "n", "x" }, "<leader>o+", function()
        opencode.prompt("@this ")
      end, {
        desc = "Add Context to OpenCode",
      })

      vim.keymap.set({ "n", "x" }, "<leader>oe", function()
        opencode.prompt("Explain @this and its context")
      end, {
        desc = "Explain with OpenCode",
      })

      vim.keymap.set("n", "<leader>on", function()
        opencode.command("session.new")
      end, {
        desc = "New OpenCode Session",
      })

      vim.keymap.set("n", "<leader>ot", function()
        require("snacks.terminal").toggle(opencode_cmd, terminal_opts)
      end, {
        desc = "Toggle OpenCode",
      })
    end,
  },
}
