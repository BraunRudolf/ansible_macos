#!/bin/bash

# Install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install ansible
brew install ansible

# Run ansible playbook
ansible-playbook -i inventory.ini playbook.yml -K
