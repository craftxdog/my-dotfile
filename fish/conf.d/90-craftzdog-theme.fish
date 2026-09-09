if not set -q CRAFTZDOG_THEME
    set -gx CRAFTZDOG_THEME dark
end

_craftzdog_apply_theme $CRAFTZDOG_THEME
