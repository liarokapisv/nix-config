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

      # TODO(playwright-mcp): remove this wrapper once the fix is upstreamed in nixpkgs.
      #   Track: https://github.com/NixOS/nixpkgs/issues/443704
      #   When the nixpkgs playwright-mcp wrapper itself works out-of-the-box (sets a
      #   writable user-data dir, or forces browserName=chromium + executablePath), delete
      #   `playwright-mcp-nix` and set `playwright.command = lib.getExe pkgs.playwright-mcp;`.
      #
      #   Bug: playwright-mcp defaults to the Chrome channel and tries to `mkdir` a
      #   profile/install dir inside the read-only $PLAYWRIGHT_BROWSERS_PATH (the Nix
      #   store), so every tool call fails with EACCES. PR #460313 fixed it for 0.0.41
      #   (writable mktemp user-data dir) but a later version bump dropped that line;
      #   master (0.0.76) is broken again, so bumping nixpkgs alone does NOT help. The
      #   wrapper's PLAYWRIGHT_MCP_BROWSER=chromium is ignored by this version.
      # NOTE: workaround = force the bundled chromium via --executable-path and keep the
      #   browser profile in memory with --isolated, so nothing is written to the store.
      #   Trade-off: --isolated means no persistent profile (cookies/logins) between runs.
      # Tripwire: warn when playwright-mcp moves off the version validated as broken, so
      # this workaround doesn't silently outlive the upstream fix. Re-test #443704 then.
      playwright-mcp-nix =
        lib.warnIf (pkgs.playwright-mcp.version != "0.0.69")
          "claude-code: playwright-mcp moved off 0.0.69 — re-test NixOS/nixpkgs#443704; the --isolated/--executable-path wrapper may no longer be needed"
          (
            pkgs.writeShellScriptBin "playwright-mcp-nix" ''
              exe=$(echo ${pkgs.playwright-driver.browsers}/chromium_headless_shell-*/chrome-headless-shell-linux64/chrome-headless-shell)
              exec ${lib.getExe pkgs.playwright-mcp} --headless --isolated --executable-path "$exe" "$@"
            ''
          );
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

            mcpServers = {
              nixos = {
                command = lib.getExe pkgs.mcp-nixos;
              };
              context7 = {
                command = lib.getExe pkgs.context7-mcp;
              };
              playwright = {
                command = lib.getExe playwright-mcp-nix;
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

              - Copy any git-ignored .envrc files in their appropriate folders.
                Projects may have multiple .envrc files in different folders, ensure
                all are properly copied and re-allowed if previously allowed.

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
