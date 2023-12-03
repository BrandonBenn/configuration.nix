{ config, pkgs, ... }:

let
  nurpkgs = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") { inherit pkgs; };
  isLinux = builtins.currentSystem == "x86_64-linux";
in

{

  manual.html.enable = true;
  news.display = "silent";
  home.sessionVariables = {
    CC  = ''${pkgs.zig}/bin/zig cc'';
    CXX = ''${pkgs.zig}/bin/zig c++'';
  };

  home.shellAliases = {
    e = "$EDITOR";
    g = "git";
    rm = ''${pkgs.trash-cli}/bin/trash'';
    T = ''tmux -q has-session && exec tmux attach-session -d || exec tmux new-session -n$USER -s$HOSTNAME'';
    tree = ''${pkgs.eza}/bin/eza --tree'';
  };

  programs.gpg.enable = true;
  programs.lazygit.enable = true;
  programs.ripgrep.enable = true;
  programs.lf.enable = true;

  programs.git = {
    enable = true;
    extraConfig = {
      user = {
        email = "me@brandonbenn.xyz";
        name = "Brandon Duval Benn";
      };
      core.editor = "${pkgs.helix}/bin/hx";
      status.short = true;
      pull.rebase = true;
      fetch.prune = true;
      push.default = "current";
      log.abbrevCommit = true;
      format.pretty = "oneline";
      alias = {
        wip = "!git add -A && git commit -m 'WIP'";
        lazy = ''!git add -A && git commit -m "$(git diff --name-status)"'';
        undo = "!git reset HEAD~1 --mixed";
        am = "!git commit --amend";
        sync = "!f() { git fetch --tags && git pull && git push; };f";
        c = let
          scriptPath = builtins.toFile "lazy-commit.sh" ''
          	#!/bin/sh
          	# Add all changes to staging area
          	git add .

          	# Get a list of modified, added, and deleted files
          	modified_files=$(git diff --name-only --cached --diff-filter=M | awk '{printf "%s%s", sep, $1; sep=", "}')
          	added_files=$(git diff --name-only --cached --diff-filter=A | awk '{printf "%s%s", sep, $1; sep=", "}')
          	deleted_files=$(git diff --name-only --cached --diff-filter=D | awk '{printf "%s%s", sep, $1; sep=", "}')

          	# Formulate the commit message
          	commit_message="Auto-commit:"
          	[ -n "$modified_files" ] && commit_message="$commit_message Modified files - $modified_files"
          	[ -n "$added_files" ] && commit_message=", $commit_message Added files - $added_files"
          	[ -n "$deleted_files" ] && commit_message=", $commit_message Deleted files - $deleted_files"
          	# Commit the changes
          	git commit -m "$commit_message"
          	echo "Committed changes."
          '';
          in "!sh ${scriptPath}";
      };
    };
  };

  programs.password-store = {
    enable = true;
    package = pkgs.pass.withExtensions (exts: [ exts.pass-genphrase exts.pass-otp ]);
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
    prefix = "C-a";
    sensibleOnTop = true;
    newSession = true;
    escapeTime = 0;
    terminal = "tmux-256color";
    extraConfig = ''
      set-option -g renumber-windows on
      set-option -g status-style fg=yellow,bg=default
    '';
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

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    enableVteIntegration = true;
    defaultKeymap = "emacs";
  };

  programs.starship = {
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

  programs.firefox = {
    enable = isLinux;
    package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
        extraPolicies = {
            CaptivePortal = false;
            DisableFirefoxStudies = true;
            DisablePocket = true;
            DisableTelemetry = true;
            DisableFirefoxAccounts = true;
            NoDefaultBookmarks = true;
            OfferToSaveLogins = false;
            OfferToSaveLoginsDefault = false;
            PasswordManagerEnabled = false;
            FirefoxHome = {
                Search = false;
                Pocket = false;
                Snippets = false;
                TopSites = false;
                Highlights = false;
            };
            UserMessaging = {
                ExtensionRecommendations = false;
                SkipOnboarding = true;
            };
        };
    };
    profiles.brandon.isDefault = true;
    profiles.brandon.extensions = with nurpkgs.repos.rycee.firefox-addons; [
      bitwarden
      temporary-containers
      tridactyl
      ublock-origin
      i-dont-care-about-cookies
      (let version = "5.14.1";
        in buildFirefoxXpiAddon {
          pname = "zhongwen";
          inherit version;
          addonId = "{37ca1113-06b9-4aa3-9603-049a0534da38}";
          url = "https://addons.mozilla.org/firefox/downloads/file/4060172/zhongwen-${version}.xpi";
          sha256 = "sha256-EIo1gEC/sJa2ADN/ZpnUbOf0jy+I9Rvn6L09MIxZxws=";
          meta = {};
      })
    ];
    profiles.brandon.settings = {
      "extensions.pocket.enabled" = false;
      "browser.tabs.firefox-view" = false;
      "browser.tabs.firefox-view-next" = false;
      "browser.toolbars.bookmarks.visibility" = "never";
      "browser.startup.homepage" = "about:blank";
    };
  };
}
