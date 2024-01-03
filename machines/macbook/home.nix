{ config, pkgs, ... }:
{
  imports = [
    ../../home/git.nix
    ../../home/shell.nix
    ../../home/tmux.nix
  ];

  manual.html.enable = true;
  news.display = "silent";
  programs.home-manager.enable = true;

  home = {
    username = "brandon";
    stateVersion = "23.11";
  };
  
  programs = {
    lazygit.enable = true;
    ripgrep.enable = true;
  };

  programs.helix = {
    enable = true;
    defaultEditor = true;
    extraPackages = with pkgs; [
      rubyPackages_3_2.solargraph
    ];
  };
}
