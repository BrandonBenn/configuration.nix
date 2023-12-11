{ lib, inputs, nixpkgs, darwin, home-manager, nur, hosts, ...}:
{
  
  macbook = darwin.lib.darwinSystem {
    modules = [
     ./darwin-configuration.nix

      hosts.nixosModule {
        networking.stevenBlackHosts.enable = true;
      }
    ];
    specialArgs = {
      inherit (nixpkgs) lib;
      inherit inputs nixpkgs darwin home-manager nur hosts;
    };
  };
}
