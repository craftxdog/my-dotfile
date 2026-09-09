function croot --description "cd to the current git repository root"
    set -l root (command git rev-parse --show-toplevel 2>/dev/null)
    if test -z "$root"
        echo "Not inside a git repository."
        return 1
    end

    cd $root
end
