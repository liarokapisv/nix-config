{
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
    };
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }:
    let
      forAllSystems =
        f: nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-linux" ] (s: f nixpkgs.legacyPackages.${s});

      args = {
        inherit self;
      };

      packages =
        p: with p.extend self.overlays.default; {
          zsh-completion-sync = callPackage ./packages/zsh-completion-sync.nix { };
          erae-lab = callPackage ./packages/erae-lab { };
          librealsense-udev-rules = callPackage ./packages/librealsense-udev-rules.nix { };
          dynamixel2-cli = callPackage ./packages/dynamixel2-cli.nix { };
          dynamixel-wizard-2 = callPackage ./packages/dynamixel-wizard-2 { };
          stremio-linux-shell = callPackage ./packages/stremio-linux-shell.nix { };
        };

    in
    {
      homeConfigurations =
        let
          mkAcumino =
            user:
            home-manager.lib.homeManagerConfiguration {
              pkgs = nixpkgs.legacyPackages.x86_64-linux;
              modules = [ ./homes/alexandros-liarokapis-acumino ];
              extraSpecialArgs = args // {
                self = self // {
                  inherit user;
                };
              };
            };
        in
        {
          "alexandros-liarokapis@acumino" = mkAcumino "alexandros-liarokapis";
          "alex@acumino" = mkAcumino "alex";
        };

      nixosConfigurations = {
        "veritas@framework-13-amd-7840u" = nixpkgs.lib.nixosSystem {
          modules = [
            ./hosts/veritas-framework-13-amd-7840u
          ];
          specialArgs = args // {
            self = self // {
              user = "veritas";
            };
          };
        };
      };

      formatter = forAllSystems (pkgs: pkgs.nixfmt-rfc-style);

      packages = forAllSystems packages;

      overlays.default = nixpkgs.lib.composeManyExtensions [
        (final: super: removeAttrs (packages super) [ "default" ] // { })
        (final: super: {
          pcmanfm = super.pcmanfm.overrideAttrs (old: {
            env.ACLOCAL = "aclocal -I ${super.gettext}/share/gettext/m4";
            passthru.updateScript = super.nix-update-script { };
          });
        })
      ];
    };
}
