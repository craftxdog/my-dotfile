set -gx CLICOLOR 1
set -gx LSCOLORS gxfxcxdxbxegedabagacad
set -gx EZA_ICON_SPACING 2
set -gx HOMEBREW_NO_ENV_HINTS 1

if type -q bat
    set -gx BAT_STYLE "numbers,changes,header"
    set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"
end

if type -q delta
    set -gx GIT_PAGER delta
    set -gx DELTA_FEATURES "side-by-side line-numbers decorations"
end

if status is-interactive
    alias reload-fish "source ~/.config/fish/config.fish"
    alias ports "lsof -nP -iTCP -sTCP:LISTEN"
    alias serve "python3 -m http.server"

    abbr -q gs; or abbr -a gs "git status --short --branch"
    abbr -q ga; or abbr -a ga "git add"
    abbr -q gaa; or abbr -a gaa "git add --all"
    abbr -q gc; or abbr -a gc "git commit"
    abbr -q gcm; or abbr -a gcm "git commit -m"
    abbr -q gco; or abbr -a gco "git checkout"
    abbr -q gb; or abbr -a gb "git branch"
    abbr -q gd; or abbr -a gd "git diff"
    abbr -q gds; or abbr -a gds "git diff --staged"
    abbr -q gl; or abbr -a gl "git log --oneline --decorate --graph --all"
    abbr -q gp; or abbr -a gp "git pull --ff-only"
    abbr -q gps; or abbr -a gps "git push"
    abbr -q y; or abbr -a y "yarn"
    abbr -q yr; or abbr -a yr "yarn run"
    abbr -q bi; or abbr -a bi "bun install"
    abbr -q br; or abbr -a br "bun run"
    abbr -q dark; or abbr -a dark "theme dark"
    abbr -q light; or abbr -a light "theme light"
    abbr -q auto-theme; or abbr -a auto-theme "theme auto"
end
