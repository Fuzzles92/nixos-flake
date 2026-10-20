#--------------------------------#
#       Locale & Keyboard
#--------------------------------#

{ ... }: {
  #--------------------------------#
  #            Timezone
  #--------------------------------#
  time.timeZone = "Europe/London";
  # Select internationalisation properties.
  #--------------------------------#
  #  Language & Regional Formats
  #--------------------------------#
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

  # Configure keymap in X11
  #--------------------------------#
  #        Keyboard Layout
  #--------------------------------#
  services.xserver.xkb = {
    layout = "gb";
    variant = "";
  };

  # Configure console keymap
  #--------------------------------#
  #        Console Keyboard
  #--------------------------------#
  console.keyMap = "uk";


}
