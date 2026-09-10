# Keep Fish's command-line editing in its default mode. Zsh is the active
# shell for Ghostty and provides the Vim-style mode documented in the README.
if status is-interactive
    set --global fish_key_bindings fish_default_key_bindings
end
