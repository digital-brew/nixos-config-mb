#
#  Specific system configuration settings for xps
#
#  flake.nix
#   ├─ ./hosts
#   │   ├─ default.nix
#   │   └─ ./xps
#   │        ├─ default.nix *
#   │        └─ hardware-configuration.nix
#   └─ ./modules
#       └─ ./desktops
#           ├─ hyprland.nix
#           └─ ./virtualisation
#               └─ docker.nix
#

{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/desktops/virtualisation/docker.nix
  ];

  boot = {                                  # Boot Options
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 3;
      };
      efi = {
	canTouchEfiVariables = true;
      };
      timeout = 5;
    };
    kernelPackages = pkgs.linuxPackages_latest;
  };

  hardware.sane = {                         # Scanning
    enable = true;
    extraBackends = [ pkgs.sane-airscan ];
  };

  laptop.enable = true;                     # Laptop Modules
  hyprland.enable = true;                   # Window Manager

  environment = {
    systemPackages = with pkgs; [           # System-Wide Packages
      fprintd               # Fingerprint
      jellyfin-media-player # Media Player
      plex-media-player     # Media Player
      simple-scan           # Scanning
      moonlight-qt          # Remote Streaming
    ];
  };

  services = {
    fprintd = {                             # Fingerprint Unlock
      enable = true;                        # $ sudo fprintd-enroll --finger right-index-finger <user>
      tod = {
        enable = true;
        driver = pkgs.libfprint-2-tod1-goodix;
      };
    };
    logind.extraConfig = ''
      HandlePowerKey=ignore
    '';                                     # Disable short click powerbutton
  };
  # security.pam.services.swaylock.fprintAuth = true; # See hyprland.nix

  programs.light.enable = true;             # Monitor Brightness

  flatpak = {                               # Flatpak Packages (see module options)
    extraPackages = [
      "com.github.tchx84.Flatseal"
    ];
  };
}