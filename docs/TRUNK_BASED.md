# Flujo trunk-based para este dotfile

Este repositorio usa `main` como trunk: las ramas de trabajo son cortas, se integran rápido y el historial publicado se mantiene lineal. El prefijo de las ramas de trabajo es `codex/`.

## Comandos básicos del flujo

`gs` es un atajo para `git status --short --branch`. Es el primer comando que se ejecuta para conocer la rama actual, cambios staged y cambios sin preparar.

```bash
# 1. Revisar estado y rama actual
gs

# 2. Actualizar referencias remotas antes de empezar
git fetch origin

# 3. Crear una rama corta desde main
git switch main
git pull --ff-only origin main
git switch -c codex/nombre-del-cambio

# 4. Trabajar y revisar el diff
git status --short
git diff
git add <archivos>
git diff --cached --check
git diff --cached

# 5. Crear un commit pequeño y descriptivo
git commit -m "tipo: descripción breve del cambio"

# 6. Volver al trunk e integrar linealmente
git switch main
git pull --ff-only origin main
git merge --ff-only codex/nombre-del-cambio

# 7. Publicar main
git push origin main

# 8. Confirmar el resultado y eliminar la rama local ya integrada
gs
git branch -d codex/nombre-del-cambio
```

## Flujo aplicado en esta publicación

Estos son los comandos relevantes usados para esta integración:

```bash
gs
git branch --all --verbose --no-abbrev
git remote -v
git ls-remote --heads origin

# Respaldo local antes de limpiar el historial
git branch backup/pre-publication-history main

# Eliminar del historial publicado credenciales, historiales y estado local
git filter-branch --force --index-filter \
  'git rm -r --cached --ignore-unmatch cagent configstore fish/fish_variables gh/hosts.yml github-copilot homebrew nushell/history.txt nvim.bak1' \
  --prune-empty --tag-name-filter cat -- main

# Rama corta para esta documentación
git switch -c codex/trunkbase-documentation
git add docs/TRUNK_BASED.md README.md
git diff --cached --check
git commit -m "docs: document trunk-based publishing flow"

# Integración rápida al trunk
git switch main
git merge --ff-only codex/trunkbase-documentation

# Publicación
git push --set-upstream origin main

# Verificación final
gs
git log --oneline --decorate --graph -5
```

## Qué hacer si `main` avanzó mientras trabajabas

No se debe crear un merge commit innecesario. Actualiza tu rama corta y vuelve a integrarla:

```bash
git fetch origin
git switch codex/nombre-del-cambio
git rebase origin/main
git switch main
git pull --ff-only origin main
git merge --ff-only codex/nombre-del-cambio
git push origin main
```

## Diferencia entre `diff`, `diff --cached` y `gs`

- `gs`: resumen de la rama y todos los cambios.
- `git diff`: cambios modificados pero todavía no preparados.
- `git diff --cached`: cambios preparados después de `git add`.
- Sin cambios, `git diff` correctamente no imprime nada.
- `git branch` muestra la rama actual con `*`; en este repositorio es `main`.

## Seguridad

Los archivos de autenticación, historiales y estados locales están excluidos por `.gitignore`. La rama `backup/pre-publication-history` contiene el historial anterior con esos archivos y debe permanecer local; no se debe publicar con `git push --all`.
