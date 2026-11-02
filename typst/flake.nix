{
  description = "SRA flake for Typst documents";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }: let
    supportedSystems = [ "aarch64-linux" "x86_64-linux"
                         "aarch64-darwin" "x86_64-darwin" ];
    forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
  in {
    devShells = forAllSystems (system: let pkgs = nixpkgs.legacyPackages.${system}; in {
      default = pkgs.mkShellNoCC {
        buildInputs = with pkgs; [
          git
          typst
          tinymist
          typstyle
        ];
        # TODO: Add Latex and adjust makefile for TikZ?
        env = {
          # Make loose fonts available here
          TYPST_FONT_PATHS = "fonts";
        };
      };
    });
  };
}
