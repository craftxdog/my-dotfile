
# Manual completo de comandos, atajos y productividad

> Referencia operativa de la configuración actual de /Users/craftzdog/.config.
> Última revisión: 2026-09-11.

Este documento explica los comandos disponibles en la terminal, qué problema resuelven,
por qué existen y cómo usarlos en el trabajo diario. La configuración está pensada para
trabajar principalmente con Zsh dentro de Ghostty y tmux, manteniendo alternativas para
Fish, Nushell y PowerShell.

## 1. Cómo leer este manual

- Un alias de Zsh se ejecuta en la sesión actual y no modifica el comando escrito.
- Una abreviatura de Fish se expande al pulsar espacio o Enter; puedes verla y editarla
  antes de ejecutarla.
- Un alias de Nushell reemplaza el nombre por el comando configurado.
- g siempre significa Git completo. Por ejemplo, g status equivale a git status.
  Esto conserva acceso a cualquier subcomando de Git que no tenga atajo.
- Cuando se indica “efectivo en Zsh”, significa el resultado después de cargar
  ~/.zshrc y el archivo compartido zsh/config.zsh.

## 2. Flujo rápido recomendado

### Al comenzar el día

~~~bash
cd ~/Developments/mi-proyecto
gs
gf
gpl
gl
~~~

gs muestra la rama y los cambios de forma compacta. gf actualiza referencias remotas
y elimina referencias locales a ramas remotas que ya no existen. gpl integra los cambios
con pull --ff-only, evitando crear un merge accidental. gl permite revisar el grafo.

### Antes de guardar cambios

~~~bash
gd
gds
gss
~~~

- gd: diferencias todavía no preparadas.
- gds: diferencias que ya están en staging.
- gss: estado completo y legible de Git.

### Crear y publicar una rama de trabajo

~~~bash
gsw main
gpl
gsc codex/mejora-terminal
gd
gaa
gcm "docs: documentar atajos de terminal"
gp
~~~

La rama usa el flujo trunk-based: se parte de main actualizado, se trabaja en una rama
corta, se publica y después se integra mediante una unión fast-forward cuando sea posible.

### Finalizar el trabajo

~~~bash
gss
gds
gl
gp
~~~

Si gp todavía no conoce el upstream de la rama:

~~~bash
git push --set-upstream origin codex/mejora-terminal
~~~

## 3. Zsh: shell principal

Archivos relacionados:

- ~/.zshrc: carga plugins, completado, FZF, Atuin, mise, zoxide, direnv, Starship
  y el archivo compartido.
- zsh/config.zsh: configuración portable de edición Vim, colores, autosugerencias,
  navegación y Git.

### 3.1 Navegación y archivos

| Comando | Equivale a | Uso diario |
|---|---|---|
| .. | cd .. | Subir un directorio. |
| ... | cd ../.. | Subir dos niveles. |
| .... | cd ../../.. | Subir tres niveles. |
| ..... | cd ../../../.. | Subir cuatro niveles. |
| l | eza -la --icons --git --group-directories-first | Listar archivos, incluidos ocultos, ordenados y con Git. |
| ll | eza -l --icons --git --group-directories-first | Vista larga sin forzar ocultos. |
| lt | eza --tree --level=2 --icons --git --group-directories-first | Ver el árbol inmediato del proyecto. |
| ltree | eza --tree --level=2 --icons --git | Variante de árbol definida en .zshrc. |
| c | clear | Limpiar la pantalla. |
| v | nvim | Abrir Neovim. |
| cx RUTA | cd RUTA y luego l | Entrar a una ruta y listar su contenido. |

Ejemplos:

~~~bash
cx ~/Developments
lt
v README.md
..
~~~

eza aporta la presentación con iconos y colores. Si no está disponible, se recomienda
instalarlo para mantener la apariencia configurada.

### 3.2 Selección con FZF

| Comando | Qué hace | Ejemplo |
|---|---|---|
| fcd | Busca directorios con fd, permite elegir con fzf y entra al resultado. | fcd |
| f | Busca archivos, copia la ruta elegida al portapapeles y la muestra. | f |
| fv | Busca un archivo y lo abre directamente en Neovim. | fv |

La búsqueda oculta .git y node_modules para evitar ruido. Las variables de FZF también
están configuradas para que:

- Ctrl-T busque archivos y directorios.
- Alt-C busque directorios.
- Ctrl-R quede reservado para Atuin.

Ejemplos de trabajo:

~~~bash
fv
fcd
f
~~~

En f, la ruta seleccionada se copia usando pbcopy, por lo que resulta útil para pegar
rutas en un issue, un comando Docker o una conversación técnica.

### 3.3 Edición de la línea con Vim

La sesión de Zsh usa bindkey -v.

| Modo | Indicador de Starship | Qué puedes hacer |
|---|---|---|
| Inserción | I➜ | Escribir, borrar y aceptar sugerencias. |
| Normal | N | Moverte y editar con lógica Vim. |

Para cambiar:

- Esc: pasar de inserción a normal.
- jj: pasar de inserción a normal.
- i: insertar antes del cursor.
- a: insertar después del cursor.
- A: insertar al final.
- I: insertar al comienzo.
- h, j, k, l: moverse en normal.
- 0: inicio de línea.
- $: final de línea.
- w: siguiente palabra.
- b: palabra anterior.
- x: borrar el carácter bajo el cursor.
- dd: borrar la línea completa.
- D: borrar desde el cursor hasta el final.
- u: deshacer.

Importante: este “modo normal” edita el comando actual. No es el modo visual para
seleccionar texto que ya apareció en la terminal. Para eso se usa el copy-mode de tmux,
explicado en la sección 8.

Para aceptar una autosugerencia:

- Ctrl-E: aceptar la sugerencia y dejarla editable.
- Ctrl-W: aceptar la sugerencia y ejecutarla inmediatamente.
- Ctrl-U: activar o desactivar las sugerencias.

El color fg=8da2b8 diferencia el texto sugerido del texto que ya escribiste. El
resaltado de sintaxis de Zsh, si está instalado, usa colores diferentes para comandos,
alias, rutas, argumentos, comentarios y tokens inválidos.

Si Esc o jj no funcionan después de cambiar archivos:

~~~bash
exec zsh
bindkey -M viins '^['
bindkey -M viins 'jj'
bindkey -v
~~~

KEYTIMEOUT=20 representa aproximadamente 0.2 segundos. Si jj se siente demasiado
rápido o lento, ese valor controla la espera entre las dos teclas.

### 3.4 Alias de Git en Zsh

| Alias | Comando | Para qué sirve |
|---|---|---|
| g | git | Mantener la palabra Git corta sin perder subcomandos. |
| gs | git status --short --branch | Estado compacto con rama actual. |
| gss | git status | Estado detallado. |
| ga | git add | Preparar un archivo o ruta indicada. |
| gaa | git add --all | Preparar todos los cambios, incluidos borrados. |
| gap | git add --patch | Elegir por fragmentos qué cambios preparar. |
| gc | git commit | Crear un commit usando el editor. |
| gcm MENSAJE | git commit -m MENSAJE | Crear un commit con mensaje directo. |
| gca | git commit --amend | Corregir el commit anterior y editar su mensaje. |
| gcan | git commit --amend --no-edit | Añadir cambios al commit anterior conservando el mensaje. |
| gd | git diff | Revisar cambios no preparados. |
| gds | git diff --staged | Revisar cambios preparados. |
| gl | git log --oneline --decorate --graph --all | Ver el historial como grafo. |
| gb | git branch | Listar ramas locales. |
| gbl | git branch --all --verbose | Listar ramas locales y remotas con último commit. |
| gsw RAMA | git switch RAMA | Cambiar de rama. |
| gsc RAMA | git switch --create RAMA | Crear y cambiar a una rama nueva. |
| gf | git fetch --prune | Actualizar referencias sin mezclar cambios. |
| gp | git push | Publicar la rama actual. |
| gpf | git push --force-with-lease | Actualizar una rama reescrita verificando el remoto. |
| gpl | git pull --ff-only | Traer cambios sólo si se puede avanzar linealmente. |
| gr RUTA | git restore RUTA | Descartar cambios no preparados de una ruta. |
| grs RUTA | git restore --staged RUTA | Sacar una ruta del staging sin borrar sus cambios. |
| grv | git remote --verbose | Ver URLs de los remotos. |
| gcl URL | git clone URL | Clonar un repositorio. |

Ejemplo seguro, por partes:

~~~bash
gd
gap
gds
gcm "feat: agregar soporte para tema claro"
gs
gp
~~~

gap es especialmente útil cuando un archivo contiene varios cambios y quieres que un
commit tenga una sola intención. Usa gr con cuidado: descarta cambios locales que todavía
no estén guardados en Git.

Alias heredados que también aparecen en .zshrc:

| Alias | Equivalencia | Nota |
|---|---|---|
| gpu | git pull origin | Más general que gpl; puede realizar rebase por la configuración global. |
| glog | log detallado personalizado | Muestra autor, fecha relativa, commit y mensaje. |
| gdiff | git diff | Alias legible alternativo. |
| gco | git checkout | Compatibilidad con flujos antiguos; para ramas nuevas se prefiere gsw/gsc. |
| gba | git branch -a | Ramas locales y remotas. |
| gadd | git add | Alias descriptivo alternativo. |
| gre | git reset | Potente; úsalo sólo sabiendo qué referencia se está reiniciando. |

### 3.5 Docker, Kubernetes y Atuin en Zsh

| Alias | Comando | Ejemplo |
|---|---|---|
| dco | docker compose | dco up -d |
| dps | docker ps | Ver contenedores activos. |
| dpa | docker ps -a | Ver todos los contenedores. |
| dl | docker ps -l -q | Obtener el ID del último contenedor. |
| dx CONTENEDOR CMD | docker exec -it CONTENEDOR CMD | dx api sh |
| k | kubectl | k get pods |
| ka ARCHIVO | kubectl apply -f ARCHIVO | Aplicar manifiestos. |
| kg | kubectl get | kg svc |
| kd | kubectl describe | kd pod api-0 |
| kdel | kubectl delete | Borrar un recurso indicado. |
| kl | kubectl logs -f | Seguir logs de un pod. |
| kgpo | kubectl get pods | Listar pods. |
| kgd | kubectl get deployments | Listar deployments. |
| ke | kubectl exec -it | Entrar a un contenedor. |
| kcns NS | kubectl config set-context --current --namespace NS | Cambiar namespace actual. |
| asr | atuin scripts run | Ejecutar un script guardado en Atuin. |

Ejemplos:

~~~bash
dco ps
dco logs -f api
kgpo -n staging
kl deploy/api -n staging
kcns development
~~~

Antes de usar kdel, verifica el contexto y namespace:

~~~bash
kubectl config current-context
kubectl config view --minify --output 'jsonpath={..namespace}'
~~~

### 3.6 Completado, historial y herramientas integradas

- Zsh usa compinit, menú interactivo y completado sin distinguir mayúsculas/minúsculas.
- Carapace aporta completado compartido para Zsh, Fish, Bash e Inshellisense.
- Atuin se inicia en Zsh y Nushell; Ctrl-R abre búsqueda de historial.
- La flecha arriba queda bajo el control del editor de línea de Zsh por
  atuin init zsh --disable-up-arrow.
- zoxide aprende tus directorios frecuentes.
- mise activa herramientas y versiones por proyecto.
- direnv carga variables por directorio cuando existe una configuración autorizada.

Comandos útiles:

~~~bash
atuin search
atuin scripts list
atuin scripts run
z proyecto
mise current
mise ls
direnv status
direnv allow
~~~

## 4. Fish

Fish conserva una configuración equivalente para usarla como shell alternativa o en otros
equipos. Sus abreviaturas se expanden en la línea, lo que permite ver el comando real antes
de ejecutarlo.

Archivos principales:

- fish/config.fish: variables, rutas, alias base, eza y configuración por sistema.
- fish/conf.d/91-productivity.fish: abreviaturas, comandos auxiliares y variables de
  presentación.
- fish/functions/: funciones de navegación, temas, prompt y FZF.

### 4.1 Alias y comandos base

| Comando | Equivale a | Uso |
|---|---|---|
| g | git | Git completo. |
| c | claude | Abrir Claude CLI. |
| claude-yolo | claude --dangerously-skip-permissions | Claude sin confirmaciones; usar sólo en un entorno controlado. |
| vim | nvim | Abrir Neovim. |
| ls | eza --icons=auto | Listado con iconos. |
| la | eza -a --icons=auto | Incluir ocultos. |
| ll | eza -l -g --icons=auto | Vista larga. |
| lla | eza -la -g --icons=auto | Vista larga con ocultos. |
| reload-fish | source ~/.config/fish/config.fish | Recargar Fish. |
| ports | lsof -nP -iTCP -sTCP:LISTEN | Ver puertos TCP escuchando. |
| serve | python3 -m http.server | Servidor HTTP en el directorio actual. |

Ejemplo:

~~~fish
cd ~/Developments/mi-proyecto
reload-fish
ports
serve 8000
~~~

En macOS y Linux se cargan ajustes de listado específicos desde config-osx.fish o
config-linux.fish. La configuración local privada se puede colocar en
fish/config-local.fish, que no debe entrar en Git.

### 4.2 Abreviaturas de Git

| Abreviatura | Se expande a |
|---|---|
| gs | git status --short --branch |
| gss | git status |
| ga | git add |
| gaa | git add --all |
| gap | git add --patch |
| gc | git commit |
| gcm | git commit -m |
| gca | git commit --amend |
| gcan | git commit --amend --no-edit |
| gco | git checkout |
| gb | git branch |
| gbl | git branch --all --verbose |
| gsw | git switch |
| gsc | git switch --create |
| gd | git diff |
| gds | git diff --staged |
| gl | git log --oneline --decorate --graph --all |
| gf | git fetch --prune |
| gp | git push |
| gpf | git push --force-with-lease |
| gpl | git pull --ff-only |
| gr | git restore |
| grs | git restore --staged |
| grv | git remote --verbose |

La diferencia frente a Zsh es que Fish muestra la expansión en la línea de comandos. Si
escribes gcm "mensaje" y pulsas espacio, puedes comprobar el comando antes de confirmar
con Enter.

### 4.3 Abreviaturas de productividad

| Abreviatura | Se expande a | Ejemplo |
|---|---|---|
| y | yarn | y add zod |
| yr | yarn run | yr dev |
| bi | bun install | bi |
| br | bun run | br dev |
| dark | theme dark | Cambiar a tema oscuro. |
| light | theme light | Cambiar a tema claro. |
| auto-theme | theme auto | Seguir el tema del sistema. |

### 4.4 Funciones de Fish

| Función | Qué hace | Ejemplo |
|---|---|---|
| croot | Va a la raíz del repositorio Git actual. | croot |
| mkcd DIR | Crea un directorio y entra en él. | mkcd src/components |
| theme [dark\|light\|auto] | Cambia colores de Fish y tema de Ghostty. | theme light |
| fzf_change_directory | Reúne rutas útiles y permite elegir directorio con FZF. | fzf_change_directory |

croot muestra un error si no estás dentro de Git. mkcd crea directorios intermedios con
mkdir -p, útil para preparar rápidamente una estructura nueva.

La búsqueda de fzf_change_directory considera:

- ~/.config.
- La raíz configurada de ghq, hasta cuatro niveles.
- Directorios del directorio actual.
- Directorios bajo ~/Developments.

### 4.5 Teclas de Fish y FZF

La sesión de Fish mantiene el modo de edición por defecto; la lógica Vim activa está en
Zsh. Esto evita que Esc o jj tengan comportamientos distintos entre shells.

| Teclas | Acción |
|---|---|
| Ctrl-F | Cambiar de directorio con la función FZF personalizada. |
| Ctrl-L | Avanzar un carácter. |
| Ctrl-D | Borrar el carácter bajo el cursor sin cerrar Fish. |
| Ctrl-O | Buscar directorios con fzf.fish. |
| Esc Ctrl-L | Buscar en logs de Git. |
| Esc Ctrl-S | Buscar en estado de Git. |
| Ctrl-R | Buscar en el historial con FZF/Atuin según la integración activa. |
| Esc Ctrl-P | Buscar procesos. |
| Ctrl-V | Buscar variables. |

Si necesitas Vim en la línea de Fish, debes cambiar explícitamente su modo con los
comandos propios de Fish; actualmente no se fuerza para que Zsh sea el shell Vim principal.

## 5. Nushell

Archivo: nushell/config.nu.

Nushell usa edición vi, historial de hasta 100.000 entradas, tablas redondeadas, editor
Neovim, Starship, Carapace, zoxide, Atuin, mise y direnv.

### 5.1 Navegación

| Alias | Equivale a |
|---|---|
| l | ls --all |
| ll | ls -l |
| c | clear |
| lt | eza --tree --level=2 --long --icons --git |
| v | nvim |
| cx RUTA | Entrar en la ruta y ejecutar ls -l. |

### 5.2 Git

| Alias | Equivale a |
|---|---|
| gc MENSAJE | git commit -m MENSAJE |
| gca MENSAJE | git commit -a -m MENSAJE |
| gp | git push origin HEAD |
| gpu | git pull origin |
| gst | git status |
| glog | Log gráfico detallado con autor, tiempo relativo y mensaje. |
| gdiff | git diff |
| gco | git checkout |
| gb | git branch |
| gba | git branch -a |
| gadd | git add |
| ga | git add -p |
| gr | git remote |
| gre | git reset |
| gcoall | git checkout -- . |

gcoall es destructivo para cambios no guardados: elimina las modificaciones del árbol de
trabajo. En el flujo normal se recomienda revisar antes con gdiff y preferir git restore
sólo sobre la ruta necesaria.

### 5.3 Kubernetes y herramientas

| Alias | Equivale a |
|---|---|
| k | kubectl |
| ka | kubectl apply -f |
| kg | kubectl get |
| kd | kubectl describe |
| kdel | kubectl delete |
| kl | kubectl logs -f |
| kgpo | kubectl get pods |
| kgd | kubectl get deployments |
| ke | kubectl exec -it |
| asr | atuin scripts run |
| as | aerospace |
| oc | opencode |

## 6. PowerShell

Archivo: powershell/Microsoft.PowerShell_profile.ps1.

PowerShell integra posh-git, Oh My Posh con takuya.omp.json, Terminal-Icons y PSFzf.
PSReadLine usa predicción de historial y no emite campana.

| Alias o función | Acción |
|---|---|
| vim | nvim |
| ll | ls |
| g | git |
| grep | findstr |
| tig | Ejecuta el binario de tig configurado. |
| less | Ejecuta el less configurado. |
| which COMANDO | Muestra la ruta del comando. |

Atajos de PSFzf:

- Ctrl-F: proveedor de archivos.
- Ctrl-R: historial inverso.

El perfil también añade al PATH los binarios de node_modules/.bin, Windows Kits y el
OpenSSH de Windows mediante GIT_SSH.

## 7. Git global

Archivo: /Users/craftzdog/.gitconfig.

Esta parte vive fuera del repositorio de dotfiles. Para publicarla en otro equipo hay que
adaptar rutas absolutas, identidad y autenticación.

### 7.1 Comportamiento global

- Editor: nvim.
- Rama inicial: main.
- pull.rebase = true.
- fetch.prune = true.
- push.default = simple.
- ignorecase = false.
- Colores automáticos en status, diff, branch, grep, interactive y UI.
- GitHub usa el helper de credenciales de gh.
- Diff y merge usan nvimdiff.
- LFS está habilitado.
- Hooks: /Users/craftzdog/.git-hooks.
- Excludes global: ~/.gitignore.
- Raíz de ghq: ~/.ghq.

### 7.2 Alias globales

| Alias | Acción |
|---|---|
| git a | Selecciona archivos del status con peco y ejecuta git add. |
| git d | git diff. |
| git co | git checkout. |
| git ci | git commit. |
| git ca | git commit -a. |
| git ps | Publica la rama actual en origin. |
| git pl | Trae la rama actual desde origin. |
| git st | git status. |
| git br | git branch. |
| git ba | git branch -a. |
| git bm | git branch --merged. |
| git bn | git branch --no-merged. |
| git df | Elige un commit con peco y muestra su diff. |
| git hist | Historial compacto, decorado y con fechas relativas. |
| git llog | Historial gráfico con nombres de archivos y status. |
| git open | Abre el repositorio en el navegador con hub. |
| git type OBJETO | git cat-file -t OBJETO. |
| git dump OBJETO | git cat-file -p OBJETO. |
| git find TEXTO | Busca cambios históricos por texto y muestra el diff. |
| git edit-unmerged | Abre archivos en conflicto durante un merge. |
| git add-unmerged | Añade archivos en conflicto después de resolverlos. |
| git lg | Log corto con grafo, decoración y todas las ramas. |

Ejemplos:

~~~bash
git a
git hist
git df
git find "nombre de funcion"
git lg
~~~

Los alias que llaman a peco necesitan que peco esté instalado. Los alias git ps y git pl
calculan la rama actual, por lo que son cómodos desde cualquier branch.

### 7.3 Diagnóstico de Git

Si git diff no muestra nada, no significa que Git esté roto:

~~~bash
git diff
git diff --cached
git status --short --branch
git log -1 --oneline
git branch --show-current
~~~

- git diff está vacío cuando no hay cambios no preparados.
- git diff --cached está vacío cuando no hay cambios en staging.
- git status --short --branch debe mostrar algo como ## main.
- git branch lista las ramas locales y marca la actual con *.
- Si acabas de editar un alias o config, abre una shell nueva o recarga la shell.

Para revisar la configuración efectiva:

~~~bash
git config --list --show-origin
git config --get-regexp '^(alias|pull|push|fetch|core)\.'
git remote -v
~~~

## 8. tmux: historial y modo visual de la terminal

Archivo: tmux/tmux.conf.

tmux es el responsable de conservar salida, dividir paneles y permitir seleccionar texto
que ya pasó por la terminal. Ghostty tiene un scrollback grande, pero tmux añade su propio
historial de 1.000.000 de líneas.

### 8.1 Concepto de prefijo

El prefijo es Ctrl-A. La mayoría de acciones se ejecuta pulsando Ctrl-A y luego la tecla
indicada.

### 8.2 Ventanas y paneles

| Teclas | Acción |
|---|---|
| Ctrl-A C | Nueva ventana en la ruta actual. |
| Ctrl-A H | Ventana anterior. |
| Ctrl-A L | Ventana siguiente. |
| Ctrl-A R | Recargar tmux.conf. |
| Ctrl-A S | Elegir sesión. |
| Ctrl-A * | Activar o desactivar sincronización de paneles. |
| Ctrl-A s | Dividir verticalmente. |
| Ctrl-A v | Dividir horizontalmente. |
| Ctrl-A h/j/k/l | Moverse entre paneles. |
| Ctrl-A z | Zoom del panel actual. |

En tmux, “split vertical” describe una línea vertical que separa paneles; la tecla s está
configurada para crear el panel debajo. La tecla v crea el panel a la derecha.

### 8.3 Redimensionar

| Secuencia | Acción |
|---|---|
| Ctrl-A , | Expandir hacia la izquierda 20 columnas. |
| Ctrl-A . | Expandir hacia la derecha 20 columnas. |
| Ctrl-A - | Expandir hacia abajo 7 filas. |
| Ctrl-A = | Expandir hacia arriba 7 filas. |

### 8.4 Leer y seleccionar salida anterior

Para entrar al modo visual de tmux:

~~~text
Ctrl-A [
~~~

Después:

| Tecla | Acción |
|---|---|
| j / k | Bajar o subir una línea. |
| Ctrl-U / Ctrl-D | Subir o bajar media pantalla. |
| PageUp / PageDown | Subir o bajar una pantalla. |
| g | Ir al inicio del historial. |
| G | Ir al final del historial. |
| v | Comenzar selección. |
| Movimiento Vim | Extender la selección. |
| y | Copiar y salir del modo visual. |
| q o Esc | Salir sin copiar. |

Esto resuelve el problema de no poder leer información que quedó arriba: entra con
Ctrl-A [, sube con k o PageUp y selecciona con v/y. El mouse también está habilitado,
por lo que la rueda permite recorrer el historial.

Diferencia clave:

- Zsh bindkey -v: modo normal para editar el comando actual.
- tmux copy-mode: modo visual para recorrer y copiar salida histórica.

### 8.5 Sesiones y plugins

- SessionX se abre con Ctrl-A o; usa zoxide para encontrar sesiones y rutas.
- Resurrect permite guardar y restaurar sesiones y tiene estrategia para Neovim.
- Continuum conserva snapshots, pero la restauración automática está desactivada.
- Floax proporciona una sesión o panel flotante.
- tmux-fzf, tmux-fzf-url y tmux-thumbs agregan selección y navegación interactiva.
- Catppuccin Mocha pinta la barra superior.
- TPM instala los plugins declarados en la parte final de tmux.conf.

Instalar o actualizar plugins:

~~~text
Ctrl-A I
~~~

Recargar después de editar:

~~~text
Ctrl-A R
~~~

## 9. Ghostty

Archivo: ghostty/config.ghostty.

Ghostty proporciona la ventana, fuente y scrollback de la terminal. Está configurado con:

- Tema Craftzdog Neon Night.
- Contraste mínimo 1.15.
- Fuente de 19 puntos.
- Padding horizontal 14 y vertical 12.
- Scrollback de 1.000.000 de líneas.
- Opacidad 0.92 y blur 20.
- Soporte true color.
- Cursor de bloque con parpadeo.
- Copiar al seleccionar.
- Alt de macOS como Alt de terminal.
- Decoración de ventana desactivada.
- Shell /bin/zsh.

Atajos:

| Teclas | Acción |
|---|---|
| Cmd-Shift-R | Recargar la configuración de Ghostty. |
| Cmd-Shift-O | Cambiar opacidad del fondo. |
| Cmd-Alt-Enter | Mostrar u ocultar quick terminal. |

Si cambias el tema desde Fish con theme, Ghostty recibe la actualización. Si no se
refresca de inmediato, usa Cmd-Shift-R.

## 10. Starship: prompt y lectura visual

Archivo: starship.toml.

El prompt tiene tres líneas con más espacio visual:

1. Rama, directorio, estado Git y métricas.
2. Versiones de runtimes, Docker/Kubernetes, duración, jobs y hora.
3. Estado de la última orden y modo de edición: I➜ o N.

Indicadores importantes:

| Indicador | Significado |
|---|---|
| Rama con 🌱 | Rama Git actual. |
| 📝 | Archivos modificados. |
| ➕ | Archivos preparados. |
| 🤷 | Archivos sin seguimiento. |
| ⬆ / ⬇ | Commits por subir o bajar. |
| ✅ | Rama actualizada. |
| 🐳 | Contexto Docker o proyecto Compose. |
| ⛵ | Contexto Kubernetes. |
| 🔥 | Proyecto Firebase. |
| took ... | Comando tardó más de dos segundos. |
| I➜ | Inserción en Zsh. |
| N | Normal en Zsh. |
| I✘ | Último comando terminó con error. |

El directorio se trunca a tres componentes para evitar que una ruta larga pegue todo el
prompt al borde. Los nombres comunes tienen iconos y el relleno usa líneas para separar
visualmente la información.

## 11. LazyGit

Archivo: lazygit/config.yml.

LazyGit usa iconos, árbol de archivos, log de comandos, paginación con delta sin pausa,
actualización automática y editor remoto de Neovim.

Comandos personalizados dentro de LazyGit:

| Contexto | Tecla | Acción |
|---|---|---|
| Files | C | Abrir Commitizen con git cz. |
| Global | F | git fetch --all --prune. |
| Local branches | P | Publicar la rama seleccionada y configurar upstream. |
| Global | O | Abrir el Pull Request actual en el navegador. |
| Global | N | Crear un Pull Request con gh pr create --fill --web. |

Flujo típico:

~~~bash
lazygit
~~~

Dentro de LazyGit revisa los cambios por archivo, prepara sólo los fragmentos necesarios,
usa C para un commit guiado y P para publicar una rama. La confirmación al salir está activa.

## 12. Atuin

Archivo: atuin/config.toml.

La configuración conserva los valores seguros por defecto y establece:

- enter_accept = true: Enter ejecuta; Tab deja el resultado en la línea para editarlo.
- Filtro de secretos habilitado por defecto.
- Historial local y configuración de sincronización gestionados por Atuin.
- Integración con Zsh y Nushell.
- Ctrl-R como búsqueda principal en Zsh.

Comandos:

~~~bash
atuin
atuin search
atuin history list
atuin scripts list
atuin scripts run
atuin sync
atuin login
atuin logout
~~~

Para encontrar una orden usada antes, pulsa Ctrl-R y escribe parte del comando. Usa Tab
si quieres editar el resultado antes de ejecutarlo. No pegues tokens, contraseñas ni claves
en comandos; aunque el filtro ayuda, la práctica segura es no escribir secretos en el
historial.

## 13. Temas

En Fish:

~~~fish
theme dark
theme light
theme auto
theme
~~~

- dark: Craftzdog Neon Night.
- light: Craftzdog Aurora Day.
- auto: tema claro u oscuro según el sistema.

Las abreviaturas dark, light y auto-theme llaman a la misma función. El valor se guarda
como variable universal de Fish para conservar la elección entre sesiones.

## 14. Variables y herramientas de proyecto

La configuración añade al PATH:

- ~/bin.
- ~/.local/bin.
- node_modules/.bin.
- Bun.
- Go.
- Antigravity.
- El binario de Docker Desktop en la configuración local de Fish.
- Rutas de Node y herramientas del sistema en PowerShell.

Comandos de comprobación:

~~~bash
command -v nvim
command -v git
command -v eza
command -v fd
command -v fzf
command -v atuin
command -v mise
command -v zoxide
command -v direnv
echo $PATH
~~~

En Fish, usa:

~~~fish
type -q eza; and echo "eza disponible"
type -q fzf; and echo "fzf disponible"
type -q nvim; and echo "nvim disponible"
string split : $PATH
~~~

## 15. Seguridad de secretos

La variable ROUTELLM_MODEL queda en la configuración compartida, pero la API key debe
vivir únicamente en el archivo local ignorado:

~~~fish
set -gx ROUTELLM_API_KEY YOUR_LOCAL_ROUTELLM_KEY
~~~

Ruta recomendada:

~~~fish
nvim ~/.config/fish/config-local.fish
chmod 600 ~/.config/fish/config-local.fish
~~~

Nunca guardes una clave real en:

- fish/conf.d/*.fish rastreados por Git.
- .zshrc.
- Historial de Atuin.
- Commits.
- Issues o documentación pública.

Una clave que alguna vez se publicó debe revocarse y reemplazarse. Además, borrar el archivo
del estado actual no elimina una clave de los commits antiguos: para hacer público el repositorio
de forma segura hay que rotar la clave y limpiar el historial con una herramienta de reescritura
aprobada, revisando después todos los refs locales y remotos.

Comprobación local sin imprimir valores:

~~~bash
git grep -n -I -E 'API_KEY|TOKEN|SECRET|PASSWORD' -- ':!docs/COMMANDS_MANUAL.md'
git status --short
git diff -- fish/conf.d/routellm.fish
~~~

El resultado debe revisarse manualmente; no compartas la salida si contiene valores secretos.

## 16. Diagnóstico rápido

### La terminal no entra en modo normal con Esc o jj

~~~bash
exec zsh
bindkey -v
bindkey -M viins '^['
bindkey -M viins 'jj'
~~~

Verifica que estás usando Zsh:

~~~bash
echo $SHELL
ps -p $$ -o command=
~~~

Recuerda: después de Esc o jj, debes pulsar i, a, A o I para volver a escribir.

### No puedo modificar el comando después de entrar en modo normal

Eso es el comportamiento esperado de Vim normal. Pulsa i para insertar antes del cursor,
a para después, A para el final o I para el inicio.

### No puedo leer la salida anterior

Si tmux está activo:

~~~text
Ctrl-A [
~~~

Luego usa g, k, PageUp, v y y. Para salir sin seleccionar, Esc.

Si no estás dentro de tmux, usa la rueda o el scrollback de Ghostty. Comprueba tmux con:

~~~bash
echo $TMUX
tmux display-message -p '#{history_limit}'
~~~

### git diff está vacío

~~~bash
git status --short
git diff --cached
git log -1 --oneline
~~~

Puede no haber cambios, o los cambios pueden estar ya en staging. Usa git diff --cached
para el segundo caso.

### git branch parece no mostrar nada

~~~bash
git branch
git branch --show-current
git status --short --branch
~~~

Un repositorio recién inicializado puede no tener commits ni ramas visibles. En un repo con
historial, la rama actual aparece con *.

### La sugerencia se confunde con el texto escrito

Revisa que zsh-autosuggestions esté instalado y que el estilo esté activo:

~~~bash
typeset -p ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE
command -v brew
ls "$(brew --prefix)/share/zsh-autosuggestions"
~~~

El texto sugerido debe verse en azul grisáceo; Ctrl-U lo oculta temporalmente.

### Tmux no aplica los cambios

~~~text
Ctrl-A R
~~~

O desde la shell:

~~~bash
tmux source-file ~/.config/tmux/tmux.conf
tmux show-options -g history-limit
tmux show-window-options -g mode-keys
~~~

### El tema de Ghostty no cambia

~~~fish
theme dark
theme light
theme auto
~~~

Después pulsa Cmd-Shift-R en Ghostty. La función busca primero
~/.config/ghostty/config.ghostty y usa el archivo alternativo sólo como fallback.

## 17. Recetas completas

### Nuevo proyecto frontend

~~~bash
mkcd ~/Developments/acme-dashboard
git init
gsc main
bi
br dev
~~~

Si el proyecto ya existe:

~~~bash
croot
gs
br dev
~~~

### Cambio pequeño con commits limpios

~~~bash
gsw main
gpl
gsc codex/ajuste-prompt
fv
gd
gap
gds
gcm "fix: mejorar lectura del prompt"
gp
~~~

### Revisar una rama antes de unirla

~~~bash
gf
gss
gl
git diff main...HEAD
git log main..HEAD --oneline
~~~

### Integración trunk-based fast-forward

~~~bash
gsw main
gpl
git merge --ff-only codex/ajuste-prompt
gp
~~~

Si --ff-only falla, Git está protegiendo el historial lineal. Detente, actualiza la rama
de trabajo con la estrategia del equipo y revisa los conflictos antes de reintentar.

### Depurar Docker

~~~bash
dco up -d
dps
dco logs -f api
dx api sh
ports
~~~

### Depurar Kubernetes

~~~bash
kubectl config current-context
kgpo
kgd
kl deploy/api
kd pod/api-0
ke pod/api-0 -- sh
~~~

### Encontrar un archivo y editarlo

~~~bash
fv
~~~

### Cambiar al proyecto frecuente

~~~bash
z acme
croot
gs
~~~

### Guardar una orden reutilizable

~~~bash
atuin scripts list
atuin scripts run nombre-del-script
~~~

## 18. Comandos de mantenimiento

### Recargar cada herramienta

~~~bash
exec zsh
~~~

~~~fish
reload-fish
~~~

~~~text
Ctrl-A R
~~~

~~~bash
tmux source-file ~/.config/tmux/tmux.conf
~~~

~~~bash
ghostty +list-themes
~~~

### Auditar configuración efectiva

~~~bash
git status --short --branch
git remote -v
git config --list --show-origin
tmux show-options -g
starship print-config
~~~

### Mantener el repositorio limpio

~~~bash
gs
gd
gds
git diff --check
git ls-files
~~~

Antes de publicar:

~~~bash
git grep -n -I -E 'API_KEY|TOKEN|SECRET|PASSWORD'
git status --short
git log --oneline --decorate -10
~~~

## 19. Tabla de referencia rápida

| Necesidad | Comando o atajo |
|---|---|
| Estado Git compacto | gs |
| Estado Git completo | gss |
| Diferencias sin staging | gd |
| Diferencias en staging | gds |
| Añadir todo | gaa |
| Añadir por fragmentos | gap |
| Commit con mensaje | gcm "mensaje" |
| Rama nueva | gsc nombre |
| Cambiar de rama | gsw nombre |
| Traer referencias | gf |
| Actualizar linealmente | gpl |
| Publicar | gp |
| Historial | gl |
| Lista de ramas | gb |
| Root Git | croot |
| Crear y entrar a directorio | mkcd ruta |
| Buscar directorio | fcd o Ctrl-O en Fish |
| Buscar y editar archivo | fv |
| Historial interactivo | Ctrl-R |
| Modo normal Vim en Zsh | Esc o jj |
| Volver a insertar | i, a, A o I |
| Modo visual de la terminal | Ctrl-A [ |
| Copiar selección tmux | v, movimiento, y |
| Nueva ventana tmux | Ctrl-A C |
| Nuevo panel tmux | Ctrl-A S o Ctrl-A V |
| Cambiar tema | theme dark, theme light, theme auto |
| Recargar Zsh | exec zsh |
| Recargar Fish | reload-fish |
| Recargar tmux | Ctrl-A R |
| Abrir LazyGit | lazygit |

## 20. Principios de uso

1. Mantén g como Git completo y usa atajos sólo para caminos repetitivos.
2. Revisa gd antes de gaa cuando el cambio tenga riesgo.
3. Usa gpl para preservar un historial lineal.
4. Usa ramas cortas y de vida breve siguiendo trunk-based development.
5. Usa tmux copy-mode para salida histórica y Zsh Vim para editar la línea actual.
6. No uses gpf salvo que entiendas la reescritura y hayas verificado el upstream.
7. No uses gcoall ni resets globales sin revisar antes los cambios.
8. Guarda secretos sólo en archivos locales ignorados y rótalos si fueron expuestos.
9. Si un alias deja de funcionar, comprueba la shell activa, recarga la configuración y
   verifica que el binario exista con command -v.
