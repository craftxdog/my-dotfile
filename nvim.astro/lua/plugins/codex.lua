-- Codex integration inside Neovim.
-- Uses the authenticated Codex CLI, so it works with ChatGPT/Codex subscription auth
-- instead of requiring an OpenAI API key.

---@type LazySpec
return {
  {
    "akinsho/toggleterm.nvim",
    cmd = {
      "ToggleTerm",
      "TermExec",
      "Codex",
      "CodexAsk",
      "CodexExplain",
      "CodexImprove",
      "CodexLogin",
      "CodexResume",
      "CodexReview",
      "CodexTests",
    },
    specs = {
      {
        "AstroNvim/astrocore",
        opts = function(_, opts)
          local maps = opts.mappings

          maps.n["<Leader>a"] = { desc = "AI / Codex" }
          maps.n["<Leader>aa"] = { "<Cmd>CodexAsk<CR>", desc = "Ask Codex" }
          maps.n["<Leader>ac"] = { "<Cmd>Codex<CR>", desc = "Open Codex chat" }
          maps.n["<Leader>ae"] = { "<Cmd>CodexExplain<CR>", desc = "Explain current file" }
          maps.n["<Leader>af"] = { "<Cmd>CodexImprove<CR>", desc = "Improve current file" }
          maps.n["<Leader>al"] = { "<Cmd>CodexLogin<CR>", desc = "Codex login" }
          maps.n["<Leader>ar"] = { "<Cmd>CodexResume<CR>", desc = "Resume Codex chat" }
          maps.n["<Leader>aR"] = { "<Cmd>CodexReview<CR>", desc = "Review current file" }
          maps.n["<Leader>at"] = { "<Cmd>CodexTests<CR>", desc = "Generate tests" }

          maps.v["<Leader>ae"] = { ":CodexExplain<CR>", desc = "Explain selection" }
          maps.v["<Leader>af"] = { ":CodexImprove<CR>", desc = "Improve selection" }
          maps.v["<Leader>aR"] = { ":CodexReview<CR>", desc = "Review selection" }
        end,
      },
    },
    opts = function(_, opts)
      local Terminal = require "toggleterm.terminal"
      local api = vim.api

      local codex_term

      local function codex_width()
        local columns = vim.o.columns
        local ratio = columns < 120 and 0.45 or 0.38
        return math.floor(columns * ratio)
      end

      local function place_codex_window()
        vim.cmd "wincmd L"
        vim.wo.winfixwidth = true
        vim.cmd(("vertical resize %d"):format(codex_width()))
      end

      local function codex_bin()
        local from_path = vim.fn.exepath "codex"
        if from_path ~= "" then return from_path end

        local app_bin = "/Applications/Codex.app/Contents/Resources/codex"
        if vim.uv.fs_stat(app_bin) then return app_bin end
      end

      local function project_root() return vim.fs.root(0, { ".git" }) or vim.uv.cwd() end

      local function shell_join(parts)
        return table.concat(vim.tbl_map(function(part) return vim.fn.shellescape(part) end, parts), " ")
      end

      local function codex_terminal(cmd)
        return Terminal.Terminal:new {
          cmd = shell_join(cmd),
          close_on_exit = false,
          direction = "vertical",
          hidden = true,
          size = codex_width,
          on_open = function()
            place_codex_window()
            vim.cmd "startinsert!"
          end,
        }
      end

      local function buffer_context(line1, line2)
        local bufnr = api.nvim_get_current_buf()
        local path = api.nvim_buf_get_name(bufnr)
        local filetype = vim.bo[bufnr].filetype
        local last_line = api.nvim_buf_line_count(bufnr)

        line1 = line1 or 1
        line2 = line2 or last_line

        local lines = api.nvim_buf_get_lines(bufnr, line1 - 1, line2, false)
        local relpath = path ~= "" and vim.fn.fnamemodify(path, ":.") or "[No file name]"

        return table.concat({
          ("File: %s"):format(relpath),
          ("Lines: %d-%d"):format(line1, line2),
          "",
          ("```%s"):format(filetype),
          table.concat(lines, "\n"),
          "```",
        }, "\n")
      end

      local function notify_missing()
        require("astrocore").notify(
          "Codex CLI was not found. Install or log in with Codex.app, then restart Neovim.",
          vim.log.levels.ERROR
        )
      end

      local function open_codex(prompt)
        local bin = codex_bin()
        if not bin then return notify_missing() end

        local cmd = {
          bin,
          "--cd",
          project_root(),
          "--sandbox",
          "workspace-write",
          "--ask-for-approval",
          "on-request",
        }

        if prompt and prompt ~= "" then table.insert(cmd, prompt) end

        codex_term = codex_terminal(cmd)
        codex_term:toggle()
      end

      local function open_codex_resume()
        local bin = codex_bin()
        if not bin then return notify_missing() end

        codex_term = codex_terminal { bin, "--cd", project_root(), "resume", "--last" }
        codex_term:toggle()
      end

      local function open_codex_login()
        local bin = codex_bin()
        if not bin then return notify_missing() end

        codex_terminal({ bin, "login" }):toggle()
      end

      local function open_result_buffer(title)
        vim.cmd(("botright vertical %dnew"):format(codex_width()))
        place_codex_window()
        local bufnr = api.nvim_get_current_buf()
        vim.bo[bufnr].buftype = "nofile"
        vim.bo[bufnr].bufhidden = "wipe"
        vim.bo[bufnr].filetype = "markdown"
        vim.bo[bufnr].swapfile = false
        api.nvim_buf_set_name(bufnr, title)
        api.nvim_buf_set_lines(bufnr, 0, -1, false, { "Codex is thinking..." })
        return bufnr
      end

      local function run_codex_exec(prompt)
        local bin = codex_bin()
        if not bin then return notify_missing() end

        local bufnr = open_result_buffer "Codex Result"
        vim.system({
          bin,
          "exec",
          "--sandbox",
          "read-only",
          "--skip-git-repo-check",
          "--color",
          "never",
          "-",
        }, {
          cwd = project_root(),
          stdin = prompt,
          text = true,
        }, function(result)
          vim.schedule(function()
            if not api.nvim_buf_is_valid(bufnr) then return end

            local output = result.stdout
            if result.code ~= 0 and result.stderr ~= "" then output = result.stderr end
            if output == "" then output = "Codex finished without output." end

            api.nvim_buf_set_lines(bufnr, 0, -1, false, vim.split(output, "\n", { plain = true }))
          end)
        end)
      end

      local function ask_codex()
        vim.ui.input({ prompt = "Ask Codex: " }, function(input)
          if input and input ~= "" then run_codex_exec(input) end
        end)
      end

      local function explain_context(line1, line2)
        run_codex_exec(table.concat({
          "Explain this code clearly and practically.",
          "Focus on intent, control flow, important abstractions, and risks.",
          "",
          buffer_context(line1, line2),
        }, "\n"))
      end

      local function review_context(line1, line2)
        run_codex_exec(table.concat({
          "Review this code like a senior engineer.",
          "Prioritize bugs, regressions, edge cases, and missing tests.",
          "Return concise findings with severity and exact line references when possible.",
          "",
          buffer_context(line1, line2),
        }, "\n"))
      end

      local function improve_context(line1, line2)
        open_codex(table.concat({
          "Improve this code directly in the repository if needed.",
          "Keep changes minimal and preserve existing style.",
          "Explain the change and run the most relevant validation if available.",
          "",
          buffer_context(line1, line2),
        }, "\n"))
      end

      local function generate_tests()
        open_codex(table.concat({
          "Add or improve tests for the current file.",
          "Inspect the repository first, follow existing test patterns, and keep changes focused.",
          "",
          buffer_context(),
        }, "\n"))
      end

      api.nvim_create_user_command(
        "Codex",
        function(opts) open_codex(opts.args ~= "" and opts.args or nil) end,
        { nargs = "*" }
      )

      api.nvim_create_user_command("CodexAsk", ask_codex, {})
      api.nvim_create_user_command("CodexLogin", open_codex_login, {})
      api.nvim_create_user_command("CodexResume", open_codex_resume, {})
      api.nvim_create_user_command("CodexExplain", function(opts) explain_context(opts.line1, opts.line2) end, {
        range = true,
      })
      api.nvim_create_user_command("CodexReview", function(opts) review_context(opts.line1, opts.line2) end, {
        range = true,
      })
      api.nvim_create_user_command("CodexImprove", function(opts) improve_context(opts.line1, opts.line2) end, {
        range = true,
      })
      api.nvim_create_user_command("CodexTests", generate_tests, {})

      if not opts.highlights then opts.highlights = {} end

      local previous_on_open = opts.on_open
      opts.on_open = function(term)
        if previous_on_open then previous_on_open(term) end
        if term.direction == "float" then vim.cmd "startinsert!" end
      end

      opts.shade_terminals = false
    end,
  },
}
