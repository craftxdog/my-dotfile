function mkcd --argument-names dir --description "Create a directory and cd into it"
    if test -z "$dir"
        echo "Usage: mkcd <directory>"
        return 1
    end

    mkdir -p -- $dir
    and cd -- $dir
end
