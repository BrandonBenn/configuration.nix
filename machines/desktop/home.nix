{ config, pkgs, ... }:
{
  imports = [
    ../../home/git.nix
    ../../home/shell.nix
    ../../home/firefox.nix
  ];

  manual.html.enable = true;
  news.display = "silent";
  programs.home-manager.enable = true;

  home = {
    username = "brandon";
    homeDirectory = "/home/brandon";
    stateVersion = "23.11";

    sessionVariables = {
      CC  = ''${pkgs.zig}/bin/zig cc'';
      CXX = ''${pkgs.zig}/bin/zig c++'';
    };
    shellAliases = {
      e = "$EDITOR";
      g = "git";
      rm = ''${pkgs.trash-cli}/bin/trash'';
      T = ''tmux -q has-session && exec tmux attach-session -d || exec tmux new-session -n$USER -s$HOSTNAME'';
      tree = ''${pkgs.eza}/bin/eza --tree'';
    };
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
