#==========================================#
#         Flatpak Config
#==========================================#

{ pkgs, ... }:

{
  # Enable nix-flatpak service
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

  # Enable automatic Flatpak updates
  services.flatpak.update = {
  auto = {
    enable = true;
    onCalendar = "daily";
  };
  cleanup.enable = true;
  };

}
