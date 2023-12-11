{ lib, inputs, nixpkgs, home-manager, nur, hosts, ...}:
{
  desktop = nixpkgs.lib.nixosSystem {
    modules = [
     ./configuration.nix

      hosts.nixosModule {
        networking.stevenBlackHosts.enable = true;
      }
    ];
    specialArgs = {
      inherit (nixpkgs) lib;
      inherit inputs nixpkgs home-manager nur hosts;
    };
  };
}
