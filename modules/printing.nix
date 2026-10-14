#==========================#
#    Printing & Scanning
#==========================#

{ pkgs, ... }:

{
  # Printer Support
  services.printing = {
    enable = true;

    drivers = with pkgs; [
      gutenprint       # Many printer brands and models
      gutenprintBin    # Additional binary-only drivers
      hplip            # HP printers
      brlaser          # Many Brother laser printers
      splix            # Some Samsung laser printers
      epson-escpr      # Some Epson printers
      epson-escpr2     # Newer Epson printers
    ];
  };

  # Driverless USB Printing
  services.ipp-usb.enable = true;

  # Network Printer Discovery
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # Scanner Support
  hardware.sane = {
    enable = true;
    extraBackends = [ pkgs.sane-airscan ]; # Many Network Scanners
  };

  # Scanning application
  environment.systemPackages = [ pkgs.simple-scan ];
}
