{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_6_8;
  };

  networking = {
    hostName = "nixos"; # Define your hostname.
    networkmanager.enable = true;
  };

  time.timeZone = "Europe/Kyiv";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "uk_UA.UTF-8";
      LC_IDENTIFICATION = "uk_UA.UTF-8";
      LC_MEASUREMENT = "uk_UA.UTF-8";
      LC_MONETARY = "uk_UA.UTF-8";
      LC_NAME = "uk_UA.UTF-8";
      LC_NUMERIC = "uk_UA.UTF-8";
      LC_PAPER = "uk_UA.UTF-8";
      LC_TELEPHONE = "uk_UA.UTF-8";
      LC_TIME = "uk_UA.UTF-8";
    };
  };

  services = {
    xserver = {
      enable = true;
      # Enable the GNOME Desktop Environment.
      displayManager = {
        gdm = {
          enable = true;
          wayland = true;
        };
      };
      desktopManager.gnome.enable = true;

      # Enable nvidia drivers
      videoDrivers = [ "nvidia" ]; # or "nvidiaLegacy470 etc.
    };
    printing.enable = true;
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      jack.enable = true;
    };
    flatpak = {
      enable = true;
      update.auto = {
        enable = true;
        onCalendar = "monthly"; # Default value
      };
      overrides = {
        global = {
          # Force Wayland by default
          Context.sockets = [ "wayland" "!x11" "!fallback-x11" ];

          Environment = {
            # Fix un-themed cursor in some Wayland apps
            XCURSOR_PATH = "/run/host/user-share/icons:/run/host/share/icons";

            # Force correct theme for some GTK apps
            GTK_THEME = "Adwaita:dark";
          };
        };
      };
      packages = [
        "net.xmind.XMind"
        "com.github.tchx84.Flatseal"
        "io.github.peazip.PeaZip"
        "org.qbittorrent.qBittorrent"
        "org.telegram.desktop"
        "com.dec05eba.gpu_screen_recorder"
        "com.usebottles.bottles"
        "io.lmms.LMMS"
        "org.ardour.Ardour"
      ];
    };
  };

  # Enable sound with pipewire.
  sound.enable = true;

  security.rtkit.enable = true;

  users.users.sas = {
    isNormalUser = true;
    description = "sas";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
  };

  systemd.services = {
    "getty@tty1".enable = false;
    "autovt@tty1".enable = false;
  };

  nixpkgs.config = {
    allowUnfree = true;
    nvidia.acceptLicense = true;
  };

  hardware = {
    pulseaudio.enable = false;

    # Enable OpenGL
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
    nvidia = {
      modesetting.enable = true;
      powerManagement = {
        enable = false;
        finegrained = false;
      };
      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      prime = {
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
  };

  programs = {
    steam = {
      enable = true;
      gamescopeSession.enable = true;
    };
    gamemode.enable = true;
  };

  virtualisation.docker.enable = true;

  environment = {
    sessionVariables.NIXOS_OZONE_WL = "1";
    systemPackages = with pkgs; [
      neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
      neofetch
      nodejs_20
      python3
      google-chrome
      opera # Browser with VPN
      vscode-fhs
      vscodium-fhs
      lutris
      mangohud
      wineWow64Packages.unstableFull
      appimage-run
      lshw
      obsidian
      rclone
      unzip
      zulu17
      vlc
      rustdesk-flutter
      (pkgs.callPackage (import ./bun-baseline.nix) { })
      obs-studio
      rustup
      steamPackages.steamcmd
      godot_4
      nixpkgs-fmt
      sqlite
      gcc
      thunderbird
      stremio
      pkgsi686Linux.gperftools
      logseq
      wl-clipboard
      spotube
      firefox
      ungoogled-chromium
      bitwarden
      brave
      localsend
      bisq-desktop
      kdePackages.kdenlive
      bitwig-studio
    ];
  };

  fonts.packages = with pkgs; [
    fira-code-nerdfont
  ];

  nix = {
    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    settings.experimental-features = [ "nix-command" "flakes" ];
  };
  system.stateVersion = "23.05";
}
