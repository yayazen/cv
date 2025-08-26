{
  description = "My CV";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      tex = pkgs.texlive.combine {
        inherit (pkgs.texlive)
          scheme-medium
          latex-bin
          latexmk
          preprint
          titlesec
          marvosym
          enumitem
          libertine
          fontawesome5
          ;
      };
    in
    {
      devShells.x86_64-linux.default = pkgs.mkShell {
        buildInputs = self.packages.x86_64-linux.cv.buildInputs;

        #shellHook = ''
        #  $SHELL
        #'';
      };

      packages.x86_64-linux.cv = pkgs.stdenvNoCC.mkDerivation {
        name = "cv-pdf";
        src = self;
        buildInputs = [
          pkgs.coreutils
          tex
        ];
        phases = [
          "unpackPhase"
          "buildPhase"
          "installPhase"
        ];
        buildPhase = ''
          export TEXMFVAR=$(mktemp -d)
          export SOURCE_DATE_EPOCH=${toString self.lastModified}
          make
          rm -rf $TEXMFVAR
        '';
        installPhase = ''
          mkdir -p $out
          cp cv_fr.pdf cv_en.pdf $out/
        '';
      };

      packages.x86_64-linux.default = self.packages.x86_64-linux.cv;
      
    };
}
