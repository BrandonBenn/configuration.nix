{ config, pkgs, ... }:
{
  imports = [
    ../../home/git.nix
    ../../home/shell.nix
  ];

  manual.html.enable = true;
  news.display = "silent";
  programs.home-manager.enable = true;

  home = {
    username = "brandon";
    homeDirectory = "/home/brandon";
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

  programs.tmux = {
    enable = true;
    aggressiveResize = true;
    baseIndex = 1;
    keyMode = "vi";
    shortcut = "a";
    sensibleOnTop = true;
    newSession = true;
    escapeTime = 0;
    terminal = "tmux-256color";
    extraConfig = ''
      set-option -g renumber-windows on
      set-option -g status-style fg=yellow,bg=default
    '';
  };
}
