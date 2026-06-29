#================================#
#       Hardware Configuation
#================================#

{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];
  
#================================#
#           OS File Systems
#================================#

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/21717f3c-418b-4105-a687-8ada718dee95";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/0C9E-DBF4";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/82fbfe57-66fd-48cb-8677-32a0fd8458c6"; }
    ];
    
#================================#
#     Additional File Systems
#================================#
# lsblk -f Find UUID of disk

  # Linux 1TB SSD
  fileSystems."/mnt/1TB_SSD" =
    { device = "/dev/disk/by-uuid/aa1bf740-89c9-4f37-b709-0cab9e4c51ec";
      fsType = "ext4";
      options = [ "nofail" "noatime" ];
    };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
