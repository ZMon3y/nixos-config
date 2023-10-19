{
  description = "NixOS configuration with VSCode Insiders";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    vscode-insiders-flake.url = "path:/etc/nixos/vscode-unstable-flake/";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, vscode-insiders-flake, flake-utils }: {
    nixosConfigurations.workstation = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hardware-configuration.nix
        ./configuration.nix
        {
          environment.systemPackages = with nixpkgs.pkgs; [
            vscode-insiders-flake.packages.x86_64-linux.vscode-insider
          ];
        }
      ];
    };
  };
}
