{ config, pkgs, ... }:

{
  home.username = "vsugot";
  home.homeDirectory = "/home/vsugot";

  gtk = {
    enable = true;
    theme.name = "Arc";
    iconTheme.name = "Papirus";
  };

  xdg.configFile."autostart/xfce4-screensaver.desktop".text = ''
    [Desktop Entry]
    Hidden=true
  '';

  home.stateVersion = "26.05";
}
