#!/bin/bash
set -e

# Determine the user's platform (Linux or macOS)
OS_TYPE="$(uname -s)"

# Define the URLs for Linux and macOS executables
CLI_URL_LINUX="https://github.com/reproduce-work/rw-main-site/releases/download/v0.0.1/reproduce-work-linux"
CLI_URL_MACOS="https://github.com/reproduce-work/rw-main-site/releases/download/v0.0.1/reproduce-work-macos"


# Determine the appropriate CLI URL based on the user's platform
if [ "$OS_TYPE" == "Linux" ]; then
  CLI_URL="$CLI_URL_LINUX"
elif [ "$OS_TYPE" == "Darwin" ]; then
  CLI_URL="$CLI_URL_MACOS"
else
  echo "Unsupported platform: $OS_TYPE.  If on Windows, try using WSL."
  exit 1
fi

# Determine the installation method based on user input
echo "Choose an installation method:"
echo "1. Install globally in existing PATH"
echo "2. Create a new folder at ./rw-project and download for single project use"

read -p "Enter the number corresponding to your choice: " choice < /dev/tty

case "$choice" in
  1)
    # Install in existing PATH
    INSTALL_DIR="/usr/local/bin"
    ;;
  2)
    # Download locally to the current directory
    INSTALL_DIR="./rw-project"

    # Create the directory if it doesn't exist
    if [ ! -d "$INSTALL_DIR" ]; then
      mkdir "$INSTALL_DIR"
    fi

    # If $INSTALL_DIR/rw already exists, prompt the user to overwrite
    if [ -f "$INSTALL_DIR/rw" ]; then
      read -p "rw already exists in $INSTALL_DIR. Overwrite? (y/n): " overwrite
      if [ "$overwrite" == "y" ]; then
        rm "$INSTALL_DIR/rw"
      else
        echo "Exiting."
        exit 1
      fi
    fi
    ;;
  *)
    echo "Invalid choice. Exiting."
    exit 1
    ;;
esac


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
  echo "You can now use reproduce.work from within the folder $(pwd)/$INSTALL_DIR."
  echo "Example usage:"
  echo "    cd $(pwd)/$INSTALL_DIR"
  echo "    rw <command>"
fi