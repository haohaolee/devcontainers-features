#!/usr/bin/env bash

source dev-container-features-test-lib
source test_functions.sh

check "configured user should exist" assert_user_exists "remote"
check "sudo should not be available" assert_command_is_not_available "sudo"
check "sudoers file should not exist for user" assert_sudoers_file_not_exists "remote"

reportResults
