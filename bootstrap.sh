#!/bin/bash

# Exit immediately if a command fails
set -e

echo "--- Starting macOS Bootstrap ---"

# 1. Check for Xcode Command Line Tools
if ! xcode-select -p &> /dev/null; then
    echo "[SETUP] Installing Xcode Command Line Tools..."
    xcode-select --install
    
    echo "[WAIT] Please finish the Apple installation dialog before continuing."
    
    until xcode-select -p &> /dev/null; do
        sleep 5
    done
    echo "[DONE] Xcode Command Line Tools installed."
fi

# 2. Install Homebrew
if ! command -v brew &> /dev/null; then
    echo "[INSTALL] Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Activate Homebrew for the current session
    if [[ $(uname -m) == "arm64" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        eval "$(/usr/local/bin/brew shellenv)"
    fi
else
    echo "[SKIP] Homebrew already installed."
fi

# 3. Install Ansible
if ! command -v ansible &> /dev/null; then
    echo "[INSTALL] Installing Ansible via Homebrew..."
    brew install ansible
else
    echo "[SKIP] Ansible already installed."
fi

# 4. Install Required Collections
echo "[GALAXY] Installing Ansible Galaxy collections..."
ansible-galaxy collection install community.general

# 5. Run the Playbook
echo "[RUN] Executing Ansible Playbook..."
ansible-playbook bootstrap.yml --ask-become-pass

echo "--- Bootstrap Complete ---"
