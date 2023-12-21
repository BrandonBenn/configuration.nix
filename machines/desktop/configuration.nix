# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, inputs, nixpkgs, home-manager, ... }:
let
  system = "x86_64-linux";
  lib = nixpkgs.lib;
  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };
in
{
  imports = [
   ./hardware-configuration.nix
  ];

  nixpkgs.config.allowUnfree = lib.mkForce true;
  nix = {
    package = pkgs.nixFlakes;
    settings = {
        experimental-features = [ "nix-command" "flakes" ];
        auto-optimise-store = true;
    };
    gc = {
      dates = "weekly";
      automatic = true;
      options = "--delete-older-than 1w";
    };
  };

  system.autoUpgrade = {
    enable = true;
    flags = [ "--update-input" "nixpkgs" "-L" ];
    dates = "02:00";
    randomizedDelaySec = "45min";
  };

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    loader.systemd-boot.configurationLimit = 10;
    initrd.systemd.enable = true;
    plymouth.enable = true;
    kernelParams = [ "quiet" ];
    initrd.luks.devices."luks-28fbb4da-6727-4876-ae9b-c122088c24b5".device = "/dev/disk/by-uuid/28fbb4da-6727-4876-ae9b-c122088c24b5";
  };

  networking = {
    hostName = "desktop";
    networkmanager.enable = true;
    extraHosts = let
      blockHosts = builtins.fetchurl (import ../block-hosts.nix);
    in builtins.readFile "${blockHosts}";
  };
  
  time.timeZone = "Asia/Taipei";
  i18n = {
    # Select internationalisation properties.
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "zh_TW.UTF-8";
      LC_IDENTIFICATION = "zh_TW.UTF-8";
      LC_MEASUREMENT = "zh_TW.UTF-8";
      LC_MONETARY = "zh_TW.UTF-8";
      LC_NAME = "zh_TW.UTF-8";
      LC_NUMERIC = "zh_TW.UTF-8";
      LC_PAPER = "zh_TW.UTF-8";
      LC_TELEPHONE = "zh_TW.UTF-8";
      LC_TIME = "zh_TW.UTF-8";
    };
    inputMethod = {
       enabled = "fcitx5";
       fcitx5.addons = with pkgs; [
          fcitx5-gtk
          fcitx5-chewing
       ];
    };
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.excludePackages = [ pkgs.xterm ];
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl.enable = true;
  hardware.nvidia.modesetting.enable = true;
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Automatic login
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "brandon";
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  #  Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.gnome.core-utilities.enable = false;
  services.gnome.tracker-miners.enable = false;
  services.gnome.tracker.enable = false;
  services.gnome.sushi.enable = true;
  environment.gnome.excludePackages = [ pkgs.gnome-tour ];

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = false;

  # Keyboard
  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = ["*"];
        settings = {
          main = {
            capslock = "overload(control, esc)";
            fn = "layer(fn)";
          };
          fn = {
            "equal" = "volumeup";
            "minus" = "volumedown";
            "0"     = "mute";
          };
        };
      };
    };
  };

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.brandon = {
    isNormalUser = true;
    description = "Brandon Duval Benn";
    extraGroups = [ "networkmanager" "wheel" ];
  };
  security.sudo.wheelNeedsPassword = false;
  users.defaultUserShell = pkgs.zsh;

  environment.variables.EDITOR = "${pkgs.helix}/bin/hx";

  programs = {
    git.enable = true;
    starship.enable = true;

    zsh.enable = true;
    zsh.autosuggestions.enable = true;
    zsh.enableCompletion = true;
    zsh.syntaxHighlighting.enable = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    aria2
    du-dust
    fd
    helix
    htop
    keyd
    ripgrep
    wget
    just
    wl-clipboard

    gnome-console
    gnome.nautilus
    gnome.gnome-tweaks
    gnomeExtensions.appindicator
    gnomeExtensions.clipboard-indicator
    gnomeExtensions.just-perfection
  ];

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      roboto
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      (nerdfonts.override { fonts = [ "SpaceMono" "Iosevka" ]; })
    ];

    fontconfig = {
      defaultFonts = {
        serif = [ "FreeSerif" ];
        sansSerif = [ "Roboto" ];
        monospace = [ "SpaceMono Nerd Font" ];
      };
    };
  };

  # Flatpak
  services.flatpak.enable = true;
  services.flatpak.remotes = {
    "flathub" = "https://dl.flathub.org/repo/flathub.flatpakrepo";
    "flathub-beta" = "https://dl.flathub.org/beta-repo/flathub-beta.flatpakrepo";
  };
  services.flatpak.packages = [
    "flathub:app/org.mozilla.firefox/x86_64/stable"
    "flathub:app/org.mozilla.Thunderbird/x86_64/stable"
    "flathub:app/com.bitwarden.desktop/x86_64/stable"
    "flathub:app/com.github.tchx84.Flatseal/x86_64/stable"
    "flathub:app/io.github.celluloid_player.Celluloid/x86_64/stable"
  ];
  services.flatpak.overrides = {
    "global" = {
      environment = {
        "MOZ_ENABLE_WAYLAND" = 1;
      };
    };
  };
  # Allow flatpak to access system fonts and icons
  system.fsPackages = [ pkgs.bindfs ];
  fileSystems = let
    mkRoSymBind = path: {
      device = path;
      fsType = "fuse.bindfs";
      options = [ "ro" "resolve-symlinks" "x-gvfs-hide" ];
    };
    aggregatedFonts = pkgs.buildEnv {
      name = "system-fonts";
      paths = config.fonts.packages;
      pathsToLink = [ "/share/fonts" ];
    };
  in {
    # Create an FHS mount to support flatpak host icons/fonts
    "/usr/share/icons" = mkRoSymBind (config.system.path + "/share/icons");
    "/usr/share/fonts" = mkRoSymBind (aggregatedFonts + "/share/fonts");
   };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.brandon = import ./home.nix;
    extraSpecialArgs = { inherit inputs nixpkgs; };
  };
  
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
