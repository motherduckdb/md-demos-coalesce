#!/bin/bash

# small bash script to manage install/uninstall duckdb on Linux
set -e  # Exit on any error

# Set default version and installation path
DEFAULT_VERSION="0.9.1"
INSTALL_PATH="${HOME}/.local/bin"

# Function to get the system architecture
get_architecture() {
    local arch
    arch="$(uname -m)"
    case "$arch" in
        x86_64)
            echo "amd64"
            ;;
        aarch64)
            echo "aarch64"
            ;;
        *)
            echo "Unsupported architecture: $arch" >&2
            exit 1
            ;;
    esac
}

# Function to download DuckDB
download_duckdb() {
    local version="$1"
    local arch="$2"
    local url="https://github.com/duckdb/duckdb/releases/download/v${version}/duckdb_cli-linux-${arch}.zip"

    echo "Downloading DuckDB v${version} for ${arch} architecture..."
    # Using curl and unzip as they are commonly installed
    curl -L -o duckdb.zip "$url"
    unzip -o duckdb.zip -d "${INSTALL_PATH}"
    rm duckdb.zip
}


# Ensure that ~/.local/bin exists
mkdir -p "${INSTALL_PATH}"

# Parse command-line arguments
ACTION="$1"
VERSION="${2:-$DEFAULT_VERSION}"

# Execute the desired action
case "$ACTION" in
    install)
        ARCHITECTURE=$(get_architecture)
        download_duckdb "$VERSION" "$ARCHITECTURE"
        
        # Verify the installation
        if [ -x "$(command -v duckdb)" ]; then
            echo "DuckDB v${VERSION} installed successfully!"
        else
            echo "Error: DuckDB installation failed!" >&2
            exit 1
        fi
        ;;
    uninstall)
        if [ -x "${INSTALL_PATH}/duckdb" ]; then
            rm "${INSTALL_PATH}/duckdb"
            rm -r "${HOME}/.duckdb"
            echo "DuckDB uninstalled successfully!"
        else
            echo "Error: DuckDB is not installed!" >&2
            exit 1
        fi
        ;;
    *)
        echo "Usage: $0 <install|uninstall> [version]" >&2
        exit 1
        ;;
esac
