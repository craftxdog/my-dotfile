function fish_prompt --description 'Write out the prompt'
    set -l laststatus $status
    set -l cwd_color
    set -l branch_color
    set -l clean_color
    set -l dirty_color
    set -l bad_color
    set -l muted
    set -l icon_color

    switch (string lower -- "$CRAFTZDOG_THEME")
        case light day
            set cwd_color 006dff
            set branch_color 8a3ffc
            set clean_color 00a870
            set dirty_color d89216
            set bad_color d91e5b
            set muted 687083
            set icon_color 008fa3
        case '*'
            set cwd_color 00e5ff
            set branch_color c77dff
            set clean_color 37f499
            set dirty_color f7c843
            set bad_color ff5d73
            set muted 64748b
            set icon_color 5df6ff
    end

    set -l cwd_icon ""
    if test "$PWD" = "$HOME"
        set cwd_icon ""
    end

    set -l branch
    set -l git_mark
    set -l git_mark_color $clean_color
    if command git rev-parse --is-inside-work-tree >/dev/null 2>&1
        set branch (command git branch --show-current 2>/dev/null)
        test -n "$branch"; or set branch (command git rev-parse --short HEAD 2>/dev/null)
        test -n "$branch"; or set branch detached

        set -l status_lines (command git status --porcelain=v1 2>/dev/null)
        set -l marks
        if string match -qr '^[MADRCU]' -- $status_lines
            set -a marks '+'
            set git_mark_color $clean_color
        end
        if string match -qr '^.[MD]' -- $status_lines
            set -a marks '*'
            set git_mark_color $dirty_color
        end
        if string match -qr '^\?\?' -- $status_lines
            set -a marks '?'
            set git_mark_color $bad_color
        end
        set git_mark (string join '' $marks)
    end

    set -lx fish_prompt_pwd_dir_length 1

    set_color $icon_color
    printf '%s' $cwd_icon
    set_color $cwd_color --bold
    printf '  %s' (prompt_pwd)
    set_color normal

    if test -n "$branch"
        set_color $branch_color
        printf '   %s' $branch
        if test -n "$git_mark"
            set_color $git_mark_color --bold
            printf '%s' $git_mark
        end
        set_color normal
    end

    if test $laststatus -eq 0
        set_color $clean_color --bold
        printf '  ❯ '
        set_color normal
    else
        set_color $bad_color --bold
        printf '  ✘ %s' $laststatus
        set_color $muted
        printf ' '
        set_color $bad_color --bold
        printf '❯ '
        set_color normal
    end
end
