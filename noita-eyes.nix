# Cryptanalysis dev shell for the Noita Eye Messages research workspace
# (research/noita-eyes/). Enter with: nix develop .#noita-eyes
{
  perSystem =
    { pkgs, ... }:
    {
      make-shells.noita-eyes.packages = [
        (pkgs.python3.withPackages (
          ps: with ps; [
            numpy
            scipy
            sympy
            pandas
            matplotlib
            networkx
            more-itertools
            tqdm
            z3
          ]
        ))
        # randomness / entropy testing of candidate keystreams
        pkgs.ent
        # plotting gap spectra & frequency tables from the CLI
        pkgs.gnuplot
        # inspecting binary game assets for hidden key material
        pkgs.hexyl
        pkgs.binwalk
        # slicing/inspecting eye-glyph screenshots and wiki images
        pkgs.imagemagick
        pkgs.jq
      ];
    };
}
