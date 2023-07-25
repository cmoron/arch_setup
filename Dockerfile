FROM archlinux:latest

# Mettre à jour le système
RUN pacman -Syu --noconfirm

# Installer Ansible sudo et vim
RUN pacman -S ansible git --noconfirm

# Copier les fichiers Ansible dans le conteneur
COPY install_packages.yml /ansible/install_packages.yml
COPY apply_dotfiles.yml /ansible/apply_dotfiles.yml
