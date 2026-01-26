#==========================================#
#       ☾ Luna Hardware Configuation
#==========================================#

{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];
  
#==========================================#
#           OS File Systems                #
#==========================================#  

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/470c4e8a-39e5-4b22-844d-deaeeb731f89";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/4D37-E946";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };
    
#==========================================#
#          Additional File Systems         #
#==========================================#

  # Linux 250GB SSD
#   fileSystems."/mnt/Linux_250GB_SSD" =
#     { device = "/dev/disk/by-uuid/533ce84b-7642-416c-883e-33d07efb9fae";
#       fsType = "ext4";
#       options = [
# 	"defaults"
# 	"nofail"
#       ];
#     };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.eno1.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp5s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
