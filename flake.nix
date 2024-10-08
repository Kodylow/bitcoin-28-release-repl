{
  description = "Bitcoin development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = [ pkgs.bash ];
          shellHook = ''
            alias bitcoind='/home/runner/workspace/bitcoin-28.0/bin/bitcoind'
            alias bitcoin-cli='/home/runner/workspace/bitcoin-28.0/bin/bitcoin-cli'
            alias bitcoin-cli-28='/home/runner/workspace/bitcoin-28.0/bin/bitcoin-cli'
            alias bitcoind-28='/home/runner/workspace/bitcoin-28.0/bin/bitcoind -regtest'
            alias bitcoind-27='/home/runner/workspace/bitcoin-27.0/bin/bitcoind -regtest'
            alias bitcoin-cli-27='/home/runner/workspace/bitcoin-27.0/bin/bitcoin-cli'
            echo "aliases set"
          '';
        };
      }
    );
}
