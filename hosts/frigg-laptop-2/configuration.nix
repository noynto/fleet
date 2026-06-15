{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "frigg-laptop-2";

  system.stateVersion = "25.05";
}