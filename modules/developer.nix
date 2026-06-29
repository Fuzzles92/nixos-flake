#================================#
#         Developer Module
#================================#

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
    fresh-editor         # Terminal Text Editor
    gnome-boxes          # GNOME Virtual Machine 
  ];

  #--------------------------
  # Git
  #--------------------------
  programs.git = {
    enable = true;
    config = {
      user.name = "Fuzzles92";
      user.email = "matthewsproston92@gmail.com";
      init.defaultBranch = "main";
    };
  };

  #--------------------------
  # Virt-Manager
  #--------------------------
  programs.virt-manager.enable = true;
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
  users.groups.libvirtd.members = [ "fuzzles" ];

  #--------------------------
  # Podman
  #--------------------------
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  #--------------------------
  # Teamviewer
  #--------------------------
  services.teamviewer.enable = true;
}
