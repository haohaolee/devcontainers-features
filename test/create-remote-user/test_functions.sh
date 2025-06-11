#!/usr/bin/env bash

assert_user_exists() {
  if ! id "$1"; then
    exit 1
  fi
}

assert_user_is_in_group() {
  if ! id -nG "$1" | grep -qw "$2"; then
    exit 1
  fi
}

assert_user_is_not_in_group() {
  if id -nG "$1" | grep -qw "$2"; then
    exit 1
  fi
}

assert_command_is_available() {
  if ! which "$1"; then
    exit 1
  fi
}

assert_command_is_not_available() {
  if which "$1"; then
    exit 1
  fi
}

assert_password_is_set() {
  id
  if ! echo "$2" | sudo -S -l; then
    exit 1
  fi
}

# Check if user can run sudo without password
assert_passwordless_sudo() {
  local username="$1"
  
  # Try to run sudo without password (using timeout to avoid hanging)
  if ! timeout 5 sudo -n true 2>/dev/null; then
    echo "User $username cannot run sudo without password"
    exit 1
  fi
}

# Check if sudoers file exists for the user
assert_sudoers_file_exists() {
  local username="$1"
  local sudoers_file="/etc/sudoers.d/${username}-sudo"
  
  if [ ! -f "$sudoers_file" ]; then
    echo "Sudoers file $sudoers_file does not exist"
    exit 1
  fi
}

# Check if sudoers file does not exist for the user
assert_sudoers_file_not_exists() {
  local username="$1"
  local sudoers_file="/etc/sudoers.d/${username}-sudo"
  
  if [ -f "$sudoers_file" ]; then
    echo "Sudoers file $sudoers_file should not exist"
    exit 1
  fi
}

# Check if sudoers file contains NOPASSWD
assert_sudoers_file_has_nopasswd() {
  local username="$1"
  local sudoers_file="/etc/sudoers.d/${username}-sudo"
  
  if ! grep -q "NOPASSWD" "$sudoers_file"; then
    echo "Sudoers file $sudoers_file does not contain NOPASSWD"
    exit 1
  fi
}

# Check if sudoers file does not contain NOPASSWD
assert_sudoers_file_no_nopasswd() {
  local username="$1"
  local sudoers_file="/etc/sudoers.d/${username}-sudo"
  
  if grep -q "NOPASSWD" "$sudoers_file"; then
    echo "Sudoers file $sudoers_file should not contain NOPASSWD"
    exit 1
  fi
}

# Check if user requires password for sudo
assert_password_required_sudo() {
  local username="$1"
  
  # Try to run sudo without password - should fail
  if timeout 5 sudo -n true 2>/dev/null; then
    echo "User $username can run sudo without password but shouldn't"
    exit 1
  fi
}
