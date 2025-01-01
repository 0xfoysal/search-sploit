#!/bin/bash

# Check for root permissions
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root (use sudo)."
    exit 1
fi

echo "[*] Checking for SearchSploit installation..."

# Check if SearchSploit is installed
if ! command -v searchsploit &> /dev/null; then
    echo "[*] SearchSploit not found. Installing it now..."

    # Update package list
    echo "[*] Updating package list..."
    apt update -y

    # Install exploitdb
    echo "[*] Installing exploitdb package..."
    apt install exploitdb -y

    # Verify installation
    if ! command -v searchsploit &> /dev/null; then
        echo "[!] SearchSploit installation failed."
        exit 1
    fi
else
    echo "[*] SearchSploit is already installed."
fi

# Update Exploit Database
echo "[*] Updating Exploit Database..."
searchsploit -u

# Verify database update
if [ $? -eq 0 ]; then
    echo "[*] Exploit Database successfully updated."
else
    echo "[!] Exploit Database update failed. Trying manual setup..."

    # Manual setup for Exploit Database
    echo "[*] Cloning Exploit Database from GitHub..."
    git clone https://github.com/offensive-security/exploitdb.git /usr/share/exploitdb
    ln -sf /usr/share/exploitdb/searchsploit /usr/bin/searchsploit

    echo "[*] Running manual database update..."
    searchsploit --update
fi

# Final check
echo "[*] Verifying SearchSploit installation..."
if command -v searchsploit &> /dev/null; then
    echo "[*] SearchSploit is successfully installed and ready to use."
    echo "Run 'searchsploit <keyword>' to start searching exploits."
else
    echo "[!] SearchSploit installation failed. Please troubleshoot manually."
    exit 1
fi
