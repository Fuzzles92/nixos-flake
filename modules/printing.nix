#==========================#
#    Printing & Scanning
#==========================#

{ pkgs, ... }:

{
  #-------------------------
  # CUPS Printing Support
  #-------------------------
  services.printing = {
    enable = true;
    browsing = true;

    drivers = with pkgs; [
      gutenprint
      hplip
      splix
      brlaser

      hplipWithPlugin
      cnijfilter2
      postscript-lexmark
      samsung-unified-linux-driver
      brgenml1lpr
      brgenml1cupswrapper
    ];
  };

  #-------------------------
  # mDNS/Bonjour discovery
  #-------------------------
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  #-------------------------
  # Scanner Support
  #-------------------------
  hardware.sane = {
    enable = true;
  };

  #-------------------------
  # System Applications
  #-------------------------
  environment.systemPackages = with pkgs; [
    simple-scan
  ];
}