#!/bin/bash

GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

log_ok() { printf "${GREEN}✔${NC} %s\n" "$1"; }
log_info() { printf "${BLUE}➜${NC} %s\n" "$1"; }
log_warn() { printf "${RED}!${NC} %s\n" "$1"; }

install() {
    local pkg="$1"
    log_info "Ensuring $pkg is installed"
    sudo pacman -S --needed --noconfirm "$pkg"
}

install_packages() {

    local packages=(
        # required packages
        vim
        curl
        wget
        tar
        tree
        unzip
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
        lm_sensors
        fzf

        # emoji fonts
        noto-fonts
        noto-fonts-emoji

        #pass packages
        pass
        gnupg

        # usefull/pretty packages
        fastfetch
        fish
        ranger
        translate-shell
        htop
        cmatrix
        xclip
        jq

        #awesomewm packages
        awesome
        rofi
        picom
        xss-lock
        xorg-xset
        brightnessctl

        #lightdm
        lightdm
        lightdm-gtk-greeter
        materia-gtk-theme

    )

    for pkg in "${packages[@]}"; do
        install "$pkg"
    done
}

create_symlinks() {
    local SOURCE="$HOME/workspace/dotfiles"
    local SOURCE_CONFIG="$HOME/workspace/dotfiles/.config"
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
        "$SOURCE_CONFIG/rofi:$DEST/rofi"
        "$SOURCE_CONFIG/bash:$DEST/bash"
        "$SOURCE_CONFIG/picom:$DEST/picom"
        # "$SOURCE_CONFIG/fish:$DEST/fish"

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

install_fonts() {
    log_info "Installing fonts"

    mkdir -p "$HOME/.fonts"
    mkdir -p "$HOME/Downloads"

    wget -O "$HOME/Downloads/fonts.tar.xz" \
        https://github.com/ryanoasis/nerd-fonts/releases/latest/download/AdwaitaMono.tar.xz

    wget -O "$HOME/Downloads/icons.tar.xz" \
        https://github.com/ryanoasis/nerd-fonts/releases/latest/download/NerdFontsSymbolsOnly.tar.xz

    tar -xv --exclude='*.md' --exclude=LICENSE \
        -f "$HOME/Downloads/fonts.tar.xz" -C "$HOME/.fonts"

    tar -xv --exclude='*.md' --exclude=LICENSE \
        -f "$HOME/Downloads/icons.tar.xz" -C "$HOME/.fonts"

    unzip "$HOME/workspace/.fonts/digital-7.zip" \
        -d "$HOME/.fonts" -x '*.txt'

    fc-cache -f -v
}

install_aur() {
    local packages=(
        "https://aur.archlinux.org/google-chrome.git"
        "https://aur.archlinux.org/telegram-desktop-bin.git",
        "https://aur.archlinux.org/i3lock-color.git",
    )

    for pkg in "${packages[@]}"; do
        git clone "$pkg" "$HOME/Downloads/aur-package"
        cd "$HOME/Downloads/aur-package" || continue
        makepkg -si --noconfirm
        cd -
        rm -rf "$HOME/Downloads/aur-package"
    done
}

main() {
    echo "====================================="
    echo "===        SYSTEM SETUP START     ==="
    echo "====================================="

    #install_packages
    #install_aur
    #install_fonts
    #create_symlinks

    echo "====================================="
    echo "===      SYSTEM SETUP DONE        ==="
    echo "====================================="
}

main "$@"
