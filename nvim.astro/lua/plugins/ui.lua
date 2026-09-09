-- Surface-level UI plugins. These settings shape the screens you interact with most:
-- dashboard, picker, explorer, notifications, and command-discovery popups.

---@type LazySpec
return {
  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      local get_icon = require("astroui").get_icon

      opts.dashboard = require("astrocore").extend_tbl(opts.dashboard or {}, {
        preset = {
          header = table.concat({
            "NVIM WORKSPACE",
            "Clean tools. Fast feedback. Focused editing.",
          }, "\n"),
          keys = {
            { key = "f", action = "<Leader>ff", icon = get_icon("Search", 0, true), desc = "Find File" },
            { key = "r", action = "<Leader>fo", icon = get_icon("DefaultFile", 0, true), desc = "Recent Files" },
            { key = "g", action = "<Leader>fw", icon = get_icon("WordFile", 0, true), desc = "Search Text" },
            { key = "n", action = "<Leader>n", icon = get_icon("FileNew", 0, true), desc = "New File" },
            { key = "s", action = "<Leader>Sl", icon = get_icon("Refresh", 0, true), desc = "Restore Session" },
          },
        },
        sections = {
          { section = "header", padding = 4 },
          { section = "keys", gap = 1, padding = 2 },
          { section = "startup" },
        },
      })

      opts.notifier = require("astrocore").extend_tbl(opts.notifier or {}, {
        margin = { top = 1, right = 1, bottom = 1 },
        style = "compact",
        timeout = 3500,
      })

      opts.picker = require("astrocore").extend_tbl(opts.picker or {}, {
        enabled = false,
        ui_select = false,
        layout = {
          preset = "default",
        },
      })

      opts.input = require("astrocore").extend_tbl(opts.input or {}, {
        win = {
          border = "rounded",
        },
      })

      opts.indent = require("astrocore").extend_tbl(opts.indent or {}, {
        animate = { enabled = false },
        indent = { char = "▏" },
        scope = { char = "▏" },
      })
    end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = function(_, opts)
      return require("astrocore").extend_tbl(opts, {
        close_if_last_window = true,
        default_component_configs = {
          indent = {
            padding = 0,
          },
          name = {
            trailing_slash = false,
            use_git_status_colors = true,
          },
        },
        filesystem = {
          filtered_items = {
            hide_dotfiles = false,
            hide_gitignored = false,
            never_show = { ".DS_Store" },
          },
          follow_current_file = {
            enabled = true,
            leave_dirs_open = true,
          },
          group_empty_dirs = true,
          use_libuv_file_watcher = true,
        },
        popup_border_style = "rounded",
        source_selector = {
          content_layout = "center",
          separator = " ",
          show_separator_on_edge = false,
          winbar = true,
        },
        window = {
          mappings = {
            ["h"] = "parent_or_close",
            ["l"] = "child_or_open",
          },
          width = 34,
        },
      })
    end,
  },
  {
    "folke/which-key.nvim",
    opts = {
      delay = 350,
      preset = "modern",
      win = {
        border = "rounded",
      },
      layout = {
        spacing = 4,
      },
    },
  },
}
