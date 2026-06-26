{ config, pkgs, ... }:

{
  home.username = "vsugot";
  home.homeDirectory = "/home/vsugot";

  gtk = {
    enable = true;
    theme.name = "Arc";
    iconTheme.name = "Papirus";
  };

  home.stateVersion = "25.05";
}
