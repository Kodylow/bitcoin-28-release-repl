# Setting up the environment

If you're running this in Replit, the environment is automatically configured for you. Just hit the "Run" button to start bitcoind on regtest in the background while you continue with the guide, and use 'bitcoin-cli' to talk to it (both will use the 28.0 version). Then whenever you enter a shell run `nix develop` to configure the dev shell with the correct environment variables for the bitcoin binaries.

While you're running through the tutorial, you can use `bitcoind-27` and `bitcoin-cli-27` to try out the previous versions and compare the behavior.

[Jump to the first feature tutorial](01-1p1c.md)

If you're running this locally, you'll need to download the binaries and set up the environment manually.

## Environment Configuration

The environment is managed using `flake.nix`. If you're using the Repl.it environment, everything will be automatically configured for you.

For local development:

1. Ensure you have Nix installed on your system.
2. Navigate to the project directory.
3. Run the following command to enter the development shell:

   ```
   nix develop
   ```

This will set up all necessary dependencies and configurations for you to work with both Bitcoin Core versions.

## Installing Bitcoin Core Versions

- Bitcoin Core 28.0 (latest version)
- Bitcoin Core 27.0 (previous version)

These are downloaded from `https://bitcoincore.org` using the script `scripts/download-core.sh`. If you're running this locally, run `just download-bitcoin` to download the correct binaries for your architecture.

## Command Aliases

By default, the following aliases are set to use Bitcoin Core 28.0:

- `bitcoin-cli`
- `bitcoind`

If you need to specify a particular version, you can use:

- `bitcoin-cli-28` for version 28.0
- `bitcoin-cli-27` for version 27.0

This allows you to easily compare behavior between versions when exploring new features.

Now that your environment is set up, you're ready to explore the new features of Bitcoin Core 28.0!
