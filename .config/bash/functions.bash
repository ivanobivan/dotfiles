qq() {
    if [ -z "$1" ]; then
        ls ~/workspace/dotfiles/help/*.md 2>/dev/null | xargs -n1 basename -s .md
        return 1
    fi
    cat ~/workspace/dotfiles/help/"$1".md
}

da() {
    if [ -z "$1" ]; then
        echo "Доступные команды:"
        echo "  path    — показать PATH построчно"
        return 0
    fi

    case "$1" in
    path)
        echo "$PATH" | tr ':' '\n'
        ;;
    *)
        echo "❌ Неизвестная команда: $1"
        return 1
        ;;
    esac
}
