-- Final polish that runs after plugin setup.

if vim.fn.exists "&winborder" == 1 then vim.opt.winborder = "rounded" end

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Briefly highlight yanked text",
  callback = function() vim.highlight.on_yank { higroup = "IncSearch", timeout = 160 } end,
})

vim.api.nvim_create_autocmd("FileType", {
  desc = "Keep transient UI buffers visually quiet",
  pattern = { "help", "lazy", "mason", "neo-tree", "snacks_dashboard", "toggleterm" },
  callback = function(args)
    vim.opt_local.colorcolumn = ""
    vim.opt_local.cursorline = true
    vim.opt_local.list = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
  end,
})
