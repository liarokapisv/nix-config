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

      # Playwright browser automation via the CLI + Skill (replaces the old
      #   playwright-mcp server: the CLI is more token-efficient — no tool schemas
      #   or accessibility trees loaded into context). @playwright/cli is not in
      #   nixpkgs, so build it from the tagged source (it bundles playwright +
      #   playwright-core; all JS, no build).
      # Browser: playwright-core normally resolves a browser by a pinned Chromium
      #   *revision*, but nixpkgs' playwright-driver ships a different revision
      #   (core 1.63-alpha wants chromium-1209; the driver has 1217). Rather than
      #   match revisions, playwright-core's mcp/browser config honours
      #   $PLAYWRIGHT_MCP_EXECUTABLE_PATH, so we point the CLI straight at the
      #   bundled chrome-headless-shell and the revision never has to line up.
      #   Verified driving 1217 with core 1.63-alpha. This is version-tolerant, so
      #   no driver tripwire is needed (unlike the old --executable-path MCP hack).
      # Bump recipe: change version + tag, set both hashes to lib.fakeHash, build
      #   (first error gives the src hash, second the npmDepsHash).
      playwright-cli = pkgs.buildNpmPackage {
        pname = "playwright-cli";
        version = "0.1.18";
        src = pkgs.fetchFromGitHub {
          owner = "microsoft";
          repo = "playwright-cli";
          tag = "v0.1.18";
          hash = "sha256-E/AzDJhD12PWSaA3iRY+hloPsSWnAw18gTa/ItVhr3E=";
        };
        npmDepsHash = "sha256-3kqiQvGtZfsmLHVWeCSM1yOYb+ws2x1vMPC1OuvrKAI=";
        dontNpmBuild = true;
        # The playwright dep's postinstall would try to download browsers into the
        # build sandbox (no network, and we supply them via the driver anyway).
        env.PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";
      };

      # The skill's front-matter is `allowed-tools: Bash(playwright-cli:*)`, so the
      # binary must be named `playwright-cli` on PATH. This wrapper supplies that
      # name and forces the bundled nixpkgs chromium (see note above).
      playwright-cli-nix = pkgs.writeShellScriptBin "playwright-cli" ''
        exe=$(echo ${pkgs.playwright-driver.browsers}/chromium_headless_shell-*/chrome-headless-shell-linux64/chrome-headless-shell)
        exec env PLAYWRIGHT_MCP_BROWSER=chromium PLAYWRIGHT_MCP_EXECUTABLE_PATH="$exe" \
          ${playwright-cli}/bin/playwright-cli "$@"
      '';
    in
    {
      config = lib.mkMerge [
        {
          # Put the `playwright-cli` wrapper on PATH so the skill's
          # Bash(playwright-cli:*) calls resolve to the browser-wired bin.
          home.packages = [ playwright-cli-nix ];

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
              trello = {
                type = "http";
                url = "https://mcp.trello.com/v1";
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

              ## Containers as a fallback

              - Some projects target ecosystems that nixpkgs doesn't
                reasonably cover (e.g. ROS2) and ship a Dockerfile or a
                Compose project as the intended way to run. When the
                toolchain genuinely can't be reproduced with
                `nix shell` / `nix develop`, check whether the project is
                *meant* to be run through its containers.
              - If it is, run it via the project's containers rather than
                rebuilding the environment in Nix. This machine has Docker
                enabled: use `docker compose ...` for Compose projects, or
                build/run the Dockerfile directly.
              - Nix first — reach for containers only when a large missing
                ecosystem makes Nix impractical, not as a shortcut around
                packaging something nixpkgs already provides.

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

            # Install the CLI's Skill declaratively instead of the imperative
            # `playwright-cli install --skills`. Symlinks SKILL.md + references/
            # into ~/.claude/skills/playwright-cli/.
            skills.playwright-cli = "${playwright-cli}/lib/node_modules/@playwright/cli/skills/playwright-cli";
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
