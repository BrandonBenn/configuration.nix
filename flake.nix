{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ { self, nixpkgs, darwin, home-manager, ... }:
  {

    nixosConfigurations = (
      import ./machines/desktop {
        inherit (nixpkgs) lib;
        inherit inputs nixpkgs home-manager;
      }
    );
  
    darwinConfigurations = (
      import ./machines/macbook {
        inherit (nixpkgs) lib;
        inherit inputs nixpkgs darwin home-manager;
      }
    );
  };
}
