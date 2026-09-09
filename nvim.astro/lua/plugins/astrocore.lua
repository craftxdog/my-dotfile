-- AstroCore owns editor-wide behavior: options, diagnostics, signs, autocommands, and mappings.
-- Keep this focused on how Neovim feels while editing, not on individual language tools.

---@type LazySpec
local function balance_splits() vim.cmd.wincmd "=" end

local function nav_tabpage(direction)
  for _ = 1, vim.v.count1 do
    if direction > 0 then
      vim.cmd.tabnext()
    else
      vim.cmd.tabprevious()
    end
  end
end

local function open_clean_tab(path)
  path = path and vim.trim(path) or ""

  if path == "" then
    vim.cmd.tabnew()
  else
    vim.cmd.tabedit(vim.fn.fnameescape(vim.fn.expand(path)))
  end

  vim.cmd.only()
end

local function new_buffer_or_file()
  vim.ui.input(
    { prompt = "New tab file path (empty for blank): ", completion = "file" },
    function(path) open_clean_tab(path) end
  )
end

return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    features = {
      large_buf = { size = 1024 * 512, lines = 20000 },
      autopairs = true,
      cmp = true,
      diagnostics = { virtual_text = true, virtual_lines = false },
      highlighturl = true,
      notifications = true,
    },
    diagnostics = {
      virtual_text = {
        spacing = 4,
        source = "if_many",
        prefix = "●",
      },
      float = {
        border = "rounded",
        source = "if_many",
      },
      severity_sort = true,
      underline = true,
      update_in_insert = false,
    },
    options = {
      opt = {
        breakindent = true,
        cmdheight = 1,
        colorcolumn = "100",
        cursorline = true,
        expandtab = true,
        fillchars = {
          diff = "╱",
          eob = " ",
          fold = " ",
          foldclose = "",
          foldopen = "",
          foldsep = " ",
        },
        foldcolumn = "1",
        laststatus = 3,
        linebreak = true,
        list = true,
        listchars = {
          extends = "›",
          nbsp = "␣",
          precedes = "‹",
          tab = "  ",
          trail = "·",
        },
        number = true,
        pumblend = 8,
        pumheight = 12,
        relativenumber = true,
        scrolloff = 8,
        shiftwidth = 2,
        showmode = false,
        showtabline = 2,
        sidescrolloff = 8,
        signcolumn = "yes",
        smartindent = true,
        smoothscroll = true,
        splitbelow = true,
        splitkeep = "screen",
        splitright = true,
        tabstop = 2,
        termguicolors = true,
        timeoutlen = 400,
        undofile = true,
        winblend = 0,
        wrap = false,
      },
      g = {
        autoformat_enabled = true,
        autopairs_enabled = true,
        cmp_enabled = true,
        codelens_enabled = true,
        diagnostics_enabled = true,
        highlighturl_enabled = true,
        inlay_hints_enabled = false,
        lsp_handlers_enabled = true,
        semantic_tokens_enabled = true,
        status_diagnostics_enabled = true,
      },
    },
    mappings = {
      n = {
        ["H"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },
        ["L"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        ["<C-h>"] = { function() nav_tabpage(-1) end, desc = "Previous workspace tab" },
        ["<C-l>"] = { function() nav_tabpage(1) end, desc = "Next workspace tab" },
        ["<BS>"] = { function() nav_tabpage(-1) end, desc = "Previous workspace tab" },
        ["]b"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        ["[b"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },
        ["]t"] = { function() nav_tabpage(1) end, desc = "Next workspace tab" },
        ["[t"] = { function() nav_tabpage(-1) end, desc = "Previous workspace tab" },
        ["et"] = { new_buffer_or_file, desc = "New tab buffer or file" },
        ["<Leader>f"] = { desc = "Find" },
        ["<Leader>fb"] = { "<Cmd>Telescope buffers<CR>", desc = "Find buffers" },
        ["<Leader>fc"] = { "<Cmd>Telescope commands<CR>", desc = "Find commands" },
        ["<Leader>fd"] = { "<Cmd>Telescope diagnostics<CR>", desc = "Find diagnostics" },
        ["<Leader>ff"] = { "<Cmd>Telescope find_files<CR>", desc = "Find files" },
        ["<Leader>fg"] = { "<Cmd>Telescope git_files<CR>", desc = "Find git files" },
        ["<Leader>fh"] = { "<Cmd>Telescope help_tags<CR>", desc = "Find help" },
        ["<Leader>fk"] = { "<Cmd>Telescope keymaps<CR>", desc = "Find keymaps" },
        ["<Leader>fo"] = { "<Cmd>Telescope oldfiles<CR>", desc = "Find recent files" },
        ["<Leader>fr"] = { "<Cmd>Telescope resume<CR>", desc = "Resume previous search" },
        ["<Leader>fs"] = { "<Cmd>Telescope lsp_document_symbols<CR>", desc = "Find document symbols" },
        ["<Leader>fw"] = { "<Cmd>Telescope live_grep<CR>", desc = "Find words" },
        ["<Leader>fW"] = { "<Cmd>Telescope grep_string<CR>", desc = "Find word under cursor" },
        ["sh"] = { "<C-w>h", desc = "Move to left split" },
        ["sj"] = { "<C-w>j", desc = "Move to lower split" },
        ["sk"] = { "<C-w>k", desc = "Move to upper split" },
        ["sl"] = { "<C-w>l", desc = "Move to right split" },
        ["ss"] = {
          function()
            vim.cmd.split()
            balance_splits()
          end,
          desc = "Create horizontal split",
        },
        ["sv"] = {
          function()
            vim.cmd.vsplit()
            balance_splits()
          end,
          desc = "Create vertical split",
        },
        ["<Leader>bd"] = {
          function()
            require("astroui.status.heirline").buffer_picker(
              function(bufnr) require("astrocore.buffer").close(bufnr) end
            )
          end,
          desc = "Close buffer from tabline",
        },
      },
    },
  },
}
