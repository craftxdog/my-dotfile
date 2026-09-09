-- AstroUI centralizes theme, icons, highlights, statusline, tabline, and winbar.
-- Keep UI concerns here so new visual changes have one obvious home.

---@type LazySpec
return {
  {
    "AstroNvim/astrotheme",
    ---@type AstroThemeOpts
    opts = {
      palette = "astrodark",
      style = {
        transparent = true,
        float = false,
        neotree = false,
        border = true,
        title_invert = false,
      },
      palettes = {
        astrodark = {
          ui = {
            accent = "#7aa2f7",
            blue = "#7aa2f7",
            cyan = "#7dcfff",
            green = "#9ece6a",
            purple = "#bb9af7",
            red = "#f7768e",
            yellow = "#e0af68",
          },
        },
      },
    },
  },
  {
    "AstroNvim/astroui",
    ---@type AstroUIOpts
    opts = {
      colorscheme = "astrodark",
      folding = {
        enabled = function(bufnr) return require("astrocore.buffer").is_valid(bufnr) end,
        methods = { "lsp", "treesitter", "indent" },
      },
      highlights = {
        init = {
          CursorLine = { bg = "NONE" },
          EndOfBuffer = { bg = "NONE" },
          FloatBorder = { fg = "#3d59a1", bg = "NONE" },
          FoldColumn = { bg = "NONE" },
          LineNr = { bg = "NONE" },
          NeoTreeEndOfBuffer = { bg = "NONE" },
          NeoTreeNormal = { bg = "NONE" },
          NeoTreeNormalNC = { bg = "NONE" },
          NeoTreeTabActive = { bg = "NONE", bold = true },
          NeoTreeTabInactive = { bg = "NONE" },
          NeoTreeTabSeparatorActive = { bg = "NONE" },
          NeoTreeTabSeparatorInactive = { bg = "NONE" },
          NonText = { bg = "NONE" },
          Normal = { bg = "NONE" },
          NormalFloat = { bg = "NONE" },
          NormalNC = { bg = "NONE" },
          Pmenu = { bg = "NONE" },
          PmenuSel = { bg = "#283457", bold = true },
          Search = { bg = "#3d59a1", fg = "#c0caf5", bold = true },
          SignColumn = { bg = "NONE" },
          SnacksNormal = { bg = "NONE" },
          SnacksPicker = { bg = "NONE" },
          SnacksPickerBorder = { bg = "NONE" },
          SnacksPickerInput = { bg = "NONE" },
          SnacksPickerList = { bg = "NONE" },
          SnacksPickerPreview = { bg = "NONE" },
          SnacksWin = { bg = "NONE" },
          SnacksWinBar = { bg = "NONE" },
          SnacksWinBarNC = { bg = "NONE" },
          StatusLine = { bg = "NONE" },
          StatusLineNC = { bg = "NONE" },
          TabLine = { bg = "NONE" },
          TabLineFill = { bg = "NONE" },
          TabLineSel = { bg = "NONE", bold = true },
          TelescopeBorder = { bg = "NONE" },
          TelescopeNormal = { bg = "NONE" },
          WhichKeyFloat = { bg = "NONE" },
          Visual = { bg = "#283457" },
          WinBar = { bg = "NONE" },
          WinBarNC = { bg = "NONE" },
          WinSeparator = { fg = "#24283b" },
        },
      },
      status = {
        attributes = {
          git_branch = { bold = true },
          mode = { bold = true },
        },
        colors = {
          git_branch_fg = "#7dcfff",
          bg = "NONE",
          section_bg = "NONE",
          tabline_bg = "NONE",
          winbar_bg = "NONE",
          winbarnc_bg = "NONE",
        },
        icon_highlights = {
          breadcrumbs = true,
          file_icon = {
            tabline = function(self) return self.is_active or self.is_visible end,
            statusline = true,
          },
        },
        separators = {
          none = { "", "" },
          left = { "", " " },
          right = { " ", "" },
          center = { " ", " " },
          tab = { " ", " " },
          breadcrumbs = " / ",
          path = " / ",
        },
        winbar = {
          disabled = {
            buftype = { "nofile", "prompt", "terminal" },
            filetype = {
              "dashboard",
              "help",
              "lazy",
              "mason",
              "neo-tree",
              "snacks_dashboard",
              "toggleterm",
            },
          },
        },
      },
      icons = {
        LSPLoading1 = "⠋",
        LSPLoading2 = "⠙",
        LSPLoading3 = "⠹",
        LSPLoading4 = "⠸",
        LSPLoading5 = "⠼",
        LSPLoading6 = "⠴",
        LSPLoading7 = "⠦",
        LSPLoading8 = "⠧",
        LSPLoading9 = "⠇",
        LSPLoading10 = "⠏",
      },
      lazygit = {
        theme_path = vim.fs.normalize(vim.fn.stdpath "cache" .. "/lazygit-theme.yml"),
        theme = {
          activeBorderColor = { fg = "FloatBorder", bold = true },
          inactiveBorderColor = { fg = "Comment" },
          optionsTextColor = { fg = "Function" },
          selectedLineBgColor = { bg = "Visual" },
          unstagedChangesColor = { fg = "DiagnosticError" },
        },
      },
    },
  },
}
