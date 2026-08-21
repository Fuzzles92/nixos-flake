#==========================================
#       Qtile Home Manager
#==========================================

{ config, pkgs, ... }:

{
  #--------------------------
  # Qtile Packages
  #--------------------------
  home.packages = with pkgs; [
      lxqt.lxqt-policykit       # LXQT Polkit Agent
      thunar                    # XFCE Thunar File Manager
      thunar-volman             # XFCE Thunar USB & Removeable Media
      exo                       # XFCE helper apps + preferred applications (TerminalEmulator)
      tumbler                   # XFCE Thunar Image/Video Thumbnail Support
      gvfs                      # XFCE Thunar Trash Support,Network Mounts etc
      mousepad                  # XFCE Text Editor
      ristretto                 # XFCE Image Viewer
      networkmanagerapplet      # Network Manager Applet
      pavucontrol               # GUI PulseAudio
      alsa-utils                # Utils for Advanced Linux Sound Architecture
      pamixer                   # Pulseaudio Command Line Mixer
      blueman                   # Bluetooth
      flameshot                 # Screenshot Application
      copyq                     # Clipboard
  ];

  #--------------------------
  # Default Applications
  #--------------------------
  # Required for Thunar "Open Terminal Here" in non-XFCE desktops (Qtile)
  xdg.desktopEntries.alacritty = {
    name = "Alacritty";
    genericName = "Terminal Emulator";
    exec = "alacritty";
    terminal = false;
    categories = [
      "System"
      "TerminalEmulator"
    ];
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/x-terminal-emulator" = [ "alacritty.desktop" ];
    };
  };

  home.file.".config/xfce4/helpers.rc".text = ''
    TerminalEmulator=alacritty
  '';

  #--------------------------
  # Programs
  #--------------------------

  # Rofi
  programs.rofi = {
          enable = true;
          package = pkgs.rofi; #pkgs.rofi-wayland
          theme = ./rofi/catppuccin/catppuccin-default.rasi;

          extraConfig = {
              show-icons = true;
              modi = "drun,run,window";
          };
  };

  xdg.configFile = {
  "rofi/catppuccin-mocha.rasi".source =
    ./rofi/catppuccin/catppuccin-mocha.rasi;
  };

  # Alacritty
  programs.alacritty = {
    enable = true;

    settings = {
      window = {
        opacity = 0.95;
        padding = {
          x = 12;
          y = 12;
        };
      };

      font = {
        size = 12;
      };

      colors = {
        primary = {
          background = "#1e1e2e";
          foreground = "#cdd6f4";
        };

        normal = {
          black   = "#45475a";
          red     = "#f38ba8";
          green   = "#a6e3a1";
          yellow  = "#f9e2af";
          blue    = "#89b4fa";
          magenta = "#cba6f7";
          cyan    = "#94e2d5";
          white   = "#bac2de";
        };

        bright = {
          black   = "#585b70";
          red     = "#f38ba8";
          green   = "#a6e3a1";
          yellow  = "#f9e2af";
          blue    = "#89b4fa";
          magenta = "#cba6f7";
          cyan    = "#94e2d5";
          white   = "#cdd6f4";
        };
      };
    };
   };

  #--------------------------
  # Qtile Configuration
  #--------------------------
   xdg.configFile."qtile" = {
     source = ./qtile;
     recursive = true;
     force = true;
   };
}
