#!/bin/bash

# Set variables
VERSIONS=("28.0")
CHECKSUM_FILE="SHA256SUMS"

# Detect architecture
ARCH=$(uname -m)
OS=$(uname -s | tr '[:upper:]' '[:lower:]')

# Function to determine file name based on architecture and OS
get_file_name() {
    local version=$1
    case "$ARCH" in
        x86_64)
            case "$OS" in
                linux) echo "bitcoin-$version-x86_64-linux-gnu.tar.gz" ;;
                darwin) echo "bitcoin-$version-x86_64-apple-darwin.tar.gz" ;;
                *) echo "Unsupported OS: $OS"; exit 1 ;;
            esac
            ;;
        aarch64|arm64)
            case "$OS" in
                linux) echo "bitcoin-$version-aarch64-linux-gnu.tar.gz" ;;
                darwin) echo "bitcoin-$version-arm64-apple-darwin.tar.gz" ;;
                *) echo "Unsupported OS: $OS"; exit 1 ;;
            esac
            ;;
        armv7l)
            echo "bitcoin-$version-arm-linux-gnueabihf.tar.gz"
            ;;
        *)
            echo "Unsupported architecture: $ARCH"
            exit 1
            ;;
    esac
}

# Function to download and install a specific version
download_and_install() {
    local VERSION=$1
    local INSTALL_DIR="bitcoin-$VERSION"
    local BASE_URL="https://bitcoincore.org/bin/bitcoin-core-$VERSION"
    local FILE_NAME=$(get_file_name $VERSION)

    echo "Processing Bitcoin Core $VERSION..."

    # Remove existing directory if present
    if [ -d "$INSTALL_DIR" ]; then
        echo "Removing existing $INSTALL_DIR directory..."
        rm -rf "$INSTALL_DIR"
    fi

    # Create the installation directory
    mkdir -p "$INSTALL_DIR"
    cd "$INSTALL_DIR"

    # Download the Bitcoin Core tarball
    echo "Downloading Bitcoin Core $VERSION for $ARCH..."
    wget "$BASE_URL/$FILE_NAME"

    # Download the SHA256SUMS file
    wget "$BASE_URL/$CHECKSUM_FILE"

    # Verify the checksum
    echo "Verifying checksum..."
    sha256sum -c --ignore-missing "$CHECKSUM_FILE"

    if [ $? -ne 0 ]; then
        echo "Checksum verification failed for version $VERSION. Aborting installation."
        cd ..
        rm -rf "$INSTALL_DIR"
        return 1
    fi

    # Extract the tarball
    echo "Extracting files..."
    tar -xzf "$FILE_NAME" --strip-components=1

    # Clean up downloaded files
    rm "$FILE_NAME" "$CHECKSUM_FILE"

    cd ..

    echo "Bitcoin Core $VERSION has been installed in the '$INSTALL_DIR' directory."
    echo "You can now run './$INSTALL_DIR/bin/bitcoin-cli', './$INSTALL_DIR/bin/bitcoind', or './$INSTALL_DIR/bin/bitcoin-qt'."
}

# Download and install both versions
for VERSION in "${VERSIONS[@]}"; do
    download_and_install $VERSION
done

echo "Installation complete for Bitcoin Core versions ${VERSIONS[*]}."
