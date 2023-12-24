{ lib, inputs, nixpkgs, darwin, home-manager, ...}:
{
  macbook = darwin.lib.darwinSystem {
    modules = [
     ./darwin-configuration.nix
      home-manager.darwinModules.home-manager
      {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.brandon = import ./home.nix;
      }
    ];

    specialArgs = {
      inherit (nixpkgs) lib;
      inherit inputs nixpkgs;
    };
  };
}
