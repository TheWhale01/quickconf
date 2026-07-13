{
  description = "Quickshell configuration used in https://github.com/TheWhale01/nixos-config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    quickshell = {
      url = "github:quickshell-mirror/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, quickshell, ...}:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
  in
  {
    devShells.${pkgs.stdenv.hostPlatform.system}.default = pkgs.mkShell {
      packages = [
        quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default
        pkgs.kdePackages.qtdeclarative
        pkgs.lm_sensors
      ];
      shellHook = ''
        export QMLLS_BUILD_DIRS=${pkgs.kdePackages.qtdeclarative}/lib/qt-6/qml:${quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default}/lib/qt-6/qml
        export QML2_IMPORT_PATH=$QMLLS_BUILD_DIRS:$PWD/src
        export QML_IMPORT_PATH=$QML2_IMPORT_PATH
      '';
    };
    apps.${pkgs.stdenv.hostPlatform.system}.default =
    let
      quickconf = pkgs.writeShellScriptBin "quickconf" ''
        rm -rf $HOME/.config/quickshell
        mkdir -p $HOME/.config/quickshell
        cp -r src/* $HOME/.config/quickshell
        quickshell
      '';
    in
    {
      type = "app";
      program = "${quickconf}/bin/quickconf";
    };
  };
}
