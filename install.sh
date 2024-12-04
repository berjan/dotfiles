#!/bin/sh
delete=false
replace=false
install_packages=false

# Enhanced usage
usage() {
    echo "Usage: $0 [-r] [-d] [-p]"
    echo "  -r: replace existing files (create backups)"
    echo "  -d: delete existing files"
    echo "  -p: install system packages"
    exit 1
}

while getopts drp o
do
    case "$o" in
        d) delete=true;;
        r) replace=true;;
        p) install_packages=true;;
        *) usage;;
    esac
done

# Function to install neovim from source
install_neovim_source() {
    echo "Installing Neovim from source..."
    
    # Install build dependencies
    if command -v apt >/dev/null 2>&1; then
        sudo apt-get update
        sudo apt-get install -y ninja-build gettext cmake unzip curl
    elif command -v brew >/dev/null 2>&1; then
        brew install ninja gettext cmake
    else
        echo "Neither apt nor brew found. Please install build dependencies manually."
        return 1
    fi

    # Clone and build neovim
    git clone https://github.com/neovim/neovim
    cd neovim || exit
    git checkout stable
    make CMAKE_BUILD_TYPE=RelWithDebInfo
    sudo make install
    cd ..
    rm -rf neovim
}

# Function to install packages based on OS
install_system_packages() {
    # Check if neovim is installed
    if ! command -v nvim >/dev/null 2>&1; then
        install_neovim_source
    else
        current_version=$(nvim --version | head -n1 | cut -d ' ' -f2)
        echo "Neovim version $current_version is already installed"
    fi

    # Detect OS and install other packages
    if [ "$(uname)" = "Darwin" ]; then
        echo "macOS detected, installing packages with Homebrew..."
        # Check if Homebrew is installed
        if ! command -v brew >/dev/null 2>&1; then
            echo "Installing Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi
        # Install macOS packages
        brew install \
            ripgrep \
            fd \
            fzf \
            tmux \
            python3 \
            node \
            git \
            isort \
            black \
            flake8 \
            mypy \
            llm 
    elif command -v apt >/dev/null 2>&1; then
        echo "Debian/Ubuntu detected, installing packages with apt..."
        sudo apt update
        sudo apt install -y \
            ripgrep \
            fd-find \
            fzf \
            tmux \
            python3-full \
            python3-pip \
            python3-venv \
            nodejs \
            npm \
            git \
            python3-isort \
            black \
            flake8 \
            pipx \
            python3-mypy
        pipx install llm
    else
        echo "Unsupported package manager. Please install packages manually."
        return 1
    fi
}

# Check for .gitmodules and handle submodules only if they exist
if [ -f ".gitmodules" ]; then
    echo "Initializing git submodules..."
    git submodule init || true
    git submodule update || true
fi

# Link function
link() {
    source="$1"
    destination="$2"
    if [ -h "$destination" ]; then
        echo "$destination already linked, not linking."
        return
    elif [ -e "$destination" ]; then
        if [ "$replace" = "true" ]; then
            mv -vi "$destination" "${destination}.bak"
        elif [ "$delete" = "true" ]; then
            rm -vi "$destination"
        fi
    fi
    if [ -e "$destination" ]; then
        echo "$destination already exists, not linking."
    else
        ln -sv "$source" "$destination"
    fi
}

# Dotfile linking
for file in _*; do
    destination="$HOME/$(echo $file | sed 's/^_/./')"
    source=$PWD/$file
    link "$source" "$destination"
done

# Bin directory setup
mkdir -p "$HOME/bin"
for file in bin/*; do
    destination="$HOME/$file"
    source=$PWD/$file
    link "$source" "$destination"
done

# Envs directory setup
mkdir -p "$HOME/envs"
for file in envs/*; do
    destination="$HOME/$file"
    source=$PWD/$file
    link "$source" "$destination"
done

# Additional setup
mkdir -p "$HOME/.config"
mkdir -p "$HOME/.vim/autoload"
ln -sf "$HOME/.mpv" "$HOME/.config/mpv"
ln -sf "$HOME/.vim" "$HOME/.config/nvim"
ln -sf "$HOME/.vimrc" "$HOME/.config/nvim/init.vim"

# Tmux setup
if [ ! -d "$HOME/.tmux/plugins/tundle" ]; then
    git clone --depth=1 https://github.com/javier-lopez/tundle ~/.tmux/plugins/tundle || true
fi

if [ "$TMUX" ]; then
    tmux source-file ~/.tmux.conf
    ~/.tmux/plugins/tundle/scripts/install_plugins.sh
fi

# Handle system package installation if requested
if [ "$install_packages" = "true" ]; then
    install_system_packages
fi
