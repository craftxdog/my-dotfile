function fish_right_prompt --description "Show runtime and clock on the right prompt"
    set -l muted

    switch (string lower -- "$CRAFTZDOG_THEME")
        case light day
            set muted 687083
        case '*'
            set muted 64748b
    end

    set -q CMD_DURATION; or return
    test "$CMD_DURATION" -gt 1000; or return

    set_color $muted
    printf '%s' (math -s1 "$CMD_DURATION / 1000")s
    set_color normal
end
