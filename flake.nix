{
  description = "Xbox360 USB Gamepad Userspace Driver";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.11";
    flake-utils.url = "github:numtide/flake-utils";

    argparser.url = "gitlab:argparser/argparser/stable";
    argparser.inputs.nixpkgs.follows = "nixpkgs";
    argparser.inputs.flake-utils.follows = "flake-utils";

    tinycmmc.url = "gitlab:grumbel/cmake-modules";
    tinycmmc.inputs.nixpkgs.follows = "nixpkgs";
    tinycmmc.inputs.flake-utils.follows = "flake-utils";

    strutcpp.url = "gitlab:grumbel/strutcpp";
    strutcpp.inputs.nixpkgs.follows = "nixpkgs";
    strutcpp.inputs.flake-utils.follows = "flake-utils";
    strutcpp.inputs.tinycmmc.follows = "tinycmmc";

    logmich.url = "gitlab:logmich/logmich";
    logmich.inputs.nixpkgs.follows = "nixpkgs";
    logmich.inputs.flake-utils.follows = "flake-utils";
    logmich.inputs.tinycmmc.follows = "tinycmmc";

    uinpp.url = "gitlab:Grumbel/uinpp";
    uinpp.inputs.nixpkgs.follows = "nixpkgs";
    uinpp.inputs.flake-utils.follows = "flake-utils";
    uinpp.inputs.strutcpp.follows = "strutcpp";
    uinpp.inputs.logmich.follows = "logmich";
    uinpp.inputs.tinycmmc.follows = "tinycmmc";
  };

  outputs = { self, nixpkgs, flake-utils, argparser, tinycmmc, strutcpp, logmich, uinpp }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in rec {
        packages = flake-utils.lib.flattenTree {
          xboxdrv = pkgs.stdenv.mkDerivation {
            pname = "xboxdrv";
            version = "0.9.0";
            src = nixpkgs.lib.cleanSource ./.;
            nativeBuildInputs = [
              pkgs.cmake
              pkgs.pkg-config
            ];
            buildInputs = [
              argparser.defaultPackage.${system}
              logmich.defaultPackage.${system}
              strutcpp.defaultPackage.${system}
              uinpp.defaultPackage.${system}
              tinycmmc.defaultPackage.${system}

              pkgs.at-spi2-core
              pkgs.bluez
              pkgs.dbus-glib
              pkgs.epoxy
              pkgs.fmt
              pkgs.glib
              pkgs.gobject-introspection
              pkgs.gtest
              pkgs.gtk3
              pkgs.libdatrie
              pkgs.libselinux
              pkgs.libsepol
              pkgs.libthai
              pkgs.libudev
              pkgs.libusb1
              pkgs.libxkbcommon
              pkgs.pcre
              pkgs.python3
              pkgs.python3Packages.dbus-python
              pkgs.util-linux
              pkgs.xorg.libX11
              pkgs.xorg.libXdmcp
              pkgs.xorg.libXtst
            ];
          };
        };
        defaultPackage = packages.xboxdrv;
      });
}
