{ config, pkgs, ... }:

{
  home.username = "noynto";
  home.homeDirectory = "/home/noynto";

  # Git
  programs.git = {
    enable = true;
    userName = "Orion Beauny-Sugot";
    userEmail = "orion-beauny-sugot@ik.me";
  };

  # i3
  xsession.windowManager.i3 = {
    enable = true;
    config = rec {
      modifier = "Mod4";
      terminal = "kitty";
      menu = "rofi -show drun";

      fonts = {
        names = [ "monospace" ];
        size = 10.0;
      };

      startup = [
        { command = "picom --daemon";  notification = false; }
        { command = "nm-applet";       notification = false; }
        { command = "dunst";           notification = false; }
        { command = "${pkgs.feh}/bin/feh --bg-scale ${config.home.homeDirectory}/wallpaper.jpg"; notification = false; }
      ];

      bars = [{
        statusCommand = "${pkgs.i3status}/bin/i3status";
        fonts = { names = [ "monospace" ]; size = 10.0; };
        colors = {
          background = "#1e1e2e";
          statusline = "#cdd6f4";
          separator  = "#585b70";
          focusedWorkspace  = { background = "#89b4fa"; border = "#89b4fa"; text = "#1e1e2e"; };
          activeWorkspace   = { background = "#313244"; border = "#313244"; text = "#cdd6f4"; };
          inactiveWorkspace = { background = "#1e1e2e"; border = "#1e1e2e"; text = "#585b70"; };
          urgentWorkspace   = { background = "#f38ba8"; border = "#f38ba8"; text = "#1e1e2e"; };
        };
      }];

      colors = {
        focused         = { border = "#89b4fa"; background = "#89b4fa"; text = "#1e1e2e"; indicator = "#f5e0dc"; childBorder = "#89b4fa"; };
        unfocused       = { border = "#313244"; background = "#1e1e2e"; text = "#cdd6f4"; indicator = "#313244"; childBorder = "#313244"; };
        focusedInactive = { border = "#313244"; background = "#313244"; text = "#cdd6f4"; indicator = "#313244"; childBorder = "#313244"; };
        urgent          = { border = "#f38ba8"; background = "#f38ba8"; text = "#1e1e2e"; indicator = "#f38ba8"; childBorder = "#f38ba8"; };
      };

      keybindings = {
        # Essentiels
        "${modifier}+Return"      = "exec kitty";
        "${modifier}+d"           = "exec rofi -show drun";
        "${modifier}+Shift+q"     = "kill";
        "${modifier}+Shift+r"     = "restart";
        "${modifier}+Shift+e"     = "exec i3-nagbar -t warning -m 'Quitter i3 ?' -B 'Oui' 'i3-msg exit'";
        "${modifier}+Shift+x"     = "exec i3lock -c 1e1e2e";

        # Focus (vim-style)
        "${modifier}+h" = "focus left";
        "${modifier}+j" = "focus down";
        "${modifier}+k" = "focus up";
        "${modifier}+l" = "focus right";

        # Déplacement
        "${modifier}+Shift+h" = "move left";
        "${modifier}+Shift+j" = "move down";
        "${modifier}+Shift+k" = "move up";
        "${modifier}+Shift+l" = "move right";

        # Layout
        "${modifier}+f"           = "fullscreen toggle";
        "${modifier}+s"           = "layout stacking";
        "${modifier}+w"           = "layout tabbed";
        "${modifier}+e"           = "layout toggle split";
        "${modifier}+b"           = "split h";
        "${modifier}+v"           = "split v";
        "${modifier}+Shift+space" = "floating toggle";
        "${modifier}+space"       = "focus mode_toggle";

        # Workspaces
        "${modifier}+1" = "workspace number 1";
        "${modifier}+2" = "workspace number 2";
        "${modifier}+3" = "workspace number 3";
        "${modifier}+4" = "workspace number 4";
        "${modifier}+5" = "workspace number 5";
        "${modifier}+Shift+1" = "move container to workspace number 1";
        "${modifier}+Shift+2" = "move container to workspace number 2";
        "${modifier}+Shift+3" = "move container to workspace number 3";
        "${modifier}+Shift+4" = "move container to workspace number 4";
        "${modifier}+Shift+5" = "move container to workspace number 5";

        # Touches média
        "XF86AudioRaiseVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ +5%";
        "XF86AudioLowerVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ -5%";
        "XF86AudioMute"        = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";
        "XF86MonBrightnessUp"  = "exec brightnessctl s +10%";
        "XF86MonBrightnessDown" = "exec brightnessctl s 10%-";
      };
    };
  };


  # Lanceur d'applications
  programs.rofi = {
    enable = true;
    terminal = "kitty";
    extraConfig = {
      show-icons = true;
      drun-display-format = "{name}";
    };
    theme = let
      c = config.lib.formats.rasi.mkLiteral;
    in {
      "*" = {
        bg     = c "#1e1e2e";
        fg     = c "#cdd6f4";
        accent = c "#89b4fa";
        urgent = c "#f38ba8";
        background-color = c "transparent";
        text-color       = c "@fg";
      };
      "window" = {
        background-color = c "@bg";
        border           = c "2px solid @accent";
        border-radius    = c "8px";
        padding          = c "12px";
        width            = c "600px";
      };
      "inputbar" = {
        background-color = c "#313244";
        border-radius    = c "6px";
        padding          = c "8px 12px";
        margin           = c "0 0 8px 0";
      };
      "entry" = {
        background-color = c "transparent";
        text-color       = c "@fg";
      };
      "element selected" = {
        background-color = c "@accent";
        text-color       = c "#1e1e2e";
        border-radius    = c "4px";
      };
      "element-text" = {
        background-color = c "transparent";
        text-color       = c "inherit";
      };
    };
  };

  # Barre de statut
  programs.i3status = {
    enable = true;
    general = {
      colors = true;
      interval = 5;
      color_good     = "#a6e3a1";
      color_degraded = "#f9e2af";
      color_bad      = "#f38ba8";
    };
    modules = {
      "wireless _first_" = {
        position = 1;
        settings = {
          format_up   = "W: %essid %ip";
          format_down = "W: off";
        };
      };
      "battery all" = {
        position = 2;
        settings = {
          format      = "Bat: %percentage %remaining";
          status_chr  = "↑";
          status_bat  = "↓";
          status_full = "✓";
        };
      };
      "disk /" = {
        position = 3;
        settings.format = "/ %avail";
      };
      "memory" = {
        position = 4;
        settings = {
          format            = "RAM: %used/%total";
          threshold_degraded = "1G";
        };
      };
      "load" = {
        position = 5;
        settings.format = "CPU: %1min";
      };
      "tztime local" = {
        position = 6;
        settings.format = "%d/%m/%Y %H:%M";
      };
    };
  };

  # Config dunst (démarré par i3)
  xdg.configFile."dunst/dunstrc".text = ''
    [global]
    background = "#1e1e2e"
    foreground = "#cdd6f4"
    frame_color = "#89b4fa"
    font = monospace 10
    corner_radius = 8
    offset = 10x10
    origin = top-right

    [urgency_normal]
    timeout = 5

    [urgency_critical]
    background = "#f38ba8"
    foreground = "#1e1e2e"
    timeout = 0
  '';

  # Config xsettingsd (démarré par i3)
  xdg.configFile."xsettingsd/xsettingsd.conf".text = ''
    Net/ThemeName "Catppuccin-Mocha-Standard-Blue-Dark"
    Net/IconThemeName "Papirus-Dark"
  '';

  # Thème GTK
  gtk = {
    enable = true;
    theme = {
      name    = "Catppuccin-Mocha-Standard-Blue-Dark";
      package = pkgs.catppuccin-gtk;
    };
    iconTheme = {
      name    = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };

  # Terminal Kitty — Catppuccin Mocha
  programs.kitty = {
    enable = true;
    settings = {
      font_size            = "11.0";
      background           = "#1e1e2e";
      foreground           = "#cdd6f4";
      selection_background = "#585b70";
      selection_foreground = "#cdd6f4";
      cursor               = "#f5e0dc";
      color0  = "#45475a"; color8  = "#585b70";
      color1  = "#f38ba8"; color9  = "#f38ba8";
      color2  = "#a6e3a1"; color10 = "#a6e3a1";
      color3  = "#f9e2af"; color11 = "#f9e2af";
      color4  = "#89b4fa"; color12 = "#89b4fa";
      color5  = "#f5c2e7"; color13 = "#f5c2e7";
      color6  = "#94e2d5"; color14 = "#94e2d5";
      color7  = "#bac2de"; color15 = "#a6adc8";
    };
  };

  home.packages = with pkgs; [
    fzf
    ripgrep
    bat
    eza
    feh
    i3lock
    brightnessctl
    networkmanagerapplet
    picom
    dunst
    xsettingsd
  ];

  home.stateVersion = "25.05";
}