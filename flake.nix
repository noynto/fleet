{
  description = "Fleet — configurations NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager-stable = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-stable, home-manager, home-manager-stable, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations = {
        frigg-laptop-1 = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/frigg-laptop-1/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.noynto = import ./home/noynto.nix;
            }
          ];
        };

        frigg-laptop-2 = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/frigg-laptop-2/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.noynto = import ./home/noynto.nix;
            }
          ];
        };

        cramant-laptop-1 = nixpkgs-stable.lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/cramant-laptop-1/configuration.nix
            home-manager-stable.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.vsugot = import ./home/vsugot.nix;
            }
          ];
        };
      };
    };
}
