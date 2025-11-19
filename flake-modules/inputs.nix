# modules/inputs.nix
{ inputs, ... }:
{
  flake-file = {
    inputs = {
      nixpkgs = {
        url = "github:NixOS/nixpkgs/nixos-unstable";
      };
      stylix = {
        url = "github:danth/stylix";
        inputs.nixpkgs.follows = "nixpkgs";
      };
      firefox-addons = {
        url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
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
      pre-commit-hooks = {
        url = "github:cachix/pre-commit-hooks.nix";
        inputs.nixpkgs.follows = "nixpkgs";
      };
      make-shell.url = "github:nicknovitski/make-shell";
      nixpkgs-libcef.url = "github:NixOS/nixpkgs/de69d2ba6c70e747320df9c096523b623d3a4c35";
    };
  };
}
