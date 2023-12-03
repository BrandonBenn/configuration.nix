{ config, pkgs, ... }:

{
  imports = [ ./common.nix ];
  home = {
    username = "brandon";
    homeDirectory = "/home/brandon";
    stateVersion = "23.05";
    enableNixpkgsReleaseCheck = false;
  };
  programs.home-manager.enable = true;
}
