#!/bin/bash

GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

FONTS=$HOME/.fonts
DOWNLOAD=$HOME/Downloads
WORKSPACE=$HOME/workspace
CONFIG=$HOME/.config

isArch() {
    [ -f /etc/arch-release ] && return 0
    return 1
}

log_ok() { printf "${GREEN}✔${NC} %s\n" "$1"; }
log_info() { printf "${BLUE}➜${NC} %s\n" "$1"; }
log_warn() { printf "${RED}!${NC} %s\n" "$1"; }

install() {
    local pkg="$1"

    if isArch; then
        log_info "Ensuring $pkg is installed"
        sudo pacman -S --needed --noconfirm "$pkg"
        return
    else
        if dpkg -s "$pkg" >/dev/null 2>&1; then
            log_ok "$pkg already installed"
        else
            log_info "Installing $pkg"
            sudo apt install -y "$pkg"
        fi
    fi
}

install_packages() {

    local packages=(
        # required packages
        vim
        curl
        wget
        tar
        # tree
        unzip
        build-essential
        ripgrep
        fd-find
        eza
        networkmanager
        neovim
        lazygit
        nvm
        kitty
        openssh
        imagemagick

        # usefull/pretty packages
        # neofetch
        fastfetch
        fish
        ranger
        translate-shell
        htop
        cmatrix
        xclip
        pass
        jq

        #awesomewm packages
        awesome

        # i3wm packages
        # i3 polybar i3lock xss-lock rofi feh picom pulsemixer brightnessctl flameshot
    )

    for pkg in "${packages[@]}"; do
        install "$pkg"
    done
}

create_symlinks() {
    local SOURCE="$HOME/workspace/dotfiles"
    local SOURCE_CONFIG="$SOURCE/.config"
    local DEST="$HOME/.config"

    local links=(
        "$SOURCE_CONFIG/kitty:$DEST/kitty"
        "$SOURCE_CONFIG/lazygit:$DEST/lazygit"
        "$SOURCE_CONFIG/nvim:$DEST/nvim"
        "$SOURCE_CONFIG/ranger:$DEST/ranger"
        # "$SOURCE_CONFIG/i3:$DEST/i3"
        "$SOURCE_CONFIG/awesome:$DEST/awesome"
        # "$SOURCE_CONFIG/i3status:$DEST/i3status"
        # "$SOURCE_CONFIG/polybar:$DEST/polybar"
        # "$SOURCE_CONFIG/rofi:$DEST/rofi"
        "$SOURCE_CONFIG/bash:$DEST/bash"
        # "$SOURCE_CONFIG/fish:$DEST/fish"
        # "$SOURCE_CONFIG/waybar:$DEST/waybar"
        # not config files
        "$SOURCE/.bashrc:$HOME/.bashrc"
        "$SOURCE/.inputrc:$HOME/.inputrc"
        "$SOURCE/.xinitrc:$HOME/.xinitrc"
        "$SOURCE/.xprofile:$HOME/.xprofile"
    )

    for pair in "${links[@]}"; do
        local src="${pair%%:*}"
        local dst="${pair##*:}"

        if [ -e "$dst" ] || [ -L "$dst" ]; then
            rm -rf "$dst"
            log_warn "Replaced existing: $dst"
        fi

        ln -sf "$src" "$dst"
        log_info "Symlink: $dst → $src"
    done

}

ensure_fish() {
    local fish_path
    fish_path="$(command -v fish || true)"

    [ -z "$fish_path" ] && return 0
    [ "$SHELL" = "$fish_path" ] && return 0

    log_info "Switching login shell to fish"
    chsh -s "$fish_path"
    log_ok "Shell changed. Log out and log back in."
}

install_chrome() {
    #TODO: add AUR
    if command -v google-chrome >/dev/null 2>&1; then
        log_ok "Google Chrome already installed"
        return
    fi

    log_info "Installing Google Chrome"
    wget -O /tmp/chrome.deb \
        https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo apt install -y /tmp/chrome.deb
    rm /tmp/chrome.deb
}

install_telegram() {
    #TODO: add AUR
    if [ -d /opt/Telegram ]; then
        log_ok "Telegram already installed"
        return
    fi

    log_info "Installing Telegram"
    wget -O /tmp/tg.tar https://telegram.org/dl/desktop/linux
    tar -xf /tmp/tg.tar -C /tmp
    sudo mv /tmp/Telegram /opt/
    rm -rf /tmp/tg.tar
}

install_neovim() {
    log_info "Installing Neovim"
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
    sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
    rm nvim-linux-x86_64.tar.gz
}

install_fonts() {
    log_info "Installing fonts"
    mkdir -p $FONTS
    wget -P $DOWNLOADS -O fonts.tar.xz https://github.com/ryanoasis/nerd-fonts/releases/latest/download/AdwaitaMono.tar.xz
    wget -P $DOWNLOADS -O icons.tar.xz https://github.com/ryanoasis/nerd-fonts/releases/latest/download/NerdFontsSymbolsOnly.tar.xz
    tar -xv --exclude=*.md --exclude=LICENSE -f $DOWNLOADS/fonts.tar.xz -C $FONTS
    tar -xv --exclude=*.md --exclude=LICENSE -f $DOWNLOADS/icons.tar.xz -C $FONTS
    fc-cache -f -v
}

install_lazygit() {
    if command -v lazygit >/dev/null 2>&1; then
        log_ok "Lazygit already installed"
        return
    fi

    log_info "Installing Lazygit"
    local version
    version=$(curl -s https://api.github.com/repos/jesseduffield/lazygit/releases/latest |
        grep -Po '"tag_name": *"v\K[^"]*')

    curl -Lo /tmp/lazygit.tar.gz \
        "https://github.com/jesseduffield/lazygit/releases/download/v${version}/lazygit_${version}_Linux_x86_64.tar.gz"

    tar xf /tmp/lazygit.tar.gz -C /tmp lazygit
    sudo install /tmp/lazygit /usr/local/bin/
    rm -f /tmp/lazygit*
}

install_nvm() {

    if [ -d "$HOME/.nvm" ]; then
        printf "${GREEN}✔${NC} NVM already installed\n"
    else
        printf "${BLUE}➜${NC} Installing NVM\n"
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
        export NVM_DIR="$HOME/.nvm"
        source "$NVM_DIR/nvm.sh"
        nvm install --lts
        npm install -g tree-sitter-cli
    fi
}

install_fnm() {
    if command -v fnm >/dev/null 2>&1; then
        log_ok "fnm already installed"
        return
    fi

    log_info "Installing fnm"
    curl -fsSL https://fnm.vercel.app/install | bash
    log_ok "fnm installed (restart shell required)"
}

install_fzf() {
    if [ -d "$HOME/.fzf" ]; then
        log_ok "fzf already installed"
        return
    fi

    log_info "Installing fzf"
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --all
}

install_kitty() {
    if [ -d "$HOME/.local/kitty.app" ]; then
        printf "${GREEN}✔${NC} Kitty already installed\n"
    else
        printf "${BLUE}➜${NC} Installing Kitty\n"
        mkdir -p ~./local/bin
        curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
        ln -sf ~/.local/kitty.app/bin/kitty ~/.local/kitty.app/bin/kitten ~/.local/bin/
        cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/
        cp ~/.local/kitty.app/share/applications/kitty-open.desktop ~/.local/share/applications/
        sed -i "s|Icon=kitty|Icon=$(readlink -f ~)/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty*.desktop
        sed -i "s|Exec=kitty|Exec=$(readlink -f ~)/.local/kitty.app/bin/kitty|g" ~/.local/share/applications/kitty*.desktop
        echo 'kitty.desktop' >~/.config/xdg-terminals.list
    fi
}

main() {
    echo "====================================="
    echo "===        SYSTEM SETUP START     ==="
    echo "====================================="

    install_packages
    # install_chrome
    # install_telegram
    # install_neovim
    install_fonts
    # install_lazygit
    # install_nvm
    # install_fnm
    # install_fzf
    # install_kitty

    create_symlinks
    # ensure_fish

    echo "====================================="
    echo "===      SYSTEM SETUP DONE        ==="
    echo "====================================="
}

main "$@"
