#--------------------------------#
#       Boot Configuration
#--------------------------------#

{ ... }: {
  #--------------------------------#
  #        Bootloader GRUB
  #--------------------------------#
  #boot.loader.grub.enable = true;
  #boot.loader.grub.device = "/dev/vda";
  #boot.loader.grub.useOSProber = true;
  #boot.supportedFilesystems = [ "ntfs" ];

  #--------------------------------#
  #       Bootloader Systemd
  #--------------------------------#
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];
  

}
