# Shared interactive Zsh configuration for this dotfiles repository.
# Source this file from ~/.zshrc after plugins and prompt initialization.

if [[ -o interactive ]]; then
  # Use Zsh's vi keymaps. In Zsh this is called `vicmd` (normal mode); the
  # actual visual selection of terminal output belongs to tmux copy-mode.
  bindkey -v
  typeset -g KEYTIMEOUT=20

  # Insert mode -> normal mode with Escape or jj.
  bindkey -M viins '^[' vi-cmd-mode
  bindkey -M viins 'jj' vi-cmd-mode

  # History navigation while staying in insert mode.
  bindkey -M viins '^K' up-line-or-search
  bindkey -M viins '^J' down-line-or-search

  # Autosuggestions: make generated text clearly different from typed text.
  if (( ${+widgets[autosuggest-accept]} )); then
    typeset -g ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8da2b8'
    bindkey -M viins '^E' autosuggest-accept
    bindkey -M viins '^W' autosuggest-execute
    bindkey -M viins '^U' autosuggest-toggle
  fi

  # Navigation and common tools.
  alias ..='cd ..'
  alias ...='cd ../..'
  alias ....='cd ../../..'
  alias .....='cd ../../../..'

  if command -v eza >/dev/null 2>&1; then
    alias l='eza -la --icons --git --group-directories-first'
    alias ll='eza -l --icons --git --group-directories-first'
    alias lt='eza --tree --level=2 --icons --git --group-directories-first'
  fi

  alias c='clear'
  alias v='nvim'

  # Git shortcuts. `g` remains the full git command, so every subcommand is
  # still available: g status, g switch, g worktree, etc.
  alias g='git'
  alias gs='git status --short --branch'
  alias gss='git status'
  alias ga='git add'
  alias gaa='git add --all'
  alias gap='git add --patch'
  alias gc='git commit'
  alias gcm='git commit -m'
  alias gca='git commit --amend'
  alias gcan='git commit --amend --no-edit'
  alias gd='git diff'
  alias gds='git diff --staged'
  alias gl='git log --oneline --decorate --graph --all'
  alias gb='git branch'
  alias gbl='git branch --all --verbose'
  alias gsw='git switch'
  alias gsc='git switch --create'
  alias gf='git fetch --prune'
  alias gp='git push'
  alias gpf='git push --force-with-lease'
  alias gpl='git pull --ff-only'
  alias gr='git restore'
  alias grs='git restore --staged'
  alias grv='git remote --verbose'
  alias gcl='git clone'

  # Optional syntax highlighting. It is active automatically when the
  # Homebrew package is installed, but remains optional for portability.
  local zsh_highlighting=''
  if [[ -n "${HOMEBREW_PREFIX:-}" && -r "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
    zsh_highlighting="$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
  elif command -v brew >/dev/null 2>&1; then
    local brew_prefix
    brew_prefix="$(brew --prefix 2>/dev/null)"
    if [[ -r "$brew_prefix/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
      zsh_highlighting="$brew_prefix/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
    fi
  fi

  if [[ -n "$zsh_highlighting" ]]; then
    typeset -gA ZSH_HIGHLIGHT_STYLES
    ZSH_HIGHLIGHT_STYLES[command]='fg=00e5ff,bold'
    ZSH_HIGHLIGHT_STYLES[alias]='fg=c77dff,bold'
    ZSH_HIGHLIGHT_STYLES[path]='fg=37f499,underline'
    ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=37f499'
    ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=37f499'
    ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=ff5d73,bold'
    ZSH_HIGHLIGHT_STYLES[comment]='fg=64748b'
    source "$zsh_highlighting"
  fi
fi
