{ inputs, ... }:
{
  perSystem =
    {
      pkgs,
      config,
      system,
      lib,
      ...
    }:
    {
      options.nixpkgs = {
        overlays =
          with lib;
          mkOption {
            type = with types; listOf (functionTo (functionTo attrs));
            default = [ ];
          };

        permittedInsecurePackages =
          with lib;
          mkOption {
            type = with types; listOf str;
            default = [ ];
          };
        config = lib.mkOption {
          type = lib.types.attrs;
          default = { };
        };
      };

      config = {
        _module.args.pkgs = import inputs.nixpkgs {
          inherit system;
          config = config.nixpkgs.config;
          overlays = config.nixpkgs.overlays;
        };

        legacyPackages = {
          pkgsBroken = pkgs;
          pkgsWorking = import inputs.nixpkgs {
            inherit system;
            config = {
              allowUnfree = true;
            };
          };
        };

        nixpkgs = {
          config = {
            allowUnfree = true;
            permittedInsecurePackages = config.nixpkgs.permittedInsecurePackages;
          };
        };
      };
    };
}
