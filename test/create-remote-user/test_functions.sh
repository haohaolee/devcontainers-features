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

# Test sudo without password - requires prior authentication to clear cache
assert_passwordless_sudo() {
  local username="$1"
  local password="$2"
  
  # First verify user has sudo privileges using password
  if ! echo "$password" | timeout 5 sudo -S -l >/dev/null 2>&1; then
    echo "User $username does not have sudo privileges"
    exit 1
  fi
  
  # Clear sudo cache to test fresh authentication
  sudo -k 2>/dev/null || true
  
  # Test if user can run sudo without password
  if ! timeout 5 sudo -n true 2>/dev/null; then
    echo "User $username has sudo privileges but requires password (NOPASSWD not configured)"
    exit 1
  fi
  
  echo "User $username can run sudo without password (NOPASSWD configured)"
}

assert_sudoers_file_exists() {
  local username="$1"
  local sudoers_file="/etc/sudoers.d/${username}-sudo"
  
  if [ ! -f "$sudoers_file" ]; then
    echo "Sudoers file $sudoers_file does not exist"
    exit 1
  fi
  
  local perms=$(stat -c "%a" "$sudoers_file" 2>/dev/null)
  if [ "$perms" != "440" ]; then
    echo "Sudoers file $sudoers_file has incorrect permissions: $perms (expected: 440)"
    exit 1
  fi
}

assert_sudoers_file_not_exists() {
  local username="$1"
  local sudoers_file="/etc/sudoers.d/${username}-sudo"
  
  if [ -f "$sudoers_file" ]; then
    echo "Sudoers file $sudoers_file should not exist"
    exit 1
  fi
}

# Test sudo requires password - uses known password to verify access, then tests NOPASSWD
assert_sudo_requires_password() {
  local username="$1"
  local password="$2"
  
  # First verify user has sudo privileges using password
  if ! echo "$password" | timeout 5 sudo -S -l >/dev/null 2>&1; then
    echo "User $username does not have sudo privileges"
    exit 1
  fi
  
  # Clear sudo cache to test fresh authentication
  sudo -k 2>/dev/null || true
  
  # Verify NOPASSWD is NOT configured (sudo -n should fail)
  if timeout 5 sudo -n true 2>/dev/null; then
    echo "User $username can run sudo without password (NOPASSWD should not be configured)"
    exit 1
  fi
  
  echo "User $username has sudo privileges and requires password (NOPASSWD not configured)"
}
