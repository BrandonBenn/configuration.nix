{ config, pkgs, ... }:

{
  imports = [ ./common.nix ];
  home.username = "brandon";
  home.homeDirectory = "/home/brandon";
  home.stateVersion = "23.05";
  programs.home-manager.enable = true;
}
