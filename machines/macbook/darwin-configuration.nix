{ config, pkgs, ... }:

{
  nix.gc.automatic = true;
  nix.settings.experimental-features = "nix-command flakes";
  nixpkgs.config.allowUnfree = true;

  networking.hostName = "macbook";
  environment.systemPackages = with pkgs; [
   ngrok
   gnupg
  ];

  environment.etc.hosts.text = let
    blockedHosts = builtins.fetchurl "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts";
    blockedHostsFile = builtins.readFile blockedHosts;
    hosts = [
     "127.0.0.1   dev.services.faria.org"
     "127.0.0.1   local-community.faria.org"
     "127.0.0.1   local-certification.faria.org"
     blockedHostsFile
    ];
    in builtins.concatStringsSep "\n" hosts;

  environment.shellInit = ''
    eval $(/opt/homebrew/bin/brew shellenv)
  '';
  
  programs.zsh = {
    enable = true;
    enableCompletion = false;
  };

  homebrew = {
    enable = true;
    brews = [
      "coreutils"
      { name = "libyaml"; link = true; }
      { name = "mysql@8.0"; restart_service = true; }
      { name = "redis"; restart_service = true; }
      { name = "opensearch"; restart_service = true; }
    ];
    taps = [];
    casks = [
      "yattee"
      "maccy"
    ];
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  system.defaults = {
    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      AppleEnableSwipeNavigateWithScrolls = false;
      AppleEnableMouseSwipeNavigateWithScrolls = false;
      # Allow full-OS keyboard control.
      AppleKeyboardUIMode = 3;

      # Disable press-and-hold for keys in favor of key repeat.
      ApplePressAndHoldEnabled = true;

      # Always show file extensions in Finder.
      AppleShowAllExtensions = true;

      # Speed up our key repeat.
      KeyRepeat = 2;
      InitialKeyRepeat = 10;

      # In general, have Apple not mess with our text.
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = null;
      NSAutomaticSpellingCorrectionEnabled = false;

      # Don't automatically terminate inactive apps.
      # NSDisableAutomaticTermination = false;

      # Always start with Save dialog panels expanded.
      NSNavPanelExpandedStateForSaveMode = true;
      NSNavPanelExpandedStateForSaveMode2 = true;
    };

    # More than just the dock configruation; also controls hot corners.
    dock = {
      autohide = true;
      autohide-delay = 0.1;
      launchanim = false;
      mru-spaces = false;
      # Put the dock on the left side of the screen, where we won't have to see it.
      orientation = "left";
      # Disable hot corners.
      wvous-bl-corner = 1;
      wvous-br-corner = 1;
      wvous-tl-corner = 1;
      wvous-tr-corner = 1;
    };

    finder = {
      # Necessary for true finder, instead of Finder embeds.
      AppleShowAllExtensions = true;
      CreateDesktop = false;
      # Search in the current folder, instead of the whole mac.
      FXDefaultSearchScope = "SCcf";
      # Don't warn us on changing a file extension.
      FXEnableExtensionChangeWarning = false;
      # Defeault to the list view in Finder windows.
      FXPreferredViewStyle = "Nlsv";
      # Show the pathbar, which gives us breadcrumbs to the current folder.
      ShowPathbar = true;
      # Show the status bar, which has some useful metadata.
      ShowStatusBar = true;
      # Use the POSIX path in the finder title, rather than just the folder name.
      _FXShowPosixPathInTitle = true;
    };
    loginwindow.GuestEnabled = false;
  };
}
