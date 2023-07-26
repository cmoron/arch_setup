#!/bin/bash

# Vérifier que le service Docker est en cours d'exécution
if systemctl is-active --quiet docker.service; then
    echo "Docker service is running."
else
    echo "ERROR: Docker service is NOT running. Please start Docker before running this script."
    exit 1
fi

# Supprimer le conteneur existant s'il existe
if docker ps -a --filter name=ansible-test-container | grep -q ansible-test-container; then
    docker rm -f ansible-test-container
fi

# Construire l'image Docker
echo "Building Docker image..."
docker build -t ansible-test .

# Lancer le conteneur Docker
echo "Running Docker container..."
docker run -itd --name ansible-test-container ansible-test

# Exécuter le playbook Ansible pour installer les paquets
echo "Running Ansible playbook to install packages..."
docker exec ansible-test-container ansible-playbook /ansible/install_packages.yml

# Exécuter le playbook Ansible pour appliquer les dotfiles
echo "Running Ansible playbook to apply dotfiles..."
docker exec ansible-test-container ansible-playbook /ansible/apply_dotfiles.yml

# Liste des paquets à vérifier
packages=(
    man-db
    git
    git-lfs
    vim
    gvim
    openssh
    wget
    tree
    which
    networkmanager
    nm-connection-editor
    nfs-utils
    ntfs-3g
    usbutils
    python-pip
    jdk-openjdk
    network-manager-applet
    nvidia
    nvidia-utils
    xorg-server
    xorg-xinit
    xorg-xrandr
    xorg-xdpyinfo
    xorg-xset
    xterm
    picom
    i3-gaps
    i3status
    i3blocks
    dmenu
    sxhkd
    noto-fonts-emoji
    xwallpaper
    python-pywal
    sxiv
    feh
    kitty
    fish
    fzf
    lynx
    firefox
    bluez
    bluez-utils
    pulseaudio
    pulseaudio-alsa
    pulseaudio-bluetooth
    alsa-utils
    avahi
    unzip
    atool
    ranger
    mediainfo
    slock
    zathura
    zathura-pdf-mupdf
    nodejs
    npm
    apache
    libnotify
    dunst
    acpi
    mesa-demos
    nvidia-prime
    docker
    ncdu
    yarn
    httpie
    bash-completion
    cmake
    ripgrep
    gucharmap
    rsync
    neovim
    neofetch
    chrony
)

# Liste des dotfiles à vérifier
dotfiles=(
    .bash_profile
    .config
    .local
    .xprofile
    .bashrc
    .profile
    .xinitrc
)

error=false

# Vérifier l'installation des paquets
for package in "${packages[@]}"; do
    if docker exec ansible-test-container pacman -Q "$package" > /dev/null 2>&1; then
        echo "Package $package is installed."
    else
        echo "ERROR: Package $package is NOT installed."
        error=true
    fi
done

# Vérifier le déploiement des dotfiles
for dotfile in "${dotfiles[@]}"; do
    if docker exec ansible-test-container [ -e "/home/cyril/$dotfile" ]; then
        echo "Dotfile $dotfile exists."
    else
        echo "ERROR: Dotfile $dotfile does NOT exist."
        error=true
    fi
done

if [[ "$error" == true ]]; then
    echo "Errors occurred. Exiting with status 1."
    exit 1
fi
