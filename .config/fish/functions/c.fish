function c
    if test (count $argv) -gt 0
        set text (string join " " $argv)
    else
        set text (cat)
    end

    if type -q xclip
        printf "%s" $text | xclip -selection clipboard
    else if type -q wl-copy
        printf "%s" $text | wl-copy
    else
        echo "❌ Нет clipboard утилиты (xclip / wl-copy)"
        return 1
    end

    echo "📋 copied: $text"
end
