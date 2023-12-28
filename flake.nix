{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flatpaks.url = "github:gmodena/nix-flatpak";

    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hosts = {
      url = "github:StevenBlack/hosts";
      flake = false;
    };
  };

  outputs = inputs @ { self, nixpkgs, darwin, home-manager, flatpaks, hosts, ... }:
  {

    nixosConfigurations = (
      import ./machines/desktop {
        inherit (nixpkgs) lib;
        inherit inputs nixpkgs home-manager flatpaks hosts;
      }
    );
  
    darwinConfigurations = (
      import ./machines/macbook {
        inherit (nixpkgs) lib;
        inherit inputs nixpkgs darwin home-manager hosts;
      }
    );
  };
}
