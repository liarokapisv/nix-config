{ inputs, ... }:
{
  flake-file.inputs.pre-commit-hooks = {
    url = "github:cachix/pre-commit-hooks.nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  imports = [ inputs.pre-commit-hooks.flakeModule ];

  perSystem =
    {
      config,
      pkgs,
      ...
    }:
    {
      pre-commit.settings = {
        excludes = [
          "flake.lock"
          ".*\.patch"
        ];

        hooks = {
          # Nix formatting
          nixfmt-rfc-style.enable = true;

          # File hygiene
          trim-trailing-whitespace.enable = true;
          end-of-file-fixer.enable = true;
          mixed-line-endings.enable = true;

          # Format validation
          check-yaml.enable = true;
          check-json.enable = true;
          check-toml.enable = true;

          # Security
          detect-private-keys.enable = true;

          # Git
          check-added-large-files.enable = true;
          check-merge-conflicts.enable = true;
          check-case-conflicts.enable = true;
        };

      };

      make-shells.default = {
        packages = [
          pkgs.pre-commit
        ]
        ++ config.pre-commit.settings.enabledPackages;

        shellHook = config.pre-commit.shellHook;
      };
    };
}
