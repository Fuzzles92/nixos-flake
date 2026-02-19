#==========================================#
#         Flatpak Config
#==========================================#

{ pkgs, ... }:

{
   #--------------------------
  # Enable Flatpak
  #--------------------------

  services.flatpak.enable = true;

  # Add common remotes
  services.flatpak.remotes = [
    {
      name = "flathub";
      location = "https://flathub.org/repo/flathub.flatpakrepo";
    }
  ];

  # Declarative Flatpak apps
  services.flatpak.packages = [
    "com.github.tchx84.Flatseal"     # Manage Flatpak permissions
    "com.spotify.Client"             # Spotify
  ];

  #--------------------------
  # Automatic Flatpak Updates
  #--------------------------
  services.flatpak.update.onActivation = true;
  services.flatpak.update.auto = {
  enable = true;
  onCalendar = "weekly"; # Default value
  };
}
