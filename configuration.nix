#==========================================#
#           My Nix Configuation            #
#==========================================#

#==========================================#
#           Nix Useful Commands            #
#==========================================#
#sudo nixos-rebuild switch --upgrade # Upgrade and Switch
#sudo nix-collect-garbage --delete-old # Delete All But Current Image
#sudo nix-env -p /nix/var/nix/profiles/system --list-generations # List Generations

{ config, pkgs, ... }:

#==========================================#
#                Imports                   #
#==========================================#
{
  imports = [
      ./hardware-configuration.nix
      ./boot/lanzaboote.nix
      #./desktops/config-gnome.nix
      ./desktops/config-kde.nix
      #./desktops/config-qtile.nix
    ];
    
#==========================================#
#             Enable Flakes                #
#==========================================#
nix.settings.experimental-features = [ "nix-command" "flakes" ];

#==========================================#
#              Bootloader                  #
#==========================================#
#boot.loader.systemd-boot.enable = true;
boot.loader.efi.canTouchEfiVariables = true;
boot.supportedFilesystems = [ "ntfs" ];

#==========================================#
#      Automatic Updates & Rebuild         #
#==========================================#
#system.autoUpgrade = {
#	enable = true;
#	allowReboot = false;
#	dates = "weekly";
#	operation = "boot";
#	};

#==========================================#
#           System Information             #
#==========================================#
networking.hostName = "Layla";
networking.networkmanager.enable = true;
time.timeZone = "Europe/London";

# Select internationalisation properties.
i18n.defaultLocale = "en_GB.UTF-8";

i18n.extraLocaleSettings = {
  LC_ADDRESS = "en_GB.UTF-8";
  LC_IDENTIFICATION = "en_GB.UTF-8";
  LC_MEASUREMENT = "en_GB.UTF-8";
  LC_MONETARY = "en_GB.UTF-8";
  LC_NAME = "en_GB.UTF-8";
  LC_NUMERIC = "en_GB.UTF-8";
  LC_PAPER = "en_GB.UTF-8";
  LC_TELEPHONE = "en_GB.UTF-8";
  LC_TIME = "en_GB.UTF-8";
};

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "gb";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "uk";

#==========================================#
#         Printing (CUPS & Drivers)        #
#==========================================#
services.printing.enable = true;
services.printing.drivers = [ 
	#pkgs.gutenprint # — Drivers for many different printers from many different vendors.
	#pkgs.gutenprintBin # — Additional, binary-only drivers for some printers.
	pkgs.hplip # — Drivers for HP printers.
	#pkgs.hplipWithPlugin # — Drivers for HP printers, with the proprietary plugin.
	#pkgs.postscript-lexmark # — Postscript drivers for Lexmark
	#pkgs.samsung-unified-linux-driver # — Proprietary Samsung Drivers
	#pkgs.splix # — Drivers for printers supporting SPL (Samsung Printer Language).
	#pkgs.brlaser # — Drivers for some Brother printers
	#pkgs.brgenml1lpr #  — Generic drivers for more Brother printers [1]
	#pkgs.brgenml1cupswrapper  # — Generic drivers for more Brother printers [1]
	#pkgs.cnijfilter2 # — Drivers for some Canon Pixma devices (Proprietary driver)
	]; 
	
#==========================================#
#           Sound (Pipewire)               #
#==========================================#
  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

#==========================================#
#               User Information           #
#==========================================#
# Define a user account. Don't forget to set a password with ‘passwd’.
users.users.fuzzles = {
    isNormalUser = true;
    description = "Fuzzles";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    #vim
    ];
  };

#==========================================#
#           Enable Applications            #
#==========================================#
programs.firefox = {
	enable = true;
};

programs.steam = {
	enable = true;
	remotePlay.openFirewall = true;
	dedicatedServer.openFirewall = true;
	localNetworkGameTransfers.openFirewall = true;
};

programs.git = {
	enable = true;
	config = {
	user.name = "Fuzzles92";
	user.email = "matthewsproston92@gmail.com";
	init.defaultBranch = "master";
	};
};

programs.virt-manager.enable = true;
	virtualisation.libvirtd.enable = true;
	virtualisation.spiceUSBRedirection.enable = true;
	users.groups.libvirtd.members = ["fuzzles"];

virtualisation.podman = {
  		enable = true;
  		dockerCompat = true;
};

#==========================================#
#           Enable Unfree Packages         #
#==========================================#
nixpkgs.config.allowUnfree = true;

#==========================================#
#           System Packages                #
#==========================================#
environment.systemPackages = with pkgs; [
  # Core Applications
	p7zip			          # Port of 7Zip
  niv			            # Easy Dependency Management for Nix Projects
	wget			          # World Wide Web Get
	neofetch		        # CLI Information Tool
	ntfs3g		         	# Open Source Driver for NTFS

  # Main Applications
  thunderbird		      # Email Client
	libreoffice		      # Office Suite
	discord			        # Discord Client
	spotify			        # Spotify Client
	vscode			        # Code Editor
	podman			        # Container Engine
	distrobox		        # Distro Containers
	distroshelf         # GUI For Distrobox
	vlc			            # Media & Video Player
  lutris              # Open Source Gaming Platfrom
	mangohud		        # Overlay
	mangojuice		      # GUI For Mangohud
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

#==========================================#
#           Enable Services                #
#==========================================#
services.teamviewer.enable = true;     # Teamviewer

#==========================================#
#               Flatpak                    #
#==========================================#
#services.flatpak = {
#  enable = true;

#  remotes = [
#    {
#      name = "flathub";
#      location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
#    }
#  ];

#  packages = with pkgs; [
#    "com.github.tchx84.Flatseal"
#    "io.github.flattool.Warehouse"
#  ];

#  update.auto = {
#    enable = true;
#    onCalendar = "weekly"; # Update Weekly
#  };
#};

#==========================================#
#           Garbage Collection             #
#==========================================#
nix.gc = {
	automatic = true;
	dates = "weekly";
	options = "--delete-older-than 10d";
};
  
#==========================================#
#           State Version                  #
#==========================================#
# This value determines the NixOS release from which the default
# settings for stateful data, like file locations and database versions
# on your system were taken. It‘s perfectly fine and recommended to leave
# this value at the release version of the first install of this system.
# Before changing this value read the documentation for this option
# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
system.stateVersion = "25.05"; # Did you read the comment?

}
