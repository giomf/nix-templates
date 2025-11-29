{
  description = "A simple cpp flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };
  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      devShells.${system}.default = pkgs.mkShell.override { stdenv = pkgs.clangStdenv; } {
        nativeBuildInputs = with pkgs; [
          clang
          clang-tools
          cmake
          gnumake
          lldb
          just
        ];
      };
    };
}
