{ lib, inputs, nixpkgs, home-manager, hosts, ...}:
{
  desktop = nixpkgs.lib.nixosSystem {
    modules = [
     ./configuration.nix

      hosts.nixosModule
      home-manager.nixosModules.home-manager
    ];
    specialArgs = {
      inherit (nixpkgs) lib;
      inherit inputs nixpkgs home-manager;
    };
  };
}
