{
  flake.modules.homeManager.config-claude-code =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      superpowers = pkgs.fetchFromGitHub {
        owner = "obra";
        repo = "superpowers";
        rev = "f2cbfbefebbfef77321e4c9abc9e949826bea9d7"; # v5.1.0
        hash = "sha256-3E3rO6hR87JUfS3XV1Eaoz6SDWOftleWvN9UPNFEMjw=";
      };
    in
    {
      config = lib.mkMerge [
        {
          programs.claude-code = {
            settings = {
              permissions.defaultMode = "plan";
              skipAutoPermissionPrompt = true;
              attribution = {
                commit = "";
                pr = "";
              };
            };

            context = ''
              # Environment

              This machine runs NixOS with flakes enabled. Treat Nix as the
              source of truth for tooling.

              ## Running tools

              - For one-off binaries that aren't already on PATH, use flake
                syntax: `nix shell nixpkgs#<pkg> -c <cmd>`.
              - For multiple tools at once:
                `nix shell nixpkgs#foo nixpkgs#bar -c <cmd>`.
              - If a project provides a dev shell, use `nix develop` from the
                project root rather than ad-hoc installs.

              ## When using worktrees

              - Copy any git-ignored .envrc files in their appropriate folders

              ## Do not

              - **Never** use `nix profile install`, `nix-env -i`, or any other
                imperative install command — it mutates user state outside the
                declarative config and creates drift.
              - **Never** use the channels-era `nix-shell -p <pkg>` syntax;
                always prefer the flake form above.
              - Don't suggest adding things to PATH manually or sourcing
                scripts from arbitrary locations to "make a tool available" —
                use `nix shell` for the duration you need it.
            '';

            plugins = [ superpowers ];
          };
        }
        (lib.mkIf (config.services.litellm.enable or false) {
          home.packages = [
            (pkgs.writeShellScriptBin "claude-litellm" ''
              exec env \
                ANTHROPIC_BASE_URL=http://localhost:${toString config.services.litellm.port} \
                ANTHROPIC_MODEL=claude-opus-4-6 \
                ANTHROPIC_SMALL_FAST_MODEL=claude-haiku-4-5-20251001 \
                ANTHROPIC_DEFAULT_OPUS_MODEL=claude-opus-4-6 \
                ANTHROPIC_DEFAULT_OPUS_MODEL_NAME="Opus 4.6 (Copilot)" \
                ANTHROPIC_DEFAULT_SONNET_MODEL=claude-sonnet-4-6 \
                ANTHROPIC_DEFAULT_SONNET_MODEL_NAME="Sonnet 4.6 (Copilot)" \
                ANTHROPIC_DEFAULT_HAIKU_MODEL=claude-haiku-4-5-20251001 \
                ANTHROPIC_DEFAULT_HAIKU_MODEL_NAME="Haiku 4.5 (Copilot)" \
                CLAUDE_CODE_ENABLE_GATEWAY_MODEL_DISCOVERY=1 \
                claude "$@"
            '')
          ];
        })
      ];
    };
}
