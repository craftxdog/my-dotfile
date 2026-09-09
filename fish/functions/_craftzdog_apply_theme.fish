function _craftzdog_apply_theme --argument-names mode --description "Apply Craftzdog shell colors"
    set -l requested (string lower -- "$mode")
    if contains -- "$requested" auto system
        set requested dark
        if test (uname) = Darwin
            defaults read -g AppleInterfaceStyle >/dev/null 2>&1
            or set requested light
        end
    end

    switch "$requested"
        case light day
            set -g fish_color_normal 202436
            set -g fish_color_command 006dff --bold
            set -g fish_color_keyword 8a3ffc --bold
            set -g fish_color_quote 008f5f
            set -g fish_color_redirection d89216
            set -g fish_color_end d91e5b
            set -g fish_color_error d91e5b --bold
            set -g fish_color_param 202436
            set -g fish_color_option 008fa3
            set -g fish_color_comment 687083 --italics
            set -g fish_color_operator 8a3ffc
            set -g fish_color_escape 008fa3
            set -g fish_color_autosuggestion 5c6f8f --italics
            set -g fish_color_valid_path 00a870 --underline
            set -g fish_color_selection 11131a --background=d8e9ff
            set -g fish_color_search_match 11131a --background=ffe66d
            set -g fish_color_cwd 006dff --bold
            set -g fish_color_cwd_root d91e5b --bold
            set -g fish_color_user 008fa3 --bold
            set -g fish_color_host 8a3ffc
            set -g fish_color_host_remote d91e5b
            set -g fish_color_status d91e5b

            set -g fish_pager_color_progress 008fa3 --bold
            set -g fish_pager_color_prefix 006dff --bold --underline
            set -g fish_pager_color_completion 202436
            set -g fish_pager_color_description 687083 --italics
            set -g fish_pager_color_selected_background --background=d8e9ff
            set -g fish_pager_color_selected_completion 11131a --bold
            set -g fish_pager_color_selected_prefix 006dff --bold --underline
            set -g fish_pager_color_selected_description 8a3ffc --italics
            set -g fish_pager_color_secondary_background --background=f1eadf
            set -g fish_pager_color_secondary_completion 202436
            set -g fish_pager_color_secondary_prefix 008fa3 --bold
            set -g fish_pager_color_secondary_description 687083

            set -gx BAT_THEME "GitHub"
            set -gx EZA_COLORS "fi=38;5;236:di=38;5;33;1:ex=38;5;35;1:ln=38;5;37:sc=38;5;31:bu=38;5;136:cm=38;5;250:tm=38;5;244:uu=38;5;31:gu=38;5;67:sn=38;5;136:sb=38;5;244:da=38;5;68:ur=38;5;31:uw=38;5;161:ux=38;5;35:ue=38;5;35:gr=38;5;31:gw=38;5;161:gx=38;5;35:tr=38;5;31:tw=38;5;161:tx=38;5;35:xx=38;5;244:*.ts=38;5;31:*.tsx=38;5;31:*.js=38;5;136:*.jsx=38;5;136:*.json=38;5;161:*.md=38;5;129:*.lock=38;5;244:*.env=38;5;161"
            set -gx FZF_DEFAULT_OPTS "--height=40% --layout=reverse --border=rounded --info=inline --prompt='> ' --pointer='>' --marker='+' --color=fg:#202436,bg:#fbf7ef,hl:#d91e5b,fg+:#11131a,bg+:#eee7da,hl+:#8a3ffc,info:#008fa3,prompt:#006dff,pointer:#8a3ffc,marker:#00a870,spinner:#d89216,header:#687083,border:#d4ccbe"
        case '*'
            set -g fish_color_normal e6edf3
            set -g fish_color_command 00e5ff --bold
            set -g fish_color_keyword c77dff --bold
            set -g fish_color_quote 37f499
            set -g fish_color_redirection f7c843
            set -g fish_color_end ff5d73
            set -g fish_color_error ff5d73 --bold
            set -g fish_color_param e6edf3
            set -g fish_color_option 5df6ff
            set -g fish_color_comment 64748b --italics
            set -g fish_color_operator c77dff
            set -g fish_color_escape 5df6ff
            set -g fish_color_autosuggestion 8da2b8 --italics
            set -g fish_color_valid_path 37f499 --underline
            set -g fish_color_selection f8fbff --background=263a5f
            set -g fish_color_search_match 0b1020 --background=ffe66d
            set -g fish_color_cwd 00e5ff --bold
            set -g fish_color_cwd_root ff5d73 --bold
            set -g fish_color_user 5df6ff --bold
            set -g fish_color_host c77dff
            set -g fish_color_host_remote ff5d73
            set -g fish_color_status ff5d73

            set -g fish_pager_color_progress 5df6ff --bold
            set -g fish_pager_color_prefix 00e5ff --bold --underline
            set -g fish_pager_color_completion cdd9e5
            set -g fish_pager_color_description 8da2b8 --italics
            set -g fish_pager_color_selected_background --background=263a5f
            set -g fish_pager_color_selected_completion f8fbff --bold
            set -g fish_pager_color_selected_prefix 37f499 --bold --underline
            set -g fish_pager_color_selected_description c77dff --italics
            set -g fish_pager_color_secondary_background --background=111827
            set -g fish_pager_color_secondary_completion b8c7d9
            set -g fish_pager_color_secondary_prefix 5df6ff --bold
            set -g fish_pager_color_secondary_description 6f8197

            set -gx BAT_THEME "TwoDark"
            set -gx EZA_COLORS "fi=38;5;253:di=38;5;39;1:ex=38;5;84;1:ln=38;5;51:sc=38;5;81:bu=38;5;220:cm=38;5;245:tm=38;5;244:uu=38;5;117:gu=38;5;146:sn=38;5;178:sb=38;5;244:da=38;5;75:ur=38;5;81:uw=38;5;203:ux=38;5;84:ue=38;5;84:gr=38;5;81:gw=38;5;203:gx=38;5;84:tr=38;5;81:tw=38;5;203:tx=38;5;84:xx=38;5;59:*.ts=38;5;81:*.tsx=38;5;81:*.js=38;5;220:*.jsx=38;5;220:*.json=38;5;213:*.md=38;5;141:*.lock=38;5;244:*.env=38;5;203"
            set -gx FZF_DEFAULT_OPTS "--height=40% --layout=reverse --border=rounded --info=inline --prompt='> ' --pointer='>' --marker='+' --color=fg:#e6edf3,bg:#0b1020,hl:#ff5d73,fg+:#f8fbff,bg+:#17233a,hl+:#c77dff,info:#5df6ff,prompt:#00e5ff,pointer:#c77dff,marker:#37f499,spinner:#f7c843,header:#64748b,border:#263a5f"
    end
end
