# This script is meant to apply these config files to the local machine

cp asus-zenbook/configuration.nix /etc/nixos/
cp asus-zenbook/flake.nix /etc/nixos/
cp asus-zenbook/meta.json /etc/nixos/

nixos-rebuild switch --flake /etc/nixos