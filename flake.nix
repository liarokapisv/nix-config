{
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    };
    apple-silicon = {
      url = "github:tpwrules/nixos-apple-silicon";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixgl = {
      url = "github:guibou/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      forAllSystems = f: nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
      ]
        (s: f nixpkgs.legacyPackages.${s});

      args = {
        self = self // {
          lib = (pkgs: import ./lib { inherit self; inherit pkgs; });
        };
      };

      packages = p: with p.extend self.overlays.default;
        {
          tslib = callPackage ./packages/tslib.nix { };
          viber = callPackage ./packages/viber { };
          segger-jlink = (callPackage ./packages/segger-jlink { }).override {
            acceptLicense = true;
          };
          widevinecdm-aarch64 = callPackage ./packages/widevinecdm-aarch64 { };
          fex = callPackage ./packages/fex { };
          krun = callPackage ./packages/krun { };
        };

    in
    {
      homeConfigurations = {
        "veritas@manjaro" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          modules = [
            ./homes/veritas-manjaro
          ];
          extraSpecialArgs = args // {
            self = self // { user = "veritas"; };
          };
        };
      };

      nixosConfigurations = {
        "veritas@m1-pro" = nixpkgs.lib.nixosSystem {
          modules = [
            ./hosts/veritas-m1-pro
          ];
          specialArgs = args // {
            self = self // { user = "veritas"; };
          };
        };
      };

      formatter = forAllSystems (pkgs: pkgs.nixpkgs-fmt);

      packages = forAllSystems packages;

      overlays.default =
        final: super: removeAttrs (packages final) [ "default" ] // { };
    };
}
