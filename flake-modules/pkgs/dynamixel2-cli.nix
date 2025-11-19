{
  perSystem =
    { pkgs, ... }:
    {
      packages.dynamixel2-cli = pkgs.callPackage (
        { rustPlatform, fetchFromGitHub }:
        rustPlatform.buildRustPackage rec {
          pname = "dynamixel2-cli";
          version = "0.9.1";
          src = fetchFromGitHub {
            owner = "robohouse-delft";
            repo = "dynamixel2-rs";
            hash = "sha256-LNLmcDPj4W8cuC+AdtMKI1/PhyYDy1XDLQ66UNQpqBE=";
            tag = "v${version}";
          };
          buildAndTestSubdir = "dynamixel2-cli";
          cargoHash = "sha256-2wnqYAYuJ0EK7+QaD2KulJJ8I0qEotBXkKeR8X8/pl8=";
        }
      ) { };
    };
}
