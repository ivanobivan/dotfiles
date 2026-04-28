function o
    if test (count $argv) -eq 0
        echo "Usage: o <job_number>"
        return 1
    end
    fg %$argv[1]
end
