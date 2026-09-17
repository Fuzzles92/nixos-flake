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
  users.groups.libvirtd.members = [ "fuzzles" ];
  virtualisation.spiceUSBRedirection.enable = true;
  systemd.services.libvirt-default-network = {
    description = "Start libvirt default network";
    after = ["libvirtd.service"];
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.libvirt}/bin/virsh net-start default";
      ExecStop = "${pkgs.libvirt}/bin/virsh net-destroy default";
      User = "root";
    };
  };

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
