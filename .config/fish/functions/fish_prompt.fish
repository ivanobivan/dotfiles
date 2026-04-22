function fish_prompt
    set_color cyan
    echo -n (whoami)"@"(hostname | cut -d . -f1)" "

    set_color blue
    echo -n (prompt_pwd)" "

    # git (без ошибок)
    if command git rev-parse --is-inside-work-tree >/dev/null 2>&1
        set branch (command git branch --show-current 2>/dev/null)
        if test -n "$branch"
            set_color yellow
            echo -n " $branch "
        end
    end

    set_color green
    echo -n "❯ "

    set_color normal
end
