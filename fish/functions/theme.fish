function theme --argument-names mode --description "Switch Fish and Ghostty between light, dark, and auto themes"
    set -l dark_theme '"Craftzdog Neon Night"'
    set -l light_theme '"Craftzdog Aurora Day"'
    set -l auto_theme 'light:Craftzdog Aurora Day,dark:Craftzdog Neon Night'

    if test -z "$mode"
        switch (string lower -- "$CRAFTZDOG_THEME")
            case light day
                set mode dark
            case '*'
                set mode light
        end
    end

    switch (string lower -- "$mode")
        case dark night d
            set -Ux CRAFTZDOG_THEME dark
            _craftzdog_apply_theme dark
            _craftzdog_set_ghostty_theme $dark_theme
            echo "Theme: dark"
        case light day l
            set -Ux CRAFTZDOG_THEME light
            _craftzdog_apply_theme light
            _craftzdog_set_ghostty_theme $light_theme
            echo "Theme: light"
        case auto system a
            set -Ux CRAFTZDOG_THEME auto
            _craftzdog_apply_theme auto
            _craftzdog_set_ghostty_theme $auto_theme
            echo "Theme: auto"
        case '*'
            echo "Usage: theme [dark|light|auto]"
            return 1
    end

    echo "Ghostty: press Cmd+Shift+R if the window does not refresh."
end
