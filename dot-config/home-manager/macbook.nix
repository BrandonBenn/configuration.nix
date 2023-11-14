{ config, pkgs, ... }:

{
  imports = [ ./common.nix ];
  home.username = "brandon";
  home.homeDirectory = "/Users/brandon";
  home.stateVersion = "23.05";
  programs.home-manager.enable = true;
}
