{
  perSystem =
    { pkgs, ... }:
    {
      packages.zsh-completion-sync = pkgs.callPackage (
        {
          lib,
          stdenvNoCC,
          fetchFromGitHub,
        }:

        stdenvNoCC.mkDerivation (finalAttrs: {
          pname = "zsh-completion-sync";
          version = "v0.2.0";

          src = fetchFromGitHub {
            owner = "BronzeDeer";
            repo = finalAttrs.pname;
            rev = finalAttrs.version;
            sha256 = "sha256-yZMw1Oev8Ho/uts56Ihn4gu3NGGZKCwPvq5kHkF3ReA=";
          };

          strictDeps = true;
          dontBuild = true;

          installPhase = ''
            mkdir -p $out/share/zsh-completion-sync
            cp zsh-completion-sync.plugin.zsh $out/share/zsh-completion-sync
          '';

          meta = with lib; {
            description = "A zsh plugin that automatically loads completions added dynamically to FPATH or XDG_DATA_DIRS";
            homepage = "https://github.com/BronzeDeer/zsh-completion-sync";
            license = licenses.asl20;
            platforms = platforms.unix;
            maintainers = [ maintainers.liarokapisv ];
          };
        })
      ) { };
    };
}
