# This script is meant to apply these config files to the local machine
myHostname=$(hostname)

# Backup current configuration
cp -f /etc/nixos/configuration.nix /etc/nixos/configuration.nix_bak
# Overwrite with new configuration
cp -f $myHostname/configuration.nix /etc/nixos/
# Copy over the flake files
cp -f flakes/flake.nix /etc/nixos/
# From https://github.com/iosmanthus/code-insiders-flake
cp -f flakes/vscode-unstable-flake.nix /etc/nixos/vscode-unstable-flake/flake.nix
wget -NP /etc/nixos/vscode-unstable-flake/ https://raw.githubusercontent.com/iosmanthus/code-insiders-flake/main/meta.json 

# nixos-rebuild switch --upgrade
nixos-rebuild switch --flake "/etc/nixos#workstation"

# hyprland
cp $myHostname/.config/hypr/* ~matt/.config/hypr/