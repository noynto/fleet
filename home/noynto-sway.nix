{ config, pkgs, ... }:

{
  home.username = "noynto";
  home.homeDirectory = "/home/noynto";

  # Git
  programs.git = {
    enable = true;
    settings.user = {
      name  = "Orion Beauny-Sugot";
      email = "orion-beauny-sugot@ik.me";
    };
  };

  # Sway
  wayland.windowManager.sway = {
    enable = true;
    xwayland = false;
    wrapperFeatures.gtk = true;

    config = rec {
      modifier = "Mod4";
      terminal = "kitty";
      menu = "rofi -show drun -theme ~/.config/rofi/everforest.rasi";

      fonts = {
        names = [ "JetBrainsMono Nerd Font" ];
        size = 10.0;
      };

      gaps = {
        inner = 5;
        outer = 5;
      };

      input = {
        "type:keyboard" = {
          xkb_layout = "fr";
        };
        "type:touchpad" = {
          natural_scroll = "enabled";
          tap = "enabled";
          dwt = "enabled";
        };
      };

      output = {
        "*" = {
          bg = "#2d353b solid_color";
        };
      };

      startup = [
        { command = "waybar"; }
        { command = "mako"; }
        { command = "nm-applet --indicator"; }
      ];

      # Barre native désactivée, waybar la remplace
      bars = [];

      colors = {
        focused         = { border = "#a7c080"; background = "#a7c080"; text = "#2d353b"; indicator = "#83c092"; childBorder = "#a7c080"; };
        unfocused       = { border = "#343f44"; background = "#2d353b"; text = "#d3c6aa"; indicator = "#343f44"; childBorder = "#343f44"; };
        focusedInactive = { border = "#343f44"; background = "#343f44"; text = "#d3c6aa"; indicator = "#343f44"; childBorder = "#343f44"; };
        urgent          = { border = "#e67e80"; background = "#e67e80"; text = "#2d353b"; indicator = "#e67e80"; childBorder = "#e67e80"; };
      };

      keybindings = {
        # Essentiels
        "${modifier}+Return"      = "exec kitty";
        "${modifier}+d"           = "exec rofi -show drun -theme ~/.config/rofi/everforest.rasi";
        "${modifier}+Shift+q"     = "kill";
        "${modifier}+Shift+r"     = "reload";
        "${modifier}+Shift+e"     = "exec swaynag -t warning -m 'Quitter Sway ?' -B 'Oui' 'swaymsg exit'";
        "${modifier}+Shift+x"     = "exec swaylock -c 2d353b";

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


        # Touches média
        "XF86AudioRaiseVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ +5%";
        "XF86AudioLowerVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ -5%";
        "XF86AudioMute"        = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";
        "XF86MonBrightnessUp"  = "exec brightnessctl s +10%";
        "XF86MonBrightnessDown" = "exec brightnessctl s 10%-";
      };
    };

    # --to-code : bind par position physique de touche, indispensable avec xkb_layout fr (AZERTY)
    extraConfig = ''
      bindsym --to-code Mod4+1 workspace number 1
      bindsym --to-code Mod4+2 workspace number 2
      bindsym --to-code Mod4+3 workspace number 3
      bindsym --to-code Mod4+4 workspace number 4
      bindsym --to-code Mod4+5 workspace number 5
      bindsym --to-code Mod4+Shift+1 move container to workspace number 1
      bindsym --to-code Mod4+Shift+2 move container to workspace number 2
      bindsym --to-code Mod4+Shift+3 move container to workspace number 3
      bindsym --to-code Mod4+Shift+4 move container to workspace number 4
      bindsym --to-code Mod4+Shift+5 move container to workspace number 5
    '';
  };

  # Verrouillage d'écran
  programs.swaylock = {
    enable = true;
    settings = {
      color = "2d353b";
      inside-color = "343f44";
      ring-color = "a7c080";
      text-color = "d3c6aa";
      line-color = "2d353b";
      show-failed-attempts = true;
    };
  };

  # Suspend automatique + verrouillage à l'inactivité
  services.swayidle = {
    enable = true;
    events = {
      before-sleep = "swaylock";
    };
    timeouts = [
      { timeout = 300; command = "brightnessctl -s set 10%"; resumeCommand = "brightnessctl -r"; }
      { timeout = 600; command = "swaylock"; }
    ];
  };

  # Waybar
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 32;
        spacing = 4;
        modules-left = [ "sway/workspaces" ];
        modules-center = [ "clock" ];
        modules-right = [ "network" "battery" "memory" "cpu" "disk" "tray" ];

        "sway/workspaces" = {
          format = "{name}";
          disable-scroll = true;
        };

        clock = {
          format = "{:%d/%m/%Y %H:%M}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };

        network = {
          format-wifi = "W: {essid} {ipaddr}";
          format-ethernet = "E: {ipaddr}";
          format-disconnected = "W: off";
        };

        battery = {
          format = "Bat: {capacity}% {time}";
          format-charging = "Bat: {capacity}% ↑";
          format-full = "Bat: ✓";
          states = {
            warning = 30;
            critical = 15;
          };
        };

        memory = {
          format = "RAM: {used:.1f}G/{total:.1f}G";
          interval = 5;
        };

        cpu = {
          format = "CPU: {usage}%";
          interval = 5;
        };

        disk = {
          format = "/: {free}";
          path = "/";
        };

        tray = {
          spacing = 8;
        };
      };
    };

    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font";
        font-size: 13px;
        min-height: 0;
      }

      window#waybar {
        background-color: #2d353b;
        color: #d3c6aa;
        border-bottom: 2px solid #343f44;
      }

      .modules-left, .modules-center, .modules-right {
        padding: 0 8px;
      }

      #workspaces button {
        color: #859289;
        background: transparent;
        padding: 0 8px;
        border: none;
        border-radius: 4px;
      }

      #workspaces button.focused {
        color: #2d353b;
        background: #a7c080;
      }

      #workspaces button:hover {
        background: #343f44;
        color: #d3c6aa;
      }

      #clock, #network, #battery, #memory, #cpu, #disk, #tray {
        padding: 0 12px;
        color: #d3c6aa;
      }

      #battery.warning { color: #dbbc7f; }
      #battery.critical { color: #e67e80; }
      #clock { color: #a7c080; font-weight: bold; }
    '';
  };

  # Mako (notifications)
  services.mako = {
    enable = true;
    backgroundColor = "#2d353b";
    textColor = "#d3c6aa";
    borderColor = "#a7c080";
    borderRadius = 8;
    defaultTimeout = 5000;
    font = "monospace 10";
    extraConfig = ''
      [urgency=critical]
      background-color=#e67e80
      text-color=#2d353b
      default-timeout=0
    '';
  };

  # Lanceur d'applications (build Wayland)
  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    terminal = "kitty";
    extraConfig = {
      show-icons = true;
      drun-display-format = "{name}";
    };
  };

  xdg.configFile."rofi/everforest.rasi".text = ''
    * {
      bg:     #2d353b;
      fg:     #d3c6aa;
      accent: #a7c080;
      background-color: transparent;
      text-color: @fg;
    }
    window {
      background-color: @bg;
      border:           2px;
      border-color:     @accent;
      border-radius:    8px;
      padding:          12px;
      width:            600px;
    }
    inputbar {
      background-color: #343f44;
      border-radius:    6px;
      padding:          8px 12px;
      margin:           0 0 8px 0;
    }
    entry {
      background-color: transparent;
      text-color:       @fg;
    }
    element selected {
      background-color: @accent;
      text-color:       #2d353b;
      border-radius:    4px;
    }
    element-text {
      background-color: transparent;
      text-color:       inherit;
    }
  '';

  # Thème GTK
  xdg.configFile."gtk-3.0/settings.ini".text = ''
    [Settings]
    gtk-icon-theme-name=Papirus-Dark
    gtk-application-prefer-dark-theme=true
  '';
  xdg.configFile."gtk-4.0/settings.ini".text = ''
    [Settings]
    gtk-icon-theme-name=Papirus-Dark
    gtk-application-prefer-dark-theme=true
  '';

  # Terminal Kitty — Everforest Dark
  programs.kitty = {
    enable = true;
    settings = {
      font_family          = "JetBrainsMono Nerd Font";
      font_size            = "11.0";
      background           = "#2d353b";
      foreground           = "#d3c6aa";
      selection_background = "#475258";
      selection_foreground = "#d3c6aa";
      cursor               = "#d3c6aa";
      color0  = "#475258"; color8  = "#4f585e";
      color1  = "#e67e80"; color9  = "#e67e80";
      color2  = "#a7c080"; color10 = "#a7c080";
      color3  = "#dbbc7f"; color11 = "#dbbc7f";
      color4  = "#7fbbb3"; color12 = "#7fbbb3";
      color5  = "#d699b6"; color13 = "#d699b6";
      color6  = "#83c092"; color14 = "#83c092";
      color7  = "#d3c6aa"; color15 = "#d3c6aa";
    };
  };

  programs.btop = {
    enable = true;
    settings = {
      color_theme      = "everforest";
      theme_background = false;
      vim_keys         = true;
    };
  };

  home.packages = with pkgs; [
    fzf
    ripgrep
    bat
    eza
    brightnessctl
    networkmanagerapplet
    wl-clipboard
    grim
    slurp
    papirus-icon-theme
  ];

  home.stateVersion = "26.05";
}
