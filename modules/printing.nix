#==========================================#
#          Printing
#==========================================#

{ pkgs, ... }:

{
  services.printing.enable = true;

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  services.printing.drivers = with pkgs; [
    gutenprint # — Drivers for many different printers from many different vendors.
    hplip # — Drivers for HP printers.
    splix # — Drivers for printers supporting SPL (Samsung Printer Language).
    brlaser # — Drivers for some Brother printers
    #hplipWithPlugin # — Drivers for HP printers, with the proprietary plugin.
    #postscript-lexmark # — Postscript drivers for Lexmark
    #samsung-unified-linux-driver # — Proprietary Samsung Drivers
    #brgenml1lpr #  — Generic drivers for more Brother printers [1]
    #brgenml1cupswrapper  # — Generic drivers for more Brother printers [1]
    #cnijfilter2 # — Drivers for some Canon Pixma devices (Proprietary driver)
  ];
}
