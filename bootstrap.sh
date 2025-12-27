# ~/dotfiles/bootstrap.sh
#!/bin/bash

set -e

echo "🚀 Setting up Omarchy configuration..."

# Update system
echo "Updating system..."
sudo pacman -Syu --noconfirm

# Install official repo packages
echo "Installing packages from official repos..."
sudo pacman -S --needed --noconfirm $(cat ~/dotfiles/pkglist.txt)

# Install AUR helper if not present (yay example)
if ! command -v yay &> /dev/null; then
    echo "Installing yay..."
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay
    makepkg -si --noconfirm
    cd -
fi

# Install AUR packages
echo "Installing AUR packages..."
yay -S --needed --noconfirm $(cat ~/dotfiles/aurlist.txt)

# Create symlinks
echo "Creating symlinks..."
ln -sf ~/dotfiles/.bashrc ~/.bashrc
ln -sf ~/dotfiles/.zshrc ~/.zshrc
ln -sf ~/dotfiles/.gitconfig ~/.gitconfig
mkdir -p ~/.config
ln -sf ~/dotfiles/nvim ~/.config/nvim

echo "✅ Setup complete!"
