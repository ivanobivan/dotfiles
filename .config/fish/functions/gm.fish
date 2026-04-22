function gm
    git log -1 --pretty=format:%B | xclip -selection clipboard
end
