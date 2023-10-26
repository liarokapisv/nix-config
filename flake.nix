{
  inputs = {
    nixpkgs = {
      url = "github:NixOs/nixpkgs/nixos-unstable";
    };
    nixgl = {
      url = "github:guibou/nixGL";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    stylix = {
      url = "github:danth/stylix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    nur = {
      url = "github:nix-community/NUR";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";

      pkgs = nixpkgs.legacyPackages.${system};

      args = {
        self = self // {
          lib = (pkgs: import ./lib { inherit self; inherit pkgs; });
        };
      };

      packages = p: with p.extend self.overlays.default;
        {
          tslib = callPackage ./packages/tslib.nix { };
          viber = callPackage ./packages/viber { };
          jlink-software-tools = (callPackage ./packages/jlink-software-tools { }).override {
            acceptLicense = true;
          };
        };

    in
    {
      homeConfigurations = {
        "veritas@manjaro" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./homes/veritas_manjaro
          ];
          extraSpecialArgs = args;
        };
      };

      nixosConfigurations = {
        "veritas-hypr@qemu-vm" = nixpkgs.lib.nixosSystem {
          modules = [
            ./hosts/vm/hyprland.nix
          ];
          specialArgs = args;
        };
        "veritas-plasma@qemu-vm" = nixpkgs.lib.nixosSystem {
          modules = [
            ./hosts/vm/plasma.nix
          ];
          specialArgs = args;
        };
      };

      formatter.${system} = pkgs.nixpkgs-fmt;

      devShells.${system} = {
        cpp = pkgs.callPackage ./shells/cpp.nix { };
      };

      packages.${system} = packages pkgs;

      overlays.default =
        final: _: removeAttrs (packages final) [ "default" ];
    };
}
