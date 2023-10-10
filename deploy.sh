# This script is meant to apply these config files to the local machine

cp -f asus-zenbook/configuration.nix /etc/nixos/
cp -f asus-zenbook/flake.nix /etc/nixos/
# These were replaced with pull from https://github.com/iosmanthus/code-insiders-flake
# cp -f asus-zenbook/vscode-unstable-flake.nix /etc/nixos/vscode-unstable-flake/flake.nix
wget -NP /etc/nixos/vscode-unstable-flake/ https://raw.githubusercontent.com/iosmanthus/code-insiders-flake/main/meta.json 
# cp -f asus-zenbook/meta.json /etc/nixos/vscode-unstable-flake/

# nixos-rebuild switch --upgrade
nixos-rebuild switch --flake '/etc/nixos#asus-zenbook'

# hyprland
cp asus-zenbook/.config/hypr/* ~matt/.config/hypr/