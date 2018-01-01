#!/usr/bin/env bash
set -o nounset
set -o pipefail
set -o errexit

if [ "$(hostname)" == "pluto.local" ]; then
    echo "Configured for pluto execution"
    declare -r cc_test_app_dir="cc_test_app"
    declare -r cc_test_module_dir="cc_test_module"
else
    declare -r cc_test_app_dir="cc-test-app-repo"
    declare -r cc_test_module_dir="cc-test-module-repo"
fi

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
    local -r br="$1"
    info "Commit to $br branch"
    pushd "$cc_test_app_dir" > /dev/null
    git fetch origin develop || die "git fetch develop failed"
    git fetch origin "$br"   || die "git fetch $br failed"
    git checkout "$br"       || die "git checkout $br failed"
    git rebase develop       || die "git rebase develop for $br failed"
    git push origin "$br"    || die "git push origin $br failed"
    popd > /dev/null
}

declare -r branch="$1"
commit_to_branch "$branch"
