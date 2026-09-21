function pasti
    set -l filename "image.png"
    if test (count $argv) -gt 0
        set filename $argv[1]

        if not string match -q "*.png" $filename
            set filename "$filename.png"
        end
    end

    xclip -selection clipboard -t image/png -o >$filename

    echo "Image saved as $filename"
end
