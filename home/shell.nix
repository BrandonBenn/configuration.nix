{ config, pkgs, ...}:
{
  home = {
    shellAliases = {
      e = "$EDITOR";
      g = "git";
      j = "just";
      rm = ''${pkgs.trash-cli}/bin/trash'';
      T = ''tmux -q has-session && exec tmux attach-session -d || exec tmux new-session -n$USER -s$HOSTNAME'';
      tree = ''${pkgs.eza}/bin/eza --tree'';
    };
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    enableVteIntegration = true;
    defaultKeymap = "emacs";
    initExtra = ''
    setopt interactivecomments
    setopt complete_aliases
    compdef j='just'
    compdef g='git'
    '';
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.eza = {
    enable = true;
    enableAliases = true;
    extraOptions = ["--classify" "--hyperlink"];
  };

  programs.rtx = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
}
