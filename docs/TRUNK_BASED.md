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


---

# Guía ampliada: GitHub, Azure DevOps y LazyGit

Las secciones siguientes son la referencia operativa para trabajar con una main protegida por
revisiones, pipelines y políticas. Sustituyen cualquier receta antigua que intente publicar
directamente sobre main.

## 5. Qué significa cada operación

### Fetch

~~~bash
git fetch origin --prune
~~~

Descarga referencias y elimina referencias remotas obsoletas. No cambia tu directorio de
trabajo ni integra commits.

### Pull

~~~bash
git pull --ff-only origin main
~~~

Hace fetch y luego integra la rama remota indicada en la rama actual. En este repositorio,
gpl usa pull --ff-only para que una divergencia no cree un merge inesperado.

Pull no significa “unir mi rama a main”. Si estás en codex/mi-cambio, un pull sin argumentos
actúa sobre el upstream de esa rama. Para llevar main a tu rama debes actualizar origin/main
y ejecutar rebase origin/main o merge origin/main.

### Rebase de una rama personal

~~~bash
git fetch origin --prune
git rebase origin/main
~~~

Reaplica tus commits encima de la última main y conserva una historia lineal. Cambia los
hashes de tus commits, por eso una rama publicada debe actualizarse con:

~~~bash
git push --force-with-lease
~~~

### Merge de main en una rama compartida

~~~bash
git fetch origin --prune
git merge --no-edit origin/main
git push
~~~

Conserva la historia de la rama. Es la alternativa cuando más de una persona trabaja sobre
la misma rama o el equipo no permite reescribirla.

### Pull Request

El PR es la entrada controlada a main. La plataforma puede exigir reviewers, work items,
comentarios resueltos, build validation, status checks, rama actualizada y un tipo de merge
concreto.

En una main protegida, el PR es la integración. El merge local sólo se utiliza para preparar
o simular una integración cuando la política de la organización lo permite.

## 6. Convenciones de ramas y commits

La rama principal es main. Las ramas de tarea usan el prefijo codex/ en este repositorio:

~~~text
codex/fix-prompt
codex/azure-pr-docs
codex/update-neovim-lock
codex/hotfix-route-config
~~~

Una rama debe tener una sola intención, una sola persona o pareja de trabajo y una vida
corta. Evita develop, integration y ramas por sprint.

Usa commits pequeños que puedan compilar, probarse y revertirse:

~~~text
feat: agregar validacion de configuracion
fix: corregir alias de git
docs: explicar actualizacion de una rama atrasada
test: cubrir parser de opciones
chore: actualizar lockfile
~~~

No mezcles un cambio de funcionalidad con una limpieza no relacionada. La revisión y el
pipeline son más confiables cuando el diff tiene una sola historia.

## 7. Preflight diario

Antes de crear una rama:

~~~bash
gs
git remote -v
git branch --show-current
git fetch origin --prune
git log --oneline --decorate --graph --all -12
~~~

Actualiza main:

~~~bash
gmain
gpl
gs
~~~

Crea la rama:

~~~bash
gsc codex/nombre-del-cambio
~~~

Antes de hacer commit:

~~~bash
gd
git diff --check
git status --short
~~~

Antes de publicar:

~~~bash
gds
git log origin/main..HEAD --oneline
git push --dry-run origin HEAD
~~~

El dry-run comprueba la operación sin actualizar el remoto.

## 8. Flujo GitHub completo

### 8.1 Crear y publicar una rama

~~~bash
gmain
gpl
gsc codex/mi-cambio

# editar y probar
gd
git diff --check
git add -p
gds
gcm "feat: describir el cambio"

git push --set-upstream origin HEAD
~~~

### 8.2 Abrir el PR

Con el alias configurado:

~~~bash
gpr
~~~

Equivale a:

~~~bash
gh pr create --fill --base main --web
~~~

Forma explícita:

~~~bash
gh pr create \
  --base main \
  --head codex/mi-cambio \
  --title "feat: describir el cambio" \
  --body "Incluye impacto, pruebas y riesgos."
~~~

### 8.3 Revisar el PR y sus checks

~~~bash
gprv
gh pr status
gh pr checks --required
gchecks
gh pr diff
~~~

gchecks espera los checks. Un check pendiente significa que la validación no terminó; un
check fallido requiere corregir, hacer commit y publicar la rama otra vez.

### 8.4 Actualizar un PR atrasado

Si GitHub exige que la rama esté actualizada:

~~~bash
git fetch origin --prune
gbase
git push --force-with-lease
gchecks
~~~

También existe el comando de GitHub CLI para pedir una actualización por rebase:

~~~bash
gpru
~~~

Cada nuevo commit puede invalidar aprobaciones anteriores y obliga a revisar el diff de nuevo.

### 8.5 Integrar

Usa la estrategia permitida por las reglas del repositorio:

~~~bash
gh pr merge --auto --squash --delete-branch
~~~

Si la política exige rebase:

~~~bash
gh pr merge --auto --rebase --delete-branch
~~~

No uses --admin para saltarte reviewers o checks salvo una emergencia formalmente autorizada.

Después:

~~~bash
gmain
gpl
git fetch origin --prune
gs
~~~

El estado esperado es:

~~~text
## main...origin/main
~~~

## 9. Caso principal: main avanzó mientras trabajabas

Supón esta historia:

~~~text
A---B---C  origin/main
 \
  D---E    codex/mi-cambio
~~~

B y C llegaron a main mientras tú trabajabas en D y E. El PR ya no representa la última
base y un pipeline estricto puede bloquearlo.

### Rama personal: rebase recomendado

~~~bash
gs
git fetch origin --prune
git switch codex/mi-cambio
gbase
git diff origin/main...HEAD
git diff --check
git push --force-with-lease
gchecks
~~~

Resultado:

~~~text
A---B---C  origin/main
         \
          D'---E'  codex/mi-cambio
~~~

El rebase no modifica main. Sólo reorganiza tu rama de trabajo para que el PR pueda validar
la combinación actual.

### Rama compartida: merge de main

~~~bash
git fetch origin --prune
git switch codex/mi-cambio
git merge --no-edit origin/main
git diff --check
git push
gchecks
~~~

Aquí no uses gpf. Los demás colaboradores necesitan conservar los hashes que ya conocen.

### Por qué no basta con pull

Este comando no es la solución general:

~~~bash
git pull origin main
~~~

Sólo integra main en la rama actual. Puede ser válido si estás deliberadamente en
codex/mi-cambio y quieres actualizarla, pero debes elegir explícitamente si el resultado
debe ser un rebase o un merge. El flujo claro es fetch más rebase o fetch más merge.

## 10. Conflictos de rebase

Inicia:

~~~bash
git fetch origin --prune
git switch codex/mi-cambio
git rebase origin/main
~~~

Inspecciona:

~~~bash
gconf
git status
~~~

Resuelve el archivo y elimina los marcadores:

~~~text
[INICIO_DEL_BLOQUE_BASE]
cambio de origin/main
[SEPARADOR]
cambio de tu rama
[FIN_DEL_BLOQUE_DE_TU_RAMA]
~~~

Continúa:

~~~bash
git add ruta/resuelta
git rebase --continue
~~~

Repite hasta finalizar. Luego:

~~~bash
git diff origin/main...HEAD
git diff --check
git push --force-with-lease
~~~

Cancela sin conservar el rebase:

~~~bash
git rebase --abort
~~~

Si un editor aparece solicitando el mensaje del commit, guarda y cierra el editor. Si
necesitas modificar el mensaje, hazlo antes de continuar.

## 11. Conflictos de merge

Para una rama compartida:

~~~bash
git fetch origin --prune
git switch codex/mi-cambio
git merge --no-edit origin/main
gconf
~~~

Resuelve, prueba y termina:

~~~bash
git add ruta/resuelta
git commit
git push
gchecks
~~~

Cancela el merge:

~~~bash
git merge --abort
~~~

No mezcles la resolución con cambios nuevos. Primero deja la integración consistente, luego
crea otro commit si hace falta.

## 12. Cambios sin commit cuando main avanzó

Primero revisa:

~~~bash
gs
gd
~~~

### Commit temporal

~~~bash
git add -p
git commit -m "wip: guardar avance antes de actualizar base"
git fetch origin --prune
gbase
~~~

Después puedes ordenar los commits:

~~~bash
git rebase -i origin/main
~~~

### Stash con nombre

~~~bash
git stash push -u -m "wip: cambio de prompt"
git fetch origin --prune
gbase
git stash pop
~~~

Comprueba el stash antes de eliminarlo:

~~~bash
git stash list
git stash show --stat stash@{0}
git stash drop stash@{0}
~~~

## 13. PR aprobado, pero main volvió a cambiar

No completes el PR con la aprobación vieja. Actualiza y vuelve a validar:

~~~bash
git fetch origin --prune
git switch codex/mi-cambio
gbase
git push --force-with-lease
gchecks
gh pr view --web
~~~

Un push nuevo puede dejar reviews obsoletas y volver a ejecutar los pipelines. La versión
que se integra debe ser la versión más reciente que revisaron los responsables.

## 14. Pipeline fallido

Consulta el diff que realmente se propone:

~~~bash
git diff origin/main...HEAD
git log origin/main..HEAD --oneline
git diff --check
~~~

Prueba localmente el proyecto. Para este repositorio:

~~~bash
zsh -n zsh/config.zsh
python3 -m json.tool nvim/lazy-lock.json
git diff --check
~~~

Con herramientas instaladas:

~~~bash
fish -n fish/config.fish
fish -n fish/conf.d/91-productivity.fish
tmux -f tmux/tmux.conf -C
~~~

GitHub:

~~~bash
gh pr checks --required
gh pr checks --watch
gh pr view --web
~~~

Azure DevOps:

~~~bash
az repos pr policy list --id ID_DEL_PR --output table
az repos pr show --id ID_DEL_PR --open
~~~

Corrige con un commit pequeño:

~~~bash
git add -p
git commit -m "fix: corregir validacion del pipeline"
git push
~~~

No cambies la política ni uses bypass para ocultar un fallo.

## 15. Main protegida rechaza el push

Si ves un error de rama protegida, el comportamiento es correcto. Revisa y publica una
rama de PR:

~~~bash
git switch codex/mi-cambio
git fetch origin --prune
gbase
git push --force-with-lease
gpr
gchecks
~~~

Nunca uses:

~~~bash
git push --force origin main
~~~

Una rama protegida puede exigir PR, approvals, checks, historial lineal, commits firmados o
restricción de quién puede hacer push.

## 16. Azure DevOps: configuración y PR

Azure CLI usa la extensión azure-devops.

~~~bash
az extension add --name azure-devops
~~~

Configura valores de tu organización:

~~~bash
az devops configure --defaults \
  organization=https://dev.azure.com/ORGANIZACION \
  project="PROYECTO"
~~~

Comprueba:

~~~bash
az devops configure --list
az repos list --output table
~~~

Crea el PR:

~~~bash
az repos pr create \
  --repository REPOSITORIO \
  --source-branch codex/mi-cambio \
  --target-branch main \
  --title "feat: describir cambio" \
  --description "Qué cambia, cómo se probó y riesgos conocidos." \
  --work-items 1234 \
  --open
~~~

Lista y consulta:

~~~bash
az repos pr list \
  --repository REPOSITORIO \
  --target-branch main \
  --status active \
  --output table

az repos pr show --id ID_DEL_PR --output json
az repos pr policy list --id ID_DEL_PR --output table
az repos pr reviewer list --id ID_DEL_PR --output table
~~~

Vota cuando corresponda:

~~~bash
az repos pr set-vote --id ID_DEL_PR --vote approve
az repos pr set-vote --id ID_DEL_PR --vote wait-for-author
~~~

Completa automáticamente sólo cuando las políticas estén satisfechas:

~~~bash
az repos pr update \
  --id ID_DEL_PR \
  --auto-complete true \
  --delete-source-branch true
~~~

Completa manualmente después de aprobación y pipeline:

~~~bash
az repos pr update \
  --id ID_DEL_PR \
  --status completed \
  --delete-source-branch true \
  --transition-work-items true
~~~

No uses --bypass-policy sin una aprobación de emergencia documentada.

## 17. Azure branch policies y pipelines

La main de Azure Repos puede requerir:

- Número mínimo de reviewers.
- Reviewers específicos por directorio.
- Work item vinculado.
- Comentarios resueltos.
- Build validation.
- Status checks externos.
- Tipo de merge permitido.
- Restricción de push directo.

Una build validation Required debe pasar para que el PR pueda completarse. Si main cambia y
la política expira la build anterior, la validación debe volver a ejecutarse sobre la nueva
combinación.

Caso típico:

~~~text
PR creado       -> pipeline automático comienza
main avanza     -> la validación anterior puede quedar obsoleta
rama actualizada-> pipeline vuelve a ejecutar
checks verdes   -> reviewers validan
políticas OK    -> PR se completa
~~~

No confundas un pipeline exitoso de tu rama aislada con una validación exitosa de la
combinación rama más main. La segunda es la que protege la integración.

## 18. GitHub y Azure DevOps simultáneamente

Identifica el sistema que protege la main:

~~~bash
git remote -v
git branch -vv
git ls-remote --heads origin
git ls-remote --heads azure
~~~

Si ambos remotos son intencionales:

~~~bash
git push --set-upstream origin codex/mi-cambio
git push --set-upstream azure codex/mi-cambio
~~~

Abre el PR sólo en la plataforma que es fuente de verdad para main. Dos PRs separados pueden
tener checks distintos y dejar los repositorios desincronizados.

Si GitHub es el repositorio público y Azure ejecuta validaciones externas, la política debe
publicar el resultado del pipeline como status check en el PR de GitHub. En ese caso, el PR
se administra con gh y Azure sólo aporta la validación.

## 19. LazyGit para el flujo trunk-based

Abre LazyGit con:

~~~bash
lg
~~~

Uso diario:

1. Confirma la rama actual.
2. Selecciona main y actualiza referencias.
3. Crea una rama corta.
4. Revisa cambios por archivo y por fragmento.
5. Prepara sólo la intención del commit.
6. Publica la rama.
7. Abre el PR con la acción configurada.
8. Comprueba checks en GitHub o políticas de Azure.

Acciones personalizadas de este repositorio:

| Contexto | Tecla | Acción |
|---|---|---|
| Files | C | git cz mediante Commitizen. |
| Global | F | git fetch --all --prune. |
| localBranches | P | Push de la rama y configuración de upstream. |
| Global | O | Abrir el PR actual en el navegador. |
| Global | N | Crear PR con gh pr create --fill --web. |

Si main avanzó, utiliza el CLI para que la estrategia quede explícita:

~~~bash
git fetch origin --prune
gbase
git push --force-with-lease
gchecks
~~~

LazyGit es ideal para revisar diffs y staging; el estado exacto de políticas Azure se consulta
con az repos pr policy list.

## 20. Worktrees para separar tareas

Lista worktrees:

~~~bash
gwl
~~~

Crea una tarea nueva sin cambiar la carpeta actual:

~~~bash
git fetch origin --prune
git worktree add ../dotfiles-fix-prompt -b codex/fix-prompt origin/main
~~~

Trabaja:

~~~bash
cd ../dotfiles-fix-prompt
gs
~~~

Después de integrar y confirmar que no quedan cambios:

~~~bash
cd /Users/craftzdog/.config
git worktree remove ../dotfiles-fix-prompt
git worktree prune
~~~

## 21. Hotfix

Un hotfix sigue el mismo control:

~~~bash
gmain
gpl
gsc codex/hotfix-descripcion
# corregir y probar
git add -p
gcm "fix: corregir error critico"
git push --set-upstream origin HEAD
gpr
gchecks
~~~

No publiques directamente main aunque el cambio sea urgente. Si existe un procedimiento de
emergencia, documenta la autorización, la validación y el PR posterior.

## 22. Cambios grandes

Evita ramas largas usando:

- Feature flags.
- Branch by abstraction.
- Interfaces compatibles antes de cambiar implementaciones.
- PRs pequeños por cada paso reversible.
- Activación gradual por entorno.

Cada paso debe poder compilar, validarse y desplegarse. La rama corta sirve para revisión,
no como una rama de integración de meses.

## 23. Recuperación

### Rebase detenido

~~~bash
git status
gconf
git rebase --continue
~~~

Cancelar:

~~~bash
git rebase --abort
~~~

### Merge detenido

~~~bash
git status
gconf
git merge --abort
~~~

### force-with-lease rechazado

No repitas el force a ciegas:

~~~bash
git fetch origin --prune
git log --oneline --decorate origin/codex/mi-cambio -8
git log --left-right --cherry-pick --oneline origin/codex/mi-cambio...HEAD
~~~

Si otra persona publicó, coordina. Si sólo cambiaste la rama desde otra terminal, integra el
trabajo y vuelve a usar force-with-lease.

### PR mergeado con squash y rama local presente

Confirma el estado antes de borrar:

~~~bash
gh pr view --json state,mergedAt,headRefName
git switch main
git pull --ff-only origin main
git branch -D codex/mi-cambio
~~~

Usa -D únicamente después de confirmar merged y de verificar que no haya trabajo pendiente.

### Commit accidental en main sin publicar

Mueve primero el commit a una rama segura:

~~~bash
git switch -c codex/mover-commit
git switch main
git reset --hard origin/main
~~~

Este bloque sólo es válido si confirmaste que el commit quedó guardado en la rama nueva y
main local debe coincidir con origin/main. Si ya publicaste main, revierte mediante un PR y
no reescribas la historia.

## 24. Pruebas de aliases

Estas comprobaciones no crean PRs ni publican cambios:

~~~bash
zsh -n zsh/config.zsh
zsh -dfic 'source zsh/config.zsh; alias gmain; alias gbase; alias gff; alias gconf; alias gpr; alias gpru; alias gchecks; alias azpr; alias lg'
~~~

Fish, si está instalado:

~~~bash
fish -n fish/config.fish
fish -n fish/conf.d/91-productivity.fish
fish -ic 'source fish/conf.d/91-productivity.fish; abbr --show gbase; abbr --show gpr; abbr --show gchecks; abbr --show azpr; abbr --show lg'
~~~

Nushell, si está instalado:

~~~bash
nu --version
nu -c 'source nushell/config.nu'
~~~

Herramientas:

~~~bash
command -v git
command -v gh
command -v az
command -v lazygit
gh auth status
az version
lazygit --version
~~~

## 25. Checklist antes del merge

~~~bash
gs
git diff --check
git diff origin/main...HEAD
git log origin/main..HEAD --oneline
gh pr checks --required
~~~

En Azure:

~~~bash
az repos pr policy list --id ID_DEL_PR --output table
az repos pr reviewer list --id ID_DEL_PR --output table
~~~

Confirma:

- PR dirigido a main.
- Rama actualizada con origin/main.
- Sin conflictos.
- Pipeline más reciente en verde.
- Reviews requeridas aprobadas.
- Comentarios resueltos.
- Work item vinculado cuando sea obligatorio.
- Sin secretos ni archivos locales.
- Estrategia de merge permitida.
- Último commit revisado y validado.

## 26. Checklist después del merge

~~~bash
git switch main
git pull --ff-only origin main
git fetch origin --prune
git branch --merged
git status --short --branch
~~~

Resultado esperado:

~~~text
## main...origin/main
~~~

Elimina la rama integrada:

~~~bash
git branch -d codex/mi-cambio
~~~

Si el PR fue squash-merged y branch -d no reconoce el antecesor, confirma merged y usa la
eliminación específica de la sección de recuperación.

## 27. Fuentes oficiales

Metodología:

- https://trunkbaseddevelopment.com/
- https://trunkbaseddevelopment.com/short-lived-feature-branches/

Git:

- https://git-scm.com/docs/git-pull
- https://git-scm.com/docs/git-rebase
- https://git-scm.com/docs/git-merge
- https://git-scm.com/docs/git-push
- https://git-scm.com/docs/git-worktree

GitHub:

- https://cli.github.com/manual/gh_pr
- https://cli.github.com/manual/gh_pr_create
- https://cli.github.com/manual/gh_pr_checks
- https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/about-protected-branches
- https://docs.github.com/en/pull-requests/how-tos/merge-and-close-pull-requests/troubleshooting-required-status-checks

Azure DevOps:

- https://learn.microsoft.com/en-us/cli/azure/repos/pr
- https://learn.microsoft.com/en-us/azure/devops/repos/git/complete-pull-requests
- https://learn.microsoft.com/en-us/azure/devops/repos/git/branch-policies
- https://learn.microsoft.com/en-us/azure/devops/repos/git/branch-policies-overview
- https://learn.microsoft.com/en-us/azure/devops/repos/git/about-pull-requests
- https://learn.microsoft.com/en-us/azure/devops/repos/git/secure-repositories-pull-requests

Las políticas de tu organización tienen prioridad sobre estos ejemplos. Sustituye organización,
proyecto, repositorio, pipeline, reviewers y work items por valores reales.


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

## Edición con lógica de Vim en Zsh

Zsh no tiene un modo visual idéntico al de Vim para seleccionar texto de la salida; su modo equivalente para editar la línea es `vicmd` (modo normal). El indicador del prompt muestra `I` en inserción y `N` en modo normal.

```text
Esc o jj  → modo normal (N)
i         → insertar antes del cursor (I)
a         → insertar después del cursor (I)
A         → insertar al final de la línea (I)
0 / $     → inicio / final de la línea
w / b     → siguiente / anterior palabra
dd        → borrar la línea
D         → borrar desde el cursor hasta el final
u         → deshacer

Ctrl-a [  → modo copia de tmux para visualizar la salida
v         → comenzar selección dentro de tmux
y         → copiar y salir del modo copia
q         → salir sin copiar
```
