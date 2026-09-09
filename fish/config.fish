set fish_greeting ""

# Do not force TERM here.
# Ghostty/tmux should manage TERM.

set -gx EDITOR nvim
set -gx VISUAL nvim

fish_add_path ~/bin
fish_add_path ~/.local/bin
fish_add_path node_modules/.bin

# Bun
set -gx BUN_INSTALL "$HOME/.bun"
fish_add_path "$BUN_INSTALL/bin"

# Go
set -gx GOPATH "$HOME/go"
fish_add_path "$GOPATH/bin"

# Antigravity
fish_add_path /Users/craftzdog/.antigravity/antigravity/bin

# Inkdrop
set -gx INKDROP_HOME ~/.inkdrop

# Aliases
alias g git
alias c claude
alias claude-yolo "claude --dangerously-skip-permissions"

command -qv nvim; and alias vim nvim

if type -q eza
    alias ls "eza --icons=auto"
    alias la "eza -a --icons=auto"
    alias ll "eza -l -g --icons=auto"
    alias lla "eza -la -g --icons=auto"
else
    alias ls "ls -p -G"
    alias la "ls -A"
    alias ll "ls -l"
    alias lla "ls -la"
end

# FZF
set -g FZF_PREVIEW_FILE_CMD "bat --style=numbers --color=always --line-range :500"
set -g FZF_LEGACY_KEYBINDINGS 0

# OS-specific
switch (uname)
    case Darwin
        test -f ~/.config/fish/config-osx.fish; and source ~/.config/fish/config-osx.fish
    case Linux
        test -f ~/.config/fish/config-linux.fish; and source ~/.config/fish/config-linux.fish
end

# Local private config
test -f ~/.config/fish/config-local.fish; and source ~/.config/fish/config-local.fish

# Re-apply the visual theme when this file is sourced manually.
set -q CRAFTZDOG_THEME; or set -gx CRAFTZDOG_THEME dark
_craftzdog_apply_theme $CRAFTZDOG_THEME

# Keep the first prompt from inheriting the optional config file check status.
true
