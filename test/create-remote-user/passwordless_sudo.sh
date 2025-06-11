#!/usr/bin/env bash

source dev-container-features-test-lib
source test_functions.sh

check "configured user should exist" assert_user_exists "remote"
check "sudo should be available" assert_command_is_available "sudo"
check "sudoers file should exist for user" assert_sudoers_file_exists "remote"
check "user should be able to run sudo without password" assert_passwordless_sudo "remote" "remote"

reportResults 