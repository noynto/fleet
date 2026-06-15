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
      # ajouter ta clé publique ici : ssh-ed25519 AAAA...
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

  # SSH
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  # Audio — PipeWire
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Performance
  powerManagement.cpuFreqGovernor = "schedutil";
  services.fstrim.enable = true;   # trim SSD périodiquement
  zramSwap.enable = true;          # swap compressé en RAM, évite le disque
  boot.kernel.sysctl."vm.swappiness" = 10;

  system.stateVersion = "25.05";
}