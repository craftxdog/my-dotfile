# Dotfiles

Configuración personal para Ghostty, tmux, Zsh, Fish, Starship y Neovim.

## Activación de Zsh

Después de clonar el repositorio, añade esta línea a `~/.zshrc`:

```zsh
source "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/config.zsh"
```

La configuración compartida debe cargarse después de los plugins de Zsh y de Starship.

## Terminal

- Ghostty deja margen visual y conserva hasta un millón de líneas de scrollback.
- tmux acepta scroll con la rueda del mouse. También puedes usar `Ctrl-a [` para entrar al modo de copia, `PageUp`/`PageDown` para desplazarte, `g`/`G` para ir al inicio/final y `q` para salir.
- Zsh usa edición estilo Emacs para que la línea siempre pueda modificarse sin quedar atrapada en modo vi.
- Las sugerencias de Zsh se aceptan con `Ctrl-e`; `Ctrl-w` acepta y ejecuta la sugerencia completa.

El flujo de trabajo y los comandos de publicación están documentados en [docs/TRUNK_BASED.md](docs/TRUNK_BASED.md).

## Alias Git

`g` es un alias directo de `git`, por lo que siguen funcionando comandos completos como `g status` o `g worktree`. También están disponibles `gs`, `ga`, `gaa`, `gc`, `gcm`, `gd`, `gds`, `gl`, `gb`, `gsw`, `gsc`, `gf`, `gp`, `gpl`, `gr`, `grs` y `grv`.

## Seguridad

Los historiales, credenciales, bases de datos de autenticación y estados locales están excluidos mediante `.gitignore`. Antes de publicar, revisa también el historial existente: el commit inicial ya contiene archivos sensibles que deben eliminarse del historial y cuyas credenciales conviene rotar si llegaron a estar activas.
