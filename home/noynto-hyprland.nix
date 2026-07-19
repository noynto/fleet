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

  # Hyprland
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      monitor = ",preferred,auto,auto";

      env = [
        "XCURSOR_SIZE,24"
        "XDG_CURRENT_DESKTOP,Hyprland"
        "XDG_SESSION_TYPE,wayland"
        "QT_QPA_PLATFORM,wayland"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
      ];

      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "rgb(eba0ac)";
        "col.inactive_border" = "rgb(313244)";
        layout = "dwindle";
      };

      decoration = {
        rounding = 8;
        blur = {
          enabled = true;
          size = 4;
          passes = 2;
        };
        shadow = {
          enabled = true;
          color = "rgb(1e1e2e)";
        };
      };

      animations = {
        enabled = true;
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      input = {
        kb_layout = "fr";
        follow_mouse = 1;
        touchpad = {
          natural_scroll = true;
          disable_while_typing = true;
        };
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      misc = {
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
      };

      "$mod" = "SUPER";

      exec-once = [
        "waybar"
        "mako"
        "nm-applet --indicator"
        "hyprpaper"
      ];

      bind = [
        "$mod, Return, exec, kitty"
        "$mod, D, exec, rofi -show drun -theme ~/.config/rofi/catppuccin-mocha.rasi"
        "$mod, Q, killactive"
        "$mod, F, fullscreen"
        "$mod SHIFT, space, togglefloating"
        "$mod SHIFT, E, exec, hyprctl dispatch exit"
        "$mod SHIFT, X, exec, hyprlock"

        # Focus (vim-style)
        "$mod, H, movefocus, l"
        "$mod, L, movefocus, r"
        "$mod, K, movefocus, u"
        "$mod, J, movefocus, d"

        # Déplacement
        "$mod SHIFT, H, movewindow, l"
        "$mod SHIFT, L, movewindow, r"
        "$mod SHIFT, K, movewindow, u"
        "$mod SHIFT, J, movewindow, d"

        # Workspaces
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
      ];

      bindel = [
        ", XF86AudioRaiseVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ +5%"
        ", XF86AudioLowerVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ -5%"
        ", XF86AudioMute, exec, pactl set-sink-mute @DEFAULT_SINK@ toggle"
        ", XF86MonBrightnessUp, exec, brightnessctl s +10%"
        ", XF86MonBrightnessDown, exec, brightnessctl s 10%-"
      ];
    };
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
        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "clock" ];
        modules-right = [ "network" "battery" "memory" "cpu" "disk" "tray" ];

        "hyprland/workspaces" = {
          format = "{id}";
          on-click = "activate";
          sort-by-number = true;
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
        background-color: #1e1e2e;
        color: #cdd6f4;
        border-bottom: 2px solid #313244;
      }

      .modules-left, .modules-center, .modules-right {
        padding: 0 8px;
      }

      #workspaces button {
        color: #585b70;
        background: transparent;
        padding: 0 8px;
        border: none;
        border-radius: 4px;
      }

      #workspaces button.active {
        color: #1e1e2e;
        background: #eba0ac;
      }

      #workspaces button:hover {
        background: #313244;
        color: #cdd6f4;
      }

      #clock, #network, #battery, #memory, #cpu, #disk, #tray {
        padding: 0 12px;
        color: #cdd6f4;
      }

      #battery.warning { color: #f9e2af; }
      #battery.critical { color: #f38ba8; }
      #clock { color: #eba0ac; font-weight: bold; }
    '';
  };

  # Hyprlock
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        hide_cursor = true;
      };

      background = [{
        monitor = "";
        color = "rgb(1e1e2e)";
      }];

      label = [
        {
          monitor = "";
          text = "cmd[update:1000] echo \"$(date +'%H:%M')\"";
          color = "rgb(cdd6f4)";
          font_size = 72;
          font_family = "JetBrainsMono Nerd Font";
          position = "0, 80";
          halign = "center";
          valign = "center";
        }
        {
          monitor = "";
          text = "cmd[update:60000] echo \"$(date +'%A %d %B %Y')\"";
          color = "rgb(a6adc8)";
          font_size = 18;
          font_family = "JetBrainsMono Nerd Font";
          position = "0, 0";
          halign = "center";
          valign = "center";
        }
      ];

      input-field = [{
        monitor = "";
        size = "250, 50";
        position = "0, -100";
        halign = "center";
        valign = "center";
        dots_center = true;
        fade_on_empty = false;
        font_color = "rgb(cdd6f4)";
        inner_color = "rgb(313244)";
        outer_color = "rgb(eba0ac)";
        outline_thickness = 2;
        placeholder_text = "";
        shadow_passes = 0;
      }];
    };
  };

  # Hypridle
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "hyprlock";
        before_sleep_cmd = "hyprlock";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };

      listener = [
        {
          timeout = 300;
          on-timeout = "brightnessctl -s set 10%";
          on-resume = "brightnessctl -r";
        }
        {
          timeout = 600;
          on-timeout = "hyprlock";
        }
        {
          timeout = 900;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };

  # Mako (notifications)
  services.mako = {
    enable = true;
    backgroundColor = "#1e1e2e";
    textColor = "#cdd6f4";
    borderColor = "#eba0ac";
    borderRadius = 8;
    defaultTimeout = 5000;
    font = "monospace 10";
    extraConfig = ''
      [urgency=critical]
      background-color=#f38ba8
      text-color=#1e1e2e
      default-timeout=0
    '';
  };

  # Lanceur d'applications (build Wayland)
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    terminal = "kitty";
    extraConfig = {
      show-icons = true;
      drun-display-format = "{name}";
    };
  };

  xdg.configFile."rofi/catppuccin-mocha.rasi".text = ''
    * {
      bg:     #1e1e2e;
      fg:     #cdd6f4;
      accent: #eba0ac;
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
      background-color: #313244;
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
      text-color:       #1e1e2e;
      border-radius:    4px;
    }
    element-text {
      background-color: transparent;
      text-color:       inherit;
    }
  '';

  # Fond d'écran (config minimale, à compléter avec un chemin d'image)
  xdg.configFile."hypr/hyprpaper.conf".text = ''
    ipc = off
    splash = false
  '';

  # Thème GTK
  xdg.configFile."gtk-3.0/settings.ini".text = ''
    [Settings]
    gtk-theme-name=Catppuccin-Mocha-Standard-Maroon-Dark
    gtk-icon-theme-name=Papirus-Dark
    gtk-application-prefer-dark-theme=true
  '';
  xdg.configFile."gtk-4.0/settings.ini".text = ''
    [Settings]
    gtk-theme-name=Catppuccin-Mocha-Standard-Maroon-Dark
    gtk-icon-theme-name=Papirus-Dark
    gtk-application-prefer-dark-theme=true
  '';

  # Terminal Kitty — Catppuccin Mocha
  programs.kitty = {
    enable = true;
    settings = {
      font_family          = "JetBrainsMono Nerd Font";
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
      color4  = "#eba0ac"; color12 = "#eba0ac";
      color5  = "#f5c2e7"; color13 = "#f5c2e7";
      color6  = "#94e2d5"; color14 = "#94e2d5";
      color7  = "#bac2de"; color15 = "#a6adc8";
    };
  };

  programs.btop = {
    enable = true;
    settings = {
      color_theme      = "catppuccin_mocha";
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
    hyprpaper
    catppuccin-gtk
    papirus-icon-theme
  ];

  home.stateVersion = "26.05";
}
