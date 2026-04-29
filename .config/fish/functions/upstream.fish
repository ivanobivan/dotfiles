function upstream
    git checkout master
    git fetch upstream
    git merge upstream/master
    git push
end
