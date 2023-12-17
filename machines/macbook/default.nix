{ lib, inputs, nixpkgs, darwin, home-manager, ...}:
{
  macbook = darwin.lib.darwinSystem {
    modules = [
     ./darwin-configuration.nix
    ];

    specialArgs = {
      inherit (nixpkgs) lib;
      inherit inputs nixpkgs darwin home-manager;
    };
  };
}
