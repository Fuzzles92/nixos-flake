#==========================================#
#         Developer Profile
#==========================================#

{ config, pkgs, fresh, ... }:

{
  #--------------------------
  # System Packages
  #--------------------------
  environment.systemPackages = with pkgs; [
    vscodium             # Code Editor
    podman               # Container Engine
    distrobox            # Distro Containers
    distroshelf          # GUI for Distrobox
    fresh.packages.${pkgs.stdenv.hostPlatform.system}.default  # Fresh Editor
  ];

  #--------------------------
  # Enable Applications
  #--------------------------

  programs.git = {
    enable = true;
    config = {
      user.name = "Fuzzles92";
      user.email = "matthewsproston92@gmail.com";
      init.defaultBranch = "main";
    };
  };

  programs.virt-manager.enable = true;
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
  users.groups.libvirtd.members = [ "fuzzles" ];

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  #--------------------------
  # Enable Services
  #--------------------------
  services.teamviewer.enable = true;     # Teamviewer
}
