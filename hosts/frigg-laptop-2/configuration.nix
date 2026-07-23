{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Paquets non-libres (brave, zed-editor, claude-code)
  nixpkgs.config.allowUnfree = true;

  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Réseau
  networking.hostName = "frigg-laptop-2";
  networking.networkmanager.enable = true;

  # Timezone & locale
  time.timeZone = "Europe/Paris";
  i18n.defaultLocale = "fr_FR.UTF-8";

  # Clavier console
  console.keyMap = "fr";

  # Display manager
  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --cmd sway --theme \"border=a7c080;text=d3c6aa;prompt=d3c6aa;time=a7c080;action=a7c080;button=a7c080;container=2d353b;input=343f44\"";
      user = "greeter";
    };
  };

  # Sway
  programs.sway = {
    enable = true;
    xwayland.enable = false;
  };

  # Utilisateur
  users.users.noynto = {
    isNormalUser = true;
    shell = pkgs.bash;
    extraGroups = [ "wheel" "networkmanager" "video" "audio" "docker" ];
    openssh.authorizedKeys.keys = [
      "ecdsa-sha2-nistp521 AAAAE2VjZHNhLXNoYTItbmlzdHA1MjEAAAAIbmlzdHA1MjEAAACFBADHFTa0eudPjpW+lEYMr0Q8ETXLG5jOT+MBMNZogHxKDhg+exu/gB6E6Lc4CxRLIfnyHDWsXKw1JTSpbFkwXatxWQCR4lmDC0kewW6Mp0/I0oVzpco3b8KofK01sKPewYLsgBbyNIxAyFZg6LXsyWmOXM4zIJcsJ0fCY/UVGboO8GSviA== noynto@baldur"
    ];
  };

  # Paquets système
  environment.systemPackages = with pkgs; [
    git
    htop
    zed-editor
    claude-code
    brave
    kubectl
    talosctl
    docker-compose
  ];

  # Microcode AMD
  hardware.cpu.amd.updateMicrocode = true;

  # Accélération matérielle GPU AMD Radeon (RADV/Mesa par défaut)
  hardware.graphics.enable = true;

  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  # swaylock — authentification PAM
  security.pam.services.swaylock = {};

  # SSH
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  # Audio — PipeWire
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # Docker
  virtualisation.docker.enable = true;

  # Performance
  services.fstrim.enable = true;
  zramSwap.enable = true;
  boot.kernel.sysctl."vm.swappiness" = 10;

  # TLP — gestion batterie
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC  = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_AC  = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      WIFI_PWR_ON_AC  = "off";
      WIFI_PWR_ON_BAT = "on";
    };
  };

  # Fermeture couvercle → suspend
  services.logind.settings.Login.HandleLidSwitch = "suspend";

  system.stateVersion = "26.05";
}
