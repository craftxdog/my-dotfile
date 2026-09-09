function _craftzdog_set_ghostty_theme --argument-names theme_value --description "Update the Ghostty theme line"
    set -l ghostty_config ~/.config/ghostty/config
    test -f $ghostty_config; or return 0

    set -l tmp (mktemp)
    if command grep -q '^theme = ' $ghostty_config
        string replace -r '^theme = .*$' "theme = $theme_value" < $ghostty_config > $tmp
    else
        printf 'theme = %s\n' $theme_value > $tmp
        command cat $ghostty_config >> $tmp
    end
    command mv $tmp $ghostty_config
end
