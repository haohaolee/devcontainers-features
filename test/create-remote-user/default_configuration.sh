#!/usr/bin/env bash

source dev-container-features-test-lib
source test_functions.sh

check "configured user should exist" assert_user_exists "remote"
check "sudo should be available" assert_command_is_available "sudo"
check "password for user should be set" assert_password_is_set "remote" "remote"
check "sudoers file should exist for user" assert_sudoers_file_exists "remote"
check "user should require password for sudo" assert_sudo_requires_password "remote" "remote"

reportResults
