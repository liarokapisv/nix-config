{
  flake.modules.homeManager.config-claude-code =
    { pkgs, ... }:
    let
      superpowers = pkgs.fetchFromGitHub {
        owner = "obra";
        repo = "superpowers";
        rev = "f2cbfbefebbfef77321e4c9abc9e949826bea9d7"; # v5.1.0
        hash = "sha256-3E3rO6hR87JUfS3XV1Eaoz6SDWOftleWvN9UPNFEMjw=";
      };
    in
    {
      programs.claude-code = {
        enable = true;

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
    };
}
