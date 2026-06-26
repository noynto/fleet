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

  xdg.configFile."xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml" = {
    force = true;
    text = ''
      <?xml version="1.0" encoding="UTF-8"?>
      <channel name="xfwm4" version="1.0">
        <property name="general" type="empty">
          <property name="workspace_count" type="int" value="1"/>
        </property>
      </channel>
    '';
  };

  home.stateVersion = "26.05";
}
