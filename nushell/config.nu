# config.nu
#
# Installed by:
# version = "0.115.0"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# Nushell sets "sensible defaults" for most configuration settings, 
# so your `config.nu` only needs to override these defaults if desired.
#
# You can open this file in your default editor using:
#     config nu
#
# You can also pretty-print and page through the documentation for configuration
# options using:
#     config nu --doc | nu-highlight | less -R
# ============================================================
# Nushell
# ============================================================

$env.config.show_banner = false
$env.config.edit_mode = "vi"

$env.config.table.mode = "rounded"

$env.config.history.max_size = 100_000
$env.config.history.sync_on_enter = true

$env.EDITOR = "nvim"
$env.VISUAL = "nvim"
$env.config.buffer_editor = "nvim"


# ============================================================
# Starship
# ============================================================

$env.STARSHIP_CONFIG = (
    $env.HOME
    | path join ".config/starship/starship.toml"
)


# ============================================================
# Carapace
# ============================================================

$env.CARAPACE_BRIDGES = "zsh,fish,bash,inshellisense"

source ($nu.cache-dir | path join "carapace.nu")


# ============================================================
# Zoxide
# ============================================================

source ~/.zoxide.nu


# ============================================================
# Atuin
# ============================================================

source ~/.local/share/atuin/init.nu


# ============================================================
# Mise
# ============================================================

use ($nu.cache-dir | path join "mise/init.nu")


# ============================================================
# Direnv
# ============================================================

$env.DIRENV_LOG_FORMAT = ""

$env.config.hooks.env_change.PWD = (
    $env.config.hooks.env_change.PWD
    | append { ||
        if (which direnv | is-empty) {
            return
        }

        direnv export json
        | from json
        | default {}
        | load-env
    }
)


# ============================================================
# Navigation
# ============================================================

alias l = ls --all
alias ll = ls -l
alias c = clear

alias lt = eza --tree --level=2 --long --icons --git

alias v = nvim


def --env cx [path: path] {
    cd $path
    ls -l
}


# ============================================================
# Git
# ============================================================

alias gc = git commit -m
alias gca = git commit -a -m

alias gp = git push origin HEAD
alias gpu = git pull origin

alias gst = git status

alias glog = git log --graph --topo-order --pretty='%w(100,0,6)%C(yellow)%h%C(bold)%C(black)%d %C(cyan)%ar %C(green)%an%n%C(bold)%C(white)%s %N' --abbrev-commit

alias gdiff = git diff
alias gco = git checkout

alias gb = git branch
alias gba = git branch -a

alias gadd = git add
alias ga = git add -p

alias gcoall = git checkout -- .

alias gr = git remote
alias gre = git reset


# ============================================================
# Kubernetes
# ============================================================

alias k = kubectl
alias ka = kubectl apply -f
alias kg = kubectl get
alias kd = kubectl describe
alias kdel = kubectl delete

alias kl = kubectl logs -f

alias kgpo = kubectl get pods
alias kgd = kubectl get deployments

alias ke = kubectl exec -it


# ============================================================
# Tools
# ============================================================

alias asr = atuin scripts run

alias as = aerospace
alias oc = opencode
