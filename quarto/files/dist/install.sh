#!/bin/bash
set -e

# Initialize variables
GLOBAL_INSTALL=false
LOCAL_INSTALL=false

# Parse flag arguments
while getopts "gl" opt; do
  case $opt in
    g)
      GLOBAL_INSTALL=true
      ;;
    l)
      LOCAL_INSTALL=true
      ;;
    *)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done


# Determine the user's platform (Linux or macOS) and CPU architecture
OS_TYPE="$(uname -s)"
CPU_ARCH="$(uname -m)"

# Define the URLs for different architectures
BASE_URL="https://github.com/reproduce-work/rw-main-site/releases/download/v0.0.1/"
CLI_URL_LINUX_X64="${BASE_URL}reproduce-work-linux-x64"
CLI_URL_LINUX_ARM64="${BASE_URL}reproduce-work-linux-arm64"
CLI_URL_MACOS_X64="${BASE_URL}reproduce-work-macos-x64"
CLI_URL_MACOS_ARM64="${BASE_URL}reproduce-work-macos-arm64"

# Determine the appropriate CLI URL based on the user's platform and architecture
if [ "$OS_TYPE" == "Linux" ]; then
  if [ "$CPU_ARCH" == "x86_64" ]; then
    CLI_URL="$CLI_URL_LINUX_X64"
  elif [[ "$CPU_ARCH" == "arm64" || "$CPU_ARCH" == "aarch64" ]]; then
    CLI_URL="$CLI_URL_LINUX_ARM64"
  else
    echo "Unsupported architecture: $CPU_ARCH. Exiting."
    exit 1
  fi
elif [ "$OS_TYPE" == "Darwin" ]; then
  if [ "$CPU_ARCH" == "x86_64" ]; then
    CLI_URL="$CLI_URL_MACOS_X64"
  elif [ "$CPU_ARCH" == "arm64" ]; then
    CLI_URL="$CLI_URL_MACOS_ARM64"
  else
    echo "Unsupported architecture: $CPU_ARCH. Exiting."
    exit 1
  fi
else
  echo "Unsupported platform: $OS_TYPE. If on Windows, try using WSL."
  exit 1
fi



# Determine the installation method
if [ "$GLOBAL_INSTALL" = true ]; then
  INSTALL_DIR="/usr/local/bin"
elif [ "$LOCAL_INSTALL" = true ]; then
  INSTALL_DIR="./rw-project"
  # Create the directory if it doesn't exist
  if [ ! -d "$INSTALL_DIR" ]; then
    mkdir "$INSTALL_DIR"
  fi
else
  echo "Choose an installation method:"
  echo "1. Install globally in existing PATH"
  echo "2. Create a new folder at ./rw-project and download for single project use"
  read -p "Enter the number corresponding to your choice: " choice < /dev/tty

  case "$choice" in
    1)
      INSTALL_DIR="/usr/local/bin"
      ;;
    2)
      INSTALL_DIR="./rw-project"
      # Create the directory if it doesn't exist
      if [ ! -d "$INSTALL_DIR" ]; then
        mkdir "$INSTALL_DIR"
      fi
      ;;
    *)
      echo "Invalid choice. Exiting."
      exit 1
      ;;
  esac
fi


echo "Downloading..."

# Download the CLI tool to a temporary file
if ! curl -sSL "$CLI_URL" -o "rw.tmp"; then
    echo "Error: Failed to download the CLI tool from $CLI_URL."
    exit 1
fi

# Function to install the CLI tool
install_cli() {
    # Move and set execute permissions
    if ! mv "rw.tmp" "$INSTALL_DIR/rw"; then
        echo "Error: Failed to move the CLI tool to $INSTALL_DIR."
        exit 1
    fi
    if ! chmod +x "$INSTALL_DIR/rw"; then
        echo "Error: Failed to make the CLI tool executable."
        exit 1
    fi
    echo "Installation complete. The CLI tool is installed in $INSTALL_DIR."
}

# Check if the user has write permissions to the installation directory
if [ -w "$INSTALL_DIR" ]; then
    install_cli
else
    echo "You need sudo access to install to $INSTALL_DIR; enter your password to continue or try installing again using the local installation method (option 2)."
    if sudo -v; then
        sudo bash -c "$(declare -f install_cli); INSTALL_DIR='$INSTALL_DIR'; install_cli"
    else
        echo "Error: Failed to obtain sudo access."
        exit 1
    fi
fi

echo "Installation complete. The reproduce.work CLI tool is installed in $INSTALL_DIR."


if [ "$choice" -eq 1 ]; then
  echo "You can now run reproduce.work directly from the command line."
  echo "Example: rw <command>"
elif [ "$choice" -eq 2 ]; then
  echo "You can now use reproduce.work from within the folder $(dirname -- "$(pwd)/$INSTALL_DIR")/$(basename -- "$(pwd)/$INSTALL_DIR")."
  echo "Example usage:"
  echo "    cd $(dirname -- "$(pwd)/$INSTALL_DIR")/$(basename -- "$(pwd)/$INSTALL_DIR")"
  echo "    ./rw <command>"
fi