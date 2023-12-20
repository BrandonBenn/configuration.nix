{ lib, inputs, nixpkgs, home-manager, ...}:
{
  desktop = nixpkgs.lib.nixosSystem {
    modules = [
     ./configuration.nix
      home-manager.nixosModules.home-manager
    ];
    specialArgs = {
      inherit (nixpkgs) lib;
      inherit inputs nixpkgs home-manager;
    };
  };
}
