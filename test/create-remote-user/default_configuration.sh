#!/usr/bin/env bash

source dev-container-features-test-lib
source test_functions.sh

check "configured user should exist" assert_user_exists "remote"
check "sudo should be available" assert_command_is_available "sudo"
check "password for user should be set" assert_password_is_set "remote" "remote"
check "sudoers file should exist for user" assert_sudoers_file_exists "remote"
check "sudoers file should not contain NOPASSWD" assert_sudoers_file_no_nopasswd "remote"
check "user should require password for sudo" assert_password_required_sudo "remote"

reportResults
