{ config, pkgs, hosts, ... }:

let
  additionalHosts = [
    "127.0.0.1   localhost"
    "127.0.0.1   dev.services.faria.org"
    "127.0.0.1   local-community.faria.org"
    "127.0.0.1   local-certification.faria.org"
  ];
in

{

  nix = {
    gc.automatic = true;
    gc.interval = { Hour = 12; };
    settings.experimental-features = "nix-command flakes";
  };

  nixpkgs = {
    system = "aarch64-darwin";
    config.allowUnfree = true;
  };

  networking.hostName = "macbook";
  users.users.brandon.home = "/Users/brandon";

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableBashCompletion = true;
    enableFzfHistory = true;
    enableFzfGit = true;
    enableFzfCompletion = true;
  };

  environment = {
    systemPackages = with pkgs; [
     ngrok
    ];

    etc.hosts.text = let
      blockHosts = builtins.readFile "${hosts}/hosts";
      allHosts = additionalHosts ++ [blockHosts];
      in builtins.concatStringsSep "\n" allHosts;

    interactiveShellInit = ''
      eval $(/opt/homebrew/bin/brew shellenv)
    '';
  };
  
  homebrew = {
    enable = true;
    onActivation.autoUpdate = true;
    brews = [
      "coreutils"
      { name = "libyaml"; link = true; }
      { name = "mysql@8.0"; restart_service = true; }
      { name = "redis"; restart_service = true; }
      { name = "opensearch"; restart_service = true; }
    ];
    casks = [
      "dmenu-mac"
      "librewolf"
      "google-chrome"
      "iina"
      "logseq"
      "maccy"
      "nightfall"
      "shortcat"
    ];
  };

  system = {
    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    stateVersion = 4;

    defaults = {
      NSGlobalDomain = {
        AppleInterfaceStyle = "Dark";
        AppleEnableSwipeNavigateWithScrolls = false;
        AppleEnableMouseSwipeNavigateWithScrolls = false;
        # Allow full-OS keyboard control.
        AppleKeyboardUIMode = 3;
        _HIHideMenuBar = true;

        # Disable press-and-hold for keys in favor of key repeat.
        ApplePressAndHoldEnabled = false;

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
        autohide-delay = 0.0;
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
        ShowStatusBar = false;
        # Use the POSIX path in the finder title, rather than just the folder name.
        _FXShowPosixPathInTitle = true;
      };
      loginwindow.GuestEnabled = false;
    };
  };

  services = {
    # Auto upgrade nix package and the daemon service.
    nix-daemon.enable = true;

    yabai = {
      enable = true;
      config = {
        layout              = "float";
        top_padding         = 0;
        bottom_padding      = 0;
        left_padding        = 0;
        right_padding       = 0;
        window_gap          = 0;
        mouse_modifier      = "fn";
      };
    };

    skhd = {
      enable = true;
      skhdConfig = ''
        fn - h : ${pkgs.skhd}/bin/skhd -k "left"
        fn - j : ${pkgs.skhd}/bin/skhd -k "down"
        fn - k : ${pkgs.skhd}/bin/skhd -k "up"
        fn - l : ${pkgs.skhd}/bin/skhd -k "right"

        cmd + alt - f : open /Applications/Alacritty.app
        cmd + alt - d : open /Applications/Google\ Chrome.app
        cmd + alt - s : open /Applications/Slack.app
        cmd + alt - a : export MOZ_DISABLE_SAFE_MODE_KEY=1; open /Applications/LibreWolf.app
        cmd - space   : open -n /Applications/dmenu-mac.app

        # Window Position
        shift + alt - up    : yabai -m window --grid 1:1:0:0:1:1 # fill
        shift + alt - left  : yabai -m window --grid 1:2:0:0:1:1 # left
        shift + alt - right : yabai -m window --grid 1:2:1:0:1:1 # right
        shift + alt - down  : yabai -m window --grid 4:4:1:1:2:2 # center

        # cycle through all visible windows sorted by: coordinates -> display index
        alt - tab : yabai -m window --focus "$(yabai -m query --windows --space | ${pkgs.jq}/bin/jq -re "[sort_by(.id, .frame) | reverse | .[] | select(.role == \"AXWindow\" and .subrole == \"AXStandardWindow\") | .id] | nth(index($(yabai -m query --windows --window | ${pkgs.jq}/bin/jq -re ".id")) - 1)")"
        '';
    };
  };
}
