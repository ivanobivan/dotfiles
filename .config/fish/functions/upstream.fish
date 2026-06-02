function upstream
    set -l branch (git branch --show-current)
    if test "$branch" = main
        git fetch upstream
        git merge upstream/main
        git push
    else
        git fetch upstream
        git checkout master
        git merge upstream/master
        git push
    end
end
