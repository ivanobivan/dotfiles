function o
    if test (count $argv) -eq 0
        set job_number 1
    else
        set job_number $argv[1]
    end
    fg %$job_number
end
