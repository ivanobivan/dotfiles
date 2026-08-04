function qq
    set dir ~/workspace/dotfiles/help

    if test (count $argv) -eq 0
        ls $dir/*.md 2>/dev/null | xargs -n1 basename | sed 's/.md$//' | tr '\n' ' '
        echo
        return 1
    end

    set file $dir/$argv[1].md

    if test -f $file
        cat $file
    else
        echo "❌ Нет файла: $argv[1]"
        return 1
    end
end
