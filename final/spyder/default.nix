{ config, pkgs, ... }:
{
  # https://github.com/NixOS/nixpkgs/issues/171613
  nixpkgs.overlays = [ (self: super: rec {
    python3 = super.python3.override {
      packageOverrides = pyself: pysuper: {
        autopep8 = pysuper.pkgs.python3Packages.callPackage ./autopep8 {};
        black = pysuper.pkgs.python3Packages.callPackage ./black {};
        ipykernel = pysuper.pkgs.python3Packages.callPackage ./ipykernel {};
        ipython = pysuper.pkgs.python3Packages.callPackage ./ipython {};
        jupyter-client = pysuper.pkgs.python3Packages.callPackage ./jupyter-client {};
        python-lsp-black = pysuper.pkgs.python3Packages.callPackage ./python-lsp-black {};
        python-lsp-server = pysuper.pkgs.python3Packages.callPackage ./python-lsp-server {};
        qdarkstyle = pysuper.pkgs.python3Packages.callPackage ./qdarkstyle {};
        qtconsole = pysuper.pkgs.python3Packages.callPackage ./qtconsole {};
        qtpy = pysuper.pkgs.python3Packages.callPackage ./qtpy {};
        spyder-kernels = pysuper.pkgs.python3Packages.callPackage ./spyder-kernels {};
        spyder = pysuper.pkgs.python3Packages.callPackage ./spyder {};
      };
    };
    python3Packages = python3.pkgs;
  }) ];
}
