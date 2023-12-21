{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flatpaks.url = "github:GermanBread/declarative-flatpak/stable";

    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ { self, nixpkgs, darwin, home-manager, flatpaks, ... }:
  {

    nixosConfigurations = (
      import ./machines/desktop {
        inherit (nixpkgs) lib;
        inherit inputs nixpkgs home-manager flatpaks;
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
