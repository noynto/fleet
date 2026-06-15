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
  networking.hostName = "frigg-laptop-1";
  networking.networkmanager.enable = true;

  # Timezone & locale
  time.timeZone = "Europe/Paris";
  i18n.defaultLocale = "fr_FR.UTF-8";

  # Clavier console
  console.keyMap = "fr";

  # Xorg + clavier graphique
  services.xserver = {
    enable = true;
    xkb.layout = "fr";
    displayManager.lightdm.enable = true;
    windowManager.i3.enable = true;
  };

  # Utilisateur
  users.users.noynto = {
    isNormalUser = true;
    shell = pkgs.bash;
    extraGroups = [ "wheel" "networkmanager" "video" "audio" ];
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
  ];

  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  # i3lock — authentification PAM
  security.pam.services.i3lock = {};

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
    alsa.support32Bit = true;
    pulse.enable = true;
  };

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

  # Swap fichier pour l'hibernation (4Go = taille RAM)
  swapDevices = [{
    device = "/swapfile";
    size   = 4096;
  }];

  # Fermeture couvercle → hibernation
  services.logind.settings.Login.HandleLidSwitch = "hibernate";

  # Reprise depuis hibernation
  boot.resumeDevice = "/dev/disk/by-uuid/eb9d1cec-9b90-45fe-9e88-bcc9cbe5e905";
  boot.kernelParams = [ "resume_offset=28905472" ];

  system.stateVersion = "25.05";
}