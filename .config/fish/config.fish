# PATH
fish_add_path /opt/nvim-linux-x86_64/bin
fish_add_path $HOME/.local/bin
fish_add_path $HOME/.local/share/coursier/bin

set -Ux EDITOR nvim
set -Ux VISUAL nvim

set fish_greeting
set -U fish_color_autosuggestion 7f848e

if test -f ~/.config/fish/prop.fish
    source ~/.config/fish/prop.fish
end

# история
bind \cr fzf-history-widget

# принять suggestion по слову
bind \cf forward-word

# принять полностью
bind \e accept-autosuggestion

# переход по папкам
bind \ec fcd

fnm env --use-on-cd | source
fzf --fish | source

cd ~/workspace
