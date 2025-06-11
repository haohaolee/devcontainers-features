#!/usr/bin/env bash

# Checks if packages are installed and installs them if not
check_and_install() {
  for package in "$@"; do
    if ! dpkg -s "$package" >/dev/null 2>&1; then
      echo "$package is not installed - starting installation"
      if [ "$(find /var/lib/apt/lists/* | wc -l)" = "0" ]; then
        echo "Running apt-get update..."
        apt-get update -y
      fi
      apt-get -y install --no-install-recommends "$package"
    fi
  done
}

# Configures passwordless sudo for the specified user
configure_passwordless_sudo() {
  local username="$1"
  local sudoers_file="/etc/sudoers.d/${username}-sudo"
  
  # Create sudoers.d directory if it doesn't exist
  mkdir -p /etc/sudoers.d
  
  # Create the sudoers file for passwordless sudo
  echo "${username} ALL=(ALL) NOPASSWD:ALL" > "$sudoers_file"
  
  # Set proper permissions for the sudoers file
  chmod 440 "$sudoers_file"
  
  echo "Passwordless sudo configured for user $username"
}

# Configures password-required sudo for the specified user
configure_password_sudo() {
  local username="$1"
  local sudoers_file="/etc/sudoers.d/${username}-sudo"
  
  # Create sudoers.d directory if it doesn't exist
  mkdir -p /etc/sudoers.d
  
  # Create the sudoers file for password-required sudo
  echo "${username} ALL=(ALL:ALL) ALL" > "$sudoers_file"
  
  # Set proper permissions for the sudoers file
  chmod 440 "$sudoers_file"
  
  echo "Password-required sudo configured for user $username"
}

# Cleans APT's cache to keep devcontainer layers small
clean_package_cache() {
  apt-get clean
}