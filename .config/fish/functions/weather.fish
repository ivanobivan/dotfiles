function weather
    if test (count $argv) -eq 0
        curl wttr.in/Yaroslavl
        return
    end

    switch $argv[1]
        case 1
            curl wttr.in/58.424516,40.324605
        case '*'
            echo "Unknown option: $argv[1]"
            echo "Use: 1"
    end
end
