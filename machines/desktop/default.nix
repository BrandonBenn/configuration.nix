{ lib, inputs, nixpkgs, home-manager, hosts, ...}:
{
  desktop = nixpkgs.lib.nixosSystem {
    modules = [
     ./configuration.nix

      hosts.nixosModule { networking.stevenBlackHosts.enable = true; }

      home-manager.nixosModules.home-manager
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          users.brandon = import ./home.nix;
          extraSpecialArgs = {
            inherit inputs nixpkgs;
          };
        };
      }
    ];
    specialArgs = {
      inherit (nixpkgs) lib;
      inherit inputs nixpkgs home-manager hosts;
    };
  };
}
