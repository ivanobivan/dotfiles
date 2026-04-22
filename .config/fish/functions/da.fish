function da
    if test (count $argv) -eq 0
        echo "Доступные команды:"
        echo "  path    — показать PATH построчно"
        return 0
    end

    switch $argv[1]
        case path
            for p in $PATH
                echo $p
            end
        case '*'
            echo "❌ Неизвестная команда: $argv[1]"
            return 1
    end
end
