{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "cramant-laptop-1";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Paris";
  i18n.defaultLocale = "fr_FR.UTF-8";
  console.keyMap = "fr";

  services.xserver = {
    enable = true;
    xkb.layout = "fr";
    displayManager.lightdm.enable = true;
    desktopManager.xfce.enable = true;
  };

  services.displayManager.autoLogin = {
    enable = true;
    user = "vsugot";
  };

  users.users.vsugot = {
    isNormalUser = true;
    description = "Véronique Sugot";
    shell = pkgs.bash;
    extraGroups = [ "wheel" "networkmanager" "video" "audio" ];
    openssh.authorizedKeys.keys = [
      "ecdsa-sha2-nistp521 AAAAE2VjZHNhLXNoYTItbmlzdHA1MjEAAAAIbmlzdHA1MjEAAACFBADHFTa0eudPjpW+lEYMr0Q8ETXLG5jOT+MBMNZogHxKDhg+exu/gB6E6Lc4CxRLIfnyHDWsXKw1JTSpbFkwXatxWQCR4lmDC0kewW6Mp0/I0oVzpco3b8KofK01sKPewYLsgBbyNIxAyFZg6LXsyWmOXM4zIJcsJ0fCY/UVGboO8GSviA== noynto@baldur"
    ];
  };

  environment.systemPackages = with pkgs; [
    git
    brave
    librecad
    rustdesk
    arc-theme
    papirus-icon-theme
  ];

  environment.etc."brave/policies/managed/policy.json".text = builtins.toJSON {
    # Moteur de recherche
    DefaultSearchProviderEnabled   = true;
    DefaultSearchProviderName      = "DuckDuckGo";
    DefaultSearchProviderSearchURL = "https://duckduckgo.com/?q={searchTerms}";
    DefaultSearchProviderSuggestURL = "https://duckduckgo.com/ac/?q={searchTerms}&type=list";

    # Désactiver Rewards et Wallet (crypto)
    BraveRewardsDisabled = true;
    BraveWalletDisabled  = true;

    # Désactiver les fonctions superflues
    MetricsReportingEnabled  = false;
    BackgroundModeEnabled    = false;
    TranslateEnabled         = false;
    SpellCheckServiceEnabled = false;

    # Extensions forcées
    ExtensionInstallForcelist = [
      "nngceckbapebfimnlniiiahkandclblb;https://clients2.google.com/service/update2/crx"
    ];
  };

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  hardware.graphics.enable = true;

  zramSwap.enable = true;
  boot.kernel.sysctl."vm.swappiness" = 10;

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

  services.printing.enable = true;

  services.logind.settings.Login.HandleLidSwitch = "suspend";

  services.earlyoom = {
    enable = true;
    freeMemThreshold = 5;
    freeSwapThreshold = 10;
  };

  services.journald.extraConfig = ''
    SystemMaxUse=200M
    MaxRetentionSec=7day
  '';

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "25.05";
}
