-- Telescope is the primary fuzzy finder.
-- It is configured separately from Snacks so search/navigation stays easy to audit.

---@type LazySpec
return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function() return vim.fn.executable "make" == 1 end,
      },
      "nvim-telescope/telescope-ui-select.nvim",
    },
    opts = function()
      local actions = require "telescope.actions"
      return {
        defaults = {
          border = true,
          borderchars = {
            prompt = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
            results = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
            preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
          },
          color_devicons = true,
          file_ignore_patterns = {
            "%.git/",
            "node_modules/",
            "dist/",
            "build/",
            "%.next/",
          },
          initial_mode = "insert",
          layout_config = {
            horizontal = {
              height = 0.86,
              preview_cutoff = 100,
              preview_width = 0.52,
              prompt_position = "top",
              width = 0.9,
            },
            vertical = {
              height = 0.9,
              preview_cutoff = 40,
              prompt_position = "top",
              width = 0.9,
            },
          },
          layout_strategy = "horizontal",
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
              ["<Esc>"] = actions.close,
            },
            n = {
              ["q"] = actions.close,
            },
          },
          path_display = { "smart" },
          prompt_prefix = "  ",
          results_title = false,
          selection_caret = "  ",
          sorting_strategy = "ascending",
          winblend = 0,
        },
        extensions = {
          fzf = {
            case_mode = "smart_case",
            fuzzy = true,
            override_file_sorter = true,
            override_generic_sorter = true,
          },
          ["ui-select"] = {
            require("telescope.themes").get_dropdown {
              border = true,
              previewer = false,
              winblend = 0,
            },
          },
        },
        pickers = {
          buffers = {
            ignore_current_buffer = true,
            sort_mru = true,
          },
          find_files = {
            find_command = {
              "fd",
              "--type",
              "f",
              "--strip-cwd-prefix",
              "--hidden",
              "--exclude",
              ".git",
            },
          },
          live_grep = {
            additional_args = function() return { "--hidden", "--glob", "!**/.git/*" } end,
          },
        },
      }
    end,
    config = function(_, opts)
      local telescope = require "telescope"
      telescope.setup(opts)
      pcall(telescope.load_extension, "fzf")
      pcall(telescope.load_extension, "ui-select")
    end,
  },
}
