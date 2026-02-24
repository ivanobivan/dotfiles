#!/bin/bash

#there are functions for ubuntu
#there is no place for them in init.sh script

install_chrome() {
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
