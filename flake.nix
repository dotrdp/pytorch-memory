{
  description = "Sets up the environment for python(which relies on gcc headers)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    proxytunnel.url = "github:proxytunnel/proxytunnel";
  };

  outputs = {
    nixpkgs,
    proxytunnel,
    ...
  }: let
    system = "aarch64-linux";
    pkgs = import nixpkgs {
      inherit system;
      overlays = [
        proxytunnel.overlays.default
      ];
    };
  in {
    # Adds the `black` formatter for Python. Can be invoked via `nix fmt`
    formatter.${system} = pkgs.black;
    devShells.${system}.default = pkgs.mkShell {
      buildInputs = [
        # Allow gcc to link against glibc
        pkgs.glibc.dev
      ];

      packages = [

        # This project is managed by uv
        pkgs.uv


        # Add proxytunnel binary so SSH is possible onto servers
        pkgs.proxytunnel
      ];

      # Export the C compiler variables with the newly installed gcc/g++
   };
  };
}
