{
  description = "A simple zephyr west workspace flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Only used to read scripts/requirements.txt for the Python env.
    zephyr.url = "github:zephyrproject-rtos/zephyr";
    zephyr.flake = false;

    zephyr-nix.url = "github:nix-community/zephyr-nix";
    zephyr-nix.inputs.nixpkgs.follows = "nixpkgs";
    zephyr-nix.inputs.zephyr.follows = "zephyr";
  };
  outputs =
    { nixpkgs, zephyr-nix, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      zephyr = zephyr-nix.packages.${system};

      # zephyr/SDK_VERSION is 1.0.x
      zephyrSdk = zephyr."sdk-1_0".override {
        targets = [
          "arm-zephyr-eabi"
          "x86_64-zephyr-elf"
        ];
      };
    in
    {
      devShells.${system}.default =
        (pkgs.buildFHSEnv {
          name = "Zephyr dev shell";
          targetPkgs =
            pkgs: with pkgs; [
              # tree-sitter-cmake (compliance checks only) is not in nixpkgs;
              # spsdk-pyocd's runtime check fails on its circular spsdk dep.
              (zephyr.pythonEnv.override {
                packageOverrides = _: super: {
                  tree-sitter-cmake = null;
                  spsdk-pyocd = super.spsdk-pyocd.overridePythonAttrs { dontCheckRuntimeDeps = true; };
                };
              })
              zephyrSdk
              stdenv.cc.cc.lib
              cmake
              ninja
              dtc
              gperf
              gcc13
              gnumake
              git
              qemu
              just
            ];
          runScript = "fish";
          profile = ''
            export ZEPHYR_SDK_INSTALL_DIR=${zephyrSdk}
            export ZEPHYR_TOOLCHAIN_VARIANT=zephyr
          '';
        }).env;
    };
}
