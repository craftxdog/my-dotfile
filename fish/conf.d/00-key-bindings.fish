# Keep command-line editing in Fish's default (Emacs-like) mode.
# This prevents an accidental vi command mode from making the prompt feel
# locked after navigating or editing a previous command.
if status is-interactive
    set --global fish_key_bindings fish_default_key_bindings
end
