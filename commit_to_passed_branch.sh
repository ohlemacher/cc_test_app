#!/usr/bin/env bash
set -o nounset
set -o pipefail
set -o errexit

declare -r gh_user="ohlemacher"
declare -r gh_token="dbd9a1b24133b564320e4fd23e2b30504fbaa55a"
declare -r cc_test_app_dir="cc-test-app-repo"
declare -r cc_test_app_passed_unit_teste_dir="cc-test-app-repo-passed-unit-tests"
declare -r cc_test_module_dir="cc-test-module-repo"
export GIT_SSH_COMMAND="ssh -o StrictHostKeyChecking=no"

function info {
    local msg="$1"
    (>&2 echo "===== Info: $msg")  # Subshell avoids interactions with other redirections
}

function die {
    local msg="$1"
    (>&2 echo "!!!!! Fatal: $msg")  # Subshell avoids interactions with other redirections
    exit 1
}

function install_prereqs {
    info "Prereq: None required"
}

function commit_to_branch {
    # Use "git remote add <NAME> <PATH>" to rebase.
    local -r br="$1"

    pushd ${cc_test_app_dir} > /dev/null
        # Create a branch named tested_branch from the tested commit
        local -r tested_commit="$(git rev-parse HEAD)"
        local -r tested_path="$(realpath .)"
        git branch tested_branch "$tested_commit" || die "git branch tested_branch $tested_commit failed"
    popd > /dev/null

    info "Commit to $br branch. Move HEAD to $tested_commit"

    pushd cc-test-app-repo-passed-unit-tests > /dev/null
        # Add and fetch tested_remote. Then rebase on it.
        git remote add tested_remote "$tested_path" || die "git remote add tested_remote $tested_path failed"
        git fetch tested_remote || die "git fetch tested_remote failed"
        git rebase tested_remote/tested_branch || die "git rebase tested_remote/tested_branch failed"
    popd > /dev/null
}

### MAIN ### 
declare -r branch="$1"
commit_to_branch "$branch"
