{
  description = "Lua development environment with Neovim and LSP";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05"; # or unstable
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.simpleFlake {
      inherit self nixpkgs;
      name = "lua-dev-env";
      shell = { pkgs }:
        pkgs.mkShell {
          buildInputs = [
            pkgs.lua5_4              # Lua itself
            pkgs.love
          ];
        };
    };
}

