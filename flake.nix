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
    quickconf-src = pkgs.stdenv.mkDerivation {
      name = "quickconf-src";
      src = ./src;
      installPhase = ''
        mkdir -p $out
        cp -r * $out/
      '';
    };
    deps = [
      quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default
      pkgs.lm_sensors
      pkgs.power-profiles-daemon
      pkgs.acpi
      pkgs.brightnessctl
      pkgs.pulseaudio
      pkgs.pavucontrol
      pkgs.iwgtk
      pkgs.blueman
      pkgs.bluez
      pkgs.procps
    ];
  in
  {
    packages.${pkgs.stdenv.hostPlatform.system}.default = pkgs.writeShellApplication {
      name = "quickconf";
      runtimeInputs = deps;
      text = ''
        exec quickshell -p "${quickconf-src}/shell.qml" "$@"
      '';
    };
    devShells.${pkgs.stdenv.hostPlatform.system}.default = pkgs.mkShell {
      packages = deps ++ [pkgs.kdePackages.qtdeclarative];
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
