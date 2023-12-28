{ lib, inputs, nixpkgs, home-manager, flatpaks, hosts, ...}:
{
  desktop = nixpkgs.lib.nixosSystem {
    modules = [
     ./configuration.nix
      home-manager.nixosModules.home-manager
      flatpaks.nixosModules.nix-flatpak
    ];

    specialArgs = {
      inherit (nixpkgs) lib;
      inherit inputs nixpkgs home-manager hosts;
    };
  };
}
