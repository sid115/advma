{
  description = "Advanced Mathematics Exercises";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  outputs =
    {
      self,
      nixpkgs,
      ...
    }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      nixpkgsFor = forAllSystems (
        system:
        import nixpkgs {
          inherit system;
          overlays = [ self.overlays.default ];
        }
      );
    in
    {
      overlays.default = final: prev: { };

      packages = forAllSystems (system: { });

      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgsFor.${system};
          python = pkgs.python312;
        in
        {
          default = self.devShells.${system}.venv;
          venv = pkgs.mkShell {
            buildInputs = [
              python
            ]
            ++ [
              (python.withPackages (
                p: with p; [
                  pip
                ]
              ))
            ]
            ++ (with pkgs; [
              gnumake
              gnuplot
              texliveFull
              texlivePackages.gnuplottex
            ]);
            # FIXME
            # shellHook = ''
            #   export C_INCLUDE_PATH="${pkgs.linuxHeaders}/include"
            #   export LD_LIBRARY_PATH="${
            #     with pkgs;
            #     lib.makeLibraryPath [
            #       dbus
            #       fontconfig
            #       freetype
            #       glib
            #       libGL
            #       libx11
            #       libxcb
            #       libxkbcommon
            #       nss
            #       stdenv.cc.cc
            #       zstd
            #     ]
            #   }"
            #   python -m venv .venv
            #   source .venv/bin/activate
            #   pip install -r requirements.txt
            # '';
          };
        }
      );
    };
}
