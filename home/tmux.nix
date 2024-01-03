{
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
      set-option -gw xterm-keys on
      bind-key -n C-Tab next-window
      bind-key -n C-S-Tab previous-window
    '';
  };
}
