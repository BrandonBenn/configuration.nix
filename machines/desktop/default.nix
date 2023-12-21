{ lib, inputs, nixpkgs, home-manager, flatpaks, ...}:
{
  desktop = nixpkgs.lib.nixosSystem {
    modules = [
     ./configuration.nix
      home-manager.nixosModules.home-manager
      flatpaks.nixosModules.default
    ];

    specialArgs = {
      inherit (nixpkgs) lib;
      inherit inputs nixpkgs home-manager;
    };
  };
}
