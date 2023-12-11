{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
    hosts.url = "github:StevenBlack/hosts";

    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ { self, nixpkgs, darwin, home-manager, nur, hosts, ... }:
  {

    nixosConfigurations = (
      import ./machines/desktop {
        inherit (nixpkgs) lib;
        inherit inputs nixpkgs home-manager nur hosts;
      }
    );
  
    # darwinConfigurations = (
    #   import ./machines/macbook {
    #     inherit (nixpkgs) lib;
    #     inherit inputs nixpkgs darwin home-manager nur;
    #   }
    # );

    # homeConfigurations = (
    #   import ./home-manager/home.nix {
    #     inherit (nixpkgs) lib;
    #     inherit inputs nixpkgs home-manager nur;
    #   }
    # );
  };
}
